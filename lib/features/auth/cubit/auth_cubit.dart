import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Auth States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('https://fakestoreapi.com/auth/login'),
        body: {
          'username': email, // API expects username instead of email
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = json.decode(response.body)['token'];
        emit(AuthSuccess());
      } else {
        emit(AuthError('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthError('Connection error: $e'));
    }
  }

  Future<void> signUp(
      {required String name,
      required String email,
      required String password}) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
          Uri.parse('https://fakestoreapi.com/users'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'id': 0,
            'username': name,
            'email': email,
            'password': password
          }));

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
