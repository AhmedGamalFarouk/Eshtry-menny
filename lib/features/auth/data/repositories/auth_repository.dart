import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

abstract class AuthRepository {
  Future<String> signIn(String username, String password);
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<String?> getSavedToken();
  Future<String?> getSavedUsername();
  Future<bool> isAuthenticated();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    AuthRemoteDataSource? remote,
    AuthLocalDataSource? local,
  })  : remoteDataSource = remote ?? AuthRemoteDataSourceImpl(),
        localDataSource = local ?? AuthLocalDataSourceImpl();

  @override
  Future<String> signIn(String username, String password) async {
    final token = await remoteDataSource.login(username, password);
    await localDataSource.saveAuthSession(token: token, username: username);
    return token;
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await localDataSource.clearAuthSession();
  }

  @override
  Future<String?> getSavedToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<String?> getSavedUsername() async {
    return await localDataSource.getUsername();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }
}
