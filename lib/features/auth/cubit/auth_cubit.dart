import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Auth States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  static const String tokenKey = 'auth_token';
  static const String usernameKey = 'auth_username';

  AuthCubit({bool isLoggedIn = false})
      : super(isLoggedIn ? AuthSuccess() : AuthInitial());

  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);
      if (token != null && token.isNotEmpty) {
        emit(AuthSuccess());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('https://fakestoreapi.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': email, // API expects username instead of email
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final token = data['token'] as String?;
        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(tokenKey, token);
          await prefs.setString(usernameKey, email);
        }
        emit(AuthSuccess());
      } else {
        emit(AuthError('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthError('Connection error: $e'));
    }
  }

  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey);
      await prefs.remove(usernameKey);
    } catch (_) {}
    emit(AuthUnauthenticated());
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('https://fakestoreapi.com/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': 0,
          'username': email,
          'email': '$email@example.com',
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        emit(AuthSuccess());
      } else {
        emit(AuthError('Registration failed'));
      }
    } catch (e) {
      emit(AuthError('Connection error: $e'));
    }
  }
}
