import 'package:tark_test_task/src/domain/state_management/users/users_bloc.dart';
import 'package:tark_test_task/src/domain/model/profile.dart';
import 'package:tark_test_task/src/presentation/list_pattern.dart';

abstract class Repository {
  Future<List<Profile>> getUsersInRange(
      {int since, int perPage, required ListPattern pattern});

  Future<Profile> getUserDetails(String username);
}
