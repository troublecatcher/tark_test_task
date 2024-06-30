import 'package:tark_test_task/src/domain/model/profile.dart';

sealed class UsersEvent {}

class FetchUsers extends UsersEvent {
  final int since;
  final int perPage;

  FetchUsers({
    required this.since,
    required this.perPage,
  });
}

class LoadMoreUsers extends UsersEvent {
  final int perPage;

  LoadMoreUsers({required this.perPage});
}

class UpdateUserDetails extends UsersEvent {
  final Profile user;

  UpdateUserDetails({required this.user});
}
