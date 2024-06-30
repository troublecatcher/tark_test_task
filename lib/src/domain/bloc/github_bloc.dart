import 'dart:developer';

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
      emit(GithubUserLoaded(users: usersList));

      for (var user in usersList) {
        try {
          final detailedUser =
              await _githubRepository.getUserDetails(user.login);
          final updatedUsers = (state as GithubUserLoaded)
              .users
              .map((u) => u.login == user.login ? detailedUser : u)
              .toList();
          emit((state as GithubUserLoaded).copyWith(
            users: updatedUsers,
            filteredUsers: updatedUsers,
          ));
        } catch (e) {
          log(e.toString());
        }
      }
    } catch (e) {
      emit(GithubUserError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreGithubUsers(
      LoadMoreGithubUsers event, Emitter<GithubUserState> emit) async {
    if (state is GithubUserLoaded) {
      final loadedState = state as GithubUserLoaded;
      final currentUsers = loadedState.users;
      try {
        final newUsersList = await _githubRepository.getUsersInRange(
          pattern: event.pattern,
          since: currentUsers.length,
          perPage: 100,
        );
        final allUsers = List<GithubProfile>.from(currentUsers)
          ..addAll(newUsersList);
        emit(GithubUserLoaded(
          users: allUsers,
        ));
        for (var user in newUsersList) {
          if (user.followers != null) {
            continue;
          }
          try {
            final detailedUser =
                await _githubRepository.getUserDetails(user.login);
            final updatedUsers = (state as GithubUserLoaded)
                .users
                .map((u) => u.login == user.login ? detailedUser : u)
                .toList();
            emit((state as GithubUserLoaded).copyWith(
              users: updatedUsers,
              filteredUsers: updatedUsers,
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
