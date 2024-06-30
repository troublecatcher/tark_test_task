import 'package:bloc/bloc.dart';
import 'package:tark_test_task/src/data/remote_repository.dart';
import 'package:tark_test_task/src/domain/state_management/user_details/user_details_state.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_bloc.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_event.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final RemoteRepository _repository;
  final UsersBloc _usersBloc;

  UserDetailsCubit(
      {required RemoteRepository remoteRepository,
      required UsersBloc usersBloc})
      : _repository = remoteRepository,
        _usersBloc = usersBloc,
        super(UserDetailsInitial());
  Future<void> fetchUserDetails(String username) async {
    emit(UserDetailsLoading(username: username));
    try {
      final detailedUser = await _repository.getUserDetails(username);
      _usersBloc.add(UpdateUserDetails(user: detailedUser));
      emit(UserDetailsLoaded(user: detailedUser));
    } catch (e) {
      emit(UserDetailsError(message: e.toString()));
    }
  }
}
