import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String username, String password);
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({ApiClient? client})
      : apiClient = client ?? ApiClient();

  @override
  Future<String> login(String username, String password) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response is Map && response['token'] != null) {
      return response['token'] as String;
    }
    throw const AuthException('Invalid response: token missing.');
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await apiClient.post(
      ApiEndpoints.users,
      body: {
        'id': 0,
        'username': email,
        'email': '$email@example.com',
        'password': password,
      },
    );
  }
}
