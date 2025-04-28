import 'package:flutter_bloc/flutter_bloc.dart';

// Navigation States
abstract class NavigationState {}

class SignInState extends NavigationState {}

class SignUpState extends NavigationState {}

class HomeState extends NavigationState {}

class FavoritesState extends NavigationState {}

class CartState extends NavigationState {}

// Navigation Cubit
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(SignInState()); // Default state is SignIn

  void showSignIn() => emit(SignInState());
  void showSignUp() => emit(SignUpState());
  void showHome() => emit(HomeState());
  void showFavorites() => emit(FavoritesState());
  void showCart() => emit(CartState());
}