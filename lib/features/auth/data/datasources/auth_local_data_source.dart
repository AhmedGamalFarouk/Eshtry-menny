import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthSession({
    required String token,
    required String username,
  });
  Future<String?> getToken();
  Future<String?> getUsername();
  Future<void> clearAuthSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String tokenKey = 'auth_token';
  static const String usernameKey = 'auth_username';

  @override
  Future<void> saveAuthSession({
    required String token,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    await prefs.setString(usernameKey, username);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  @override
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

  @override
  Future<void> clearAuthSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(usernameKey);
  }
}
