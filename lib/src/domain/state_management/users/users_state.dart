import 'package:tark_test_task/src/domain/model/profile.dart';

sealed class UsersState {
  const UsersState();
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<Profile> users;

  const UsersLoaded({
    required this.users,
  });

  UsersLoaded copyWith({
    List<Profile>? users,
    List<Profile>? filteredUsers,
  }) {
    return UsersLoaded(
      users: users ?? this.users,
    );
  }
}

class UsersError extends UsersState {
  final String message;

  const UsersError({required this.message});
}
