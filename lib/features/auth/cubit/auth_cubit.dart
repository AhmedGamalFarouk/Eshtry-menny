import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/datasources/auth_local_data_source.dart';
import '../data/repositories/auth_repository.dart';

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
  static const String tokenKey = AuthLocalDataSourceImpl.tokenKey;
  static const String usernameKey = AuthLocalDataSourceImpl.usernameKey;

  final AuthRepository _authRepository;

  AuthCubit({
    AuthRepository? repository,
    bool isLoggedIn = false,
  })  : _authRepository = repository ?? AuthRepositoryImpl(),
        super(isLoggedIn ? AuthSuccess() : AuthInitial());

  Future<void> checkAuthStatus() async {
    try {
      final authenticated = await _authRepository.isAuthenticated();
      if (authenticated) {
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
      await _authRepository.signIn(email, password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
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
      await _authRepository.signUp(
        name: name,
        email: email,
        password: password,
      );
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
