import 'package:bloc/bloc.dart';
import 'package:tark_test_task/src/data/github_repository.dart';
import 'package:tark_test_task/src/domain/bloc/github_event.dart';
import 'package:tark_test_task/src/domain/bloc/github_state.dart';
import 'package:tark_test_task/src/domain/model/github_profile.dart';

class GithubUserBloc extends Bloc<GithubUserEvent, GithubUserState> {
  final GithubRepository _githubRepository;

  GithubUserBloc({required GithubRepository githubRepository})
      : _githubRepository = githubRepository,
        super(GithubUserInitial()) {
    on<FetchGithubUsers>(_onFetchGithubUsers);
    on<SortGithubUsers>(_onSortGithubUsers);
    on<LoadMoreGithubUsers>(_onLoadMoreGithubUsers);
  }

  Future<void> _onFetchGithubUsers(
      FetchGithubUsers event, Emitter<GithubUserState> emit) async {
    emit(GithubUserLoading());
    try {
      List<GithubProfile> usersList = await _githubRepository.getUsersInRange(
        pattern: event.pattern,
        since: event.since,
        perPage: event.perPage,
      );
      usersList.sort((a, b) =>
          a.login.toLowerCase()[0].compareTo(b.login.toLowerCase()[0]));
      final usersMap = {for (var user in usersList) user.login: user};
      emit(GithubUserLoaded(users: usersMap, filteredUsers: usersMap));

      // Fetch details for each user
      for (var user in usersMap.values) {
        try {
          final detailedUser =
              await _githubRepository.getUserDetails(user.login);

          // Update the specific user in the maps
          emit((state as GithubUserLoaded).copyWith(
            users: {
              ...((state as GithubUserLoaded).users)
                ..update(user.login, (value) => detailedUser)
            },
            filteredUsers: {
              ...((state as GithubUserLoaded).filteredUsers)
                ..update(user.login, (value) => detailedUser)
            },
          ));
        } catch (e) {
          // Handle individual user detail fetch error if necessary
        }
      }
    } catch (e) {
      emit(GithubUserError(message: e.toString()));
    }
  }

  void _onSortGithubUsers(
      SortGithubUsers event, Emitter<GithubUserState> emit) {
    if (state is GithubUserLoaded) {
      final loadedState = state as GithubUserLoaded;
      late RegExp regex;
      switch (event.pattern) {
        case ListPattern.ah:
          regex = RegExp(r'^[A-H]', caseSensitive: false);
          break;
        case ListPattern.ip:
          regex = RegExp(r'^[I-P]', caseSensitive: false);
          break;
        case ListPattern.qz:
          regex = RegExp(r'^[Q-Z]', caseSensitive: false);
          break;
      }
      final sortedUsers = {
        for (var user in loadedState.users.values
            .where((user) => regex.hasMatch(user.login[0])))
          user.login: user
      };
      emit(GithubUserLoaded(
          users: loadedState.users, filteredUsers: sortedUsers));
    }
  }

  Future<void> _onLoadMoreGithubUsers(
      LoadMoreGithubUsers event, Emitter<GithubUserState> emit) async {
    if (state is GithubUserLoaded) {
      final loadedState = state as GithubUserLoaded;
      emit(loadedState.copyWith(isLoadingMore: true));
      final currentUsers = loadedState.users;
      print(currentUsers.length);
      try {
        final newUsersList = await _githubRepository.getUsersInRange(
          pattern: event.pattern,
          since: currentUsers.length,
          perPage: 100,
        );
        final newUsersMap = {for (var user in newUsersList) user.login: user};
        final allUsers = Map<String, GithubProfile>.from(currentUsers)
          ..addAll(newUsersMap);
        emit(GithubUserLoaded(
          users: allUsers,
          filteredUsers: allUsers,
          isLoadingMore: false,
        ));
        // Fetch details for each new user
        for (var user in newUsersMap.values) {
          if (user.followers != null) {
            continue;
          }
          try {
            final detailedUser =
                await _githubRepository.getUserDetails(user.login);
            // Update the specific user in the maps
            emit((state as GithubUserLoaded).copyWith(
              users: {
                ...((state as GithubUserLoaded).users)
                  ..update(user.login, (value) => detailedUser)
              },
              filteredUsers: {
                ...((state as GithubUserLoaded).filteredUsers)
                  ..update(user.login, (value) => detailedUser)
              },
            ));
          } catch (e) {
            // Handle individual user detail fetch error if necessary
          }
        }
      } catch (e) {
        emit(GithubUserError(message: e.toString()));
      }
    }
  }
}

enum ListPattern {
  ah('A-H'),
  ip('I-P'),
  qz('Q-Z');

  final String pattern;

  const ListPattern(this.pattern);
}
