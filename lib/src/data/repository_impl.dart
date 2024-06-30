import 'package:dio/dio.dart';
import 'package:tark_test_task/src/data/repository.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_bloc.dart';
import 'package:tark_test_task/src/domain/model/profile.dart';
import 'package:tark_test_task/src/presentation/list_pattern.dart';

class RepositoryImpl implements Repository {
  final Dio _dio;
  final String _authToken;
  final String _baseUrl = 'https://api.github.com/users';

  RepositoryImpl({Dio? dio, required String authToken})
      : _dio = dio ?? Dio(),
        _authToken = authToken;

  Future<List<Profile>> _getUsers({int since = 0, int perPage = 100}) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'since': since,
          'per_page': perPage,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((user) => Profile.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  @override
  Future<List<Profile>> getUsersInRange(
      {int since = 0, int perPage = 100, required ListPattern pattern}) async {
    final List<Profile> users = await _getUsers(since: since, perPage: perPage);
    return users;
  }

  @override
  Future<Profile> getUserDetails(String username) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/$username',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Profile.fromJson(data);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }
}
