import 'package:tark_test_task/src/domain/model/profile.dart';

abstract class Repository {
  Future<List<Profile>> getUsers({
    required int since,
    required int perPage,
  });
}
