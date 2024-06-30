import 'package:tark_test_task/src/domain/bloc/github_bloc.dart';
import 'package:tark_test_task/src/domain/model/github_profile.dart';

abstract class GithubRepository {
  Future<List<GithubProfile>> getUsersInRange(
      {int since, int perPage, required ListPattern pattern});

  Future<GithubProfile> getUserDetails(String username);
}
