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
      print('Attempting sign-in with username: $email and password: $password');
      final response = await http.post(
        Uri.parse('https://fakestoreapi.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': email, // API expects username instead of email
          'password': password,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = json.decode(response.body)['token'];
        print('Sign-in successful. Token: $token');
        emit(AuthSuccess());
      } else {
        emit(AuthError('Invalid credentials'));
      }
    } catch (e) {
      print('Sign-in connection error: $e');
      emit(AuthError('Connection error: $e'));
    }
  }

  Future<void> signUp(
      {required String name,
      required String email,
      required String password}) async {
    emit(AuthLoading());
    try {
      final response =
          await http.post(Uri.parse('https://fakestoreapi.com/users'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'id': 0,
                'username': email, // email field now contains username
                'email': '$email@example.com', // generate a dummy email
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
