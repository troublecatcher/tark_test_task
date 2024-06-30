import 'package:tark_test_task/src/domain/model/profile.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_bloc.dart';
import 'package:tark_test_task/src/presentation/list_pattern.dart';

sealed class UsersEvent {}

class FetchUsers extends UsersEvent {
  final ListPattern pattern;
  final int since;
  final int perPage;

  FetchUsers({
    required this.pattern,
    this.since = 0,
    this.perPage = 100,
  });
}

class LoadMoreUsers extends UsersEvent {
  final ListPattern pattern;

  LoadMoreUsers({required this.pattern});
}

class UpdateUserDetails extends UsersEvent {
  final Profile user;

  UpdateUserDetails({required this.user});
}
