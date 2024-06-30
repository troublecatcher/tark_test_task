import 'package:dio/dio.dart';
import 'package:tark_test_task/src/data/github_repository.dart';
import 'package:tark_test_task/src/domain/bloc/github_bloc.dart';
import 'package:tark_test_task/src/domain/model/github_profile.dart';

class GithubRepositoryImpl implements GithubRepository {
  final Dio _dio;
  final String _authToken;
  final String _baseUrl = 'https://api.github.com/users';

  GithubRepositoryImpl({Dio? dio, required String authToken})
      : _dio = dio ?? Dio(),
        _authToken = authToken;

  Future<List<GithubProfile>> _getUsers(
      {int since = 0, int perPage = 100}) async {
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
        return data.map((user) => GithubProfile.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  @override
  Future<List<GithubProfile>> getUsersInRange(
      {int since = 0, int perPage = 100, required ListPattern pattern}) async {
    final List<GithubProfile> users =
        await _getUsers(since: since, perPage: perPage);
    return users;
  }

  @override
  Future<GithubProfile> getUserDetails(String username) async {
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
        return GithubProfile.fromJson(data);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }
}
