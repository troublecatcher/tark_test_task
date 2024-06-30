import 'package:dio/dio.dart';
import 'package:tark_test_task/src/data/remote_interceptor.dart';
import 'package:tark_test_task/src/data/repository.dart';
import 'package:tark_test_task/src/domain/model/profile.dart';

class RemoteRepository implements Repository {
  final Dio _dio;
  final String? _authToken;
  final String _baseUrl = 'https://api.github.com/users';

  RemoteRepository({Dio? dio, required String? authToken})
      : _dio = dio ?? Dio(),
        _authToken = authToken {
    _dio.interceptors.add(RemoteInterceptor(authToken: _authToken));
  }

  @override
  Future<List<Profile>> getUsers({
    required int since,
    required int perPage,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'since': since,
          'per_page': perPage,
        },
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

  Future<Profile> getUserDetails(String username) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/$username',
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
