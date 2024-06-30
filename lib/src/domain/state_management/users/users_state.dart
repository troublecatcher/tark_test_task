import 'package:equatable/equatable.dart';
import 'package:tark_test_task/src/domain/model/profile.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
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

  @override
  List<Object> get props => [users];
}

class UsersError extends UsersState {
  final String message;

  const UsersError({required this.message});

  @override
  List<Object> get props => [message];
}
