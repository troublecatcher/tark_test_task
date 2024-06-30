import 'package:tark_test_task/src/domain/model/profile.dart';

abstract class UserDetailsState {
  const UserDetailsState();
}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {
  final String username;

  const UserDetailsLoading({required this.username});
}

class UserDetailsLoaded extends UserDetailsState {
  final Profile user;

  const UserDetailsLoaded({required this.user});
}

class UserDetailsError extends UserDetailsState {
  final String message;

  const UserDetailsError({required this.message});
}
