import 'package:tark_test_task/src/domain/model/github_profile.dart';

sealed class GithubUserState {}

class GithubUserInitial extends GithubUserState {}

class GithubUserLoading extends GithubUserState {}

class GithubUserLoaded extends GithubUserState {
  final Map<String, GithubProfile> users;
  final Map<String, GithubProfile> filteredUsers;
  final bool isLoadingMore;

  GithubUserLoaded({
    required this.users,
    required this.filteredUsers,
    this.isLoadingMore = false,
  });

  GithubUserLoaded copyWith({
    Map<String, GithubProfile>? users,
    Map<String, GithubProfile>? filteredUsers,
    bool? isLoadingMore,
  }) {
    return GithubUserLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class GithubUserError extends GithubUserState {
  final String message;

  GithubUserError({required this.message});
}
