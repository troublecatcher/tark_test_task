import 'package:tark_test_task/src/domain/bloc/github_bloc.dart';

sealed class GithubUserEvent {}

class FetchGithubUsers extends GithubUserEvent {
  final ListPattern pattern;
  final int since;
  final int perPage;

  FetchGithubUsers({
    required this.pattern,
    this.since = 0,
    this.perPage = 100,
  });
}

class SortGithubUsers extends GithubUserEvent {
  final ListPattern pattern;

  SortGithubUsers({required this.pattern});
}

class LoadMoreGithubUsers extends GithubUserEvent {
  final ListPattern pattern;

  LoadMoreGithubUsers({required this.pattern});
}
