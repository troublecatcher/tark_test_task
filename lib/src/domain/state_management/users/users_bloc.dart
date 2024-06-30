import 'package:bloc/bloc.dart';
import 'package:tark_test_task/src/data/repository.dart';
import 'package:tark_test_task/src/domain/model/profile.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_event.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final Repository _githubRepository;

  UsersBloc({required Repository repository})
      : _githubRepository = repository,
        super(UsersInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<LoadMoreUsers>(_onLoadMoreUsers);
    on<UpdateUserDetails>(_onUpdateUserDetails);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    try {
      List<Profile> usersList = await _githubRepository.getUsersInRange(
        pattern: event.pattern,
        since: event.since,
        perPage: event.perPage,
      );
      usersList.sort((a, b) =>
          a.login.toLowerCase()[0].compareTo(b.login.toLowerCase()[0]));
      emit(UsersLoaded(users: usersList));
    } catch (e) {
      emit(UsersError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreUsers(
      LoadMoreUsers event, Emitter<UsersState> emit) async {
    if (state is UsersLoaded) {
      final loadedState = state as UsersLoaded;
      final currentUsers = loadedState.users;
      try {
        final newUsersList = await _githubRepository.getUsersInRange(
          pattern: event.pattern,
          since: currentUsers.length,
          perPage: 100,
        );
        final allUsers = List<Profile>.from(currentUsers)..addAll(newUsersList);
        emit(UsersLoaded(users: allUsers));
      } catch (e) {
        emit(UsersError(message: e.toString()));
      }
    }
  }

  void _onUpdateUserDetails(UpdateUserDetails event, Emitter<UsersState> emit) {
    if (state is UsersLoaded) {
      final loadedState = state as UsersLoaded;
      final updatedUsers = loadedState.users.map((user) {
        return user.login == event.user.login ? event.user : user;
      }).toList();
      emit(UsersLoaded(users: updatedUsers));
    }
  }
}
