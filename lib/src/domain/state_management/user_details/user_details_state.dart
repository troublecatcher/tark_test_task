import 'package:equatable/equatable.dart';
import 'package:tark_test_task/src/domain/model/profile.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object?> get props => [];
}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsLoaded extends UserDetailsState {
  final Profile user;

  const UserDetailsLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserDetailsError extends UserDetailsState {
  final String message;

  const UserDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
