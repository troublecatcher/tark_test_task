import 'package:equatable/equatable.dart';
import 'package:tark_test_task/src/domain/model/github_profile.dart';

abstract class GithubUserState extends Equatable {
  const GithubUserState();

  @override
  List<Object> get props => [];
}

class GithubUserInitial extends GithubUserState {}

class GithubUserLoading extends GithubUserState {}

class GithubUserLoaded extends GithubUserState {
  final List<GithubProfile> users;

  const GithubUserLoaded({
    required this.users,
  });

  GithubUserLoaded copyWith({
    List<GithubProfile>? users,
    List<GithubProfile>? filteredUsers,
  }) {
    return GithubUserLoaded(
      users: users ?? this.users,
    );
  }

  @override
  List<Object> get props => [users];
}

class GithubUserError extends GithubUserState {
  final String message;

  const GithubUserError({required this.message});

  @override
  List<Object> get props => [message];
}
