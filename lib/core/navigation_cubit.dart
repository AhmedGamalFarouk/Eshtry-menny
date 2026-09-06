import 'package:flutter_bloc/flutter_bloc.dart';

// Navigation States
abstract class NavigationState {
  final int tabIndex;
  const NavigationState({this.tabIndex = 0});
}

class SignInState extends NavigationState {
  const SignInState() : super(tabIndex: 0);
}

class SignUpState extends NavigationState {
  const SignUpState() : super(tabIndex: 0);
}

class HomeState extends NavigationState {
  const HomeState() : super(tabIndex: 0);
}

class FavoritesState extends NavigationState {
  const FavoritesState() : super(tabIndex: 1);
}

class CartState extends NavigationState {
  const CartState() : super(tabIndex: 2);
}

// Navigation Cubit
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit({NavigationState? initialState})
      : super(initialState ?? const SignInState());

  void showSignIn() => emit(const SignInState());
  void showSignUp() => emit(const SignUpState());
  void showHome() => emit(const HomeState());
  void showFavorites() => emit(const FavoritesState());
  void showCart() => emit(const CartState());

  void changeTab(int index) {
    switch (index) {
      case 0:
        emit(const HomeState());
        break;
      case 1:
        emit(const FavoritesState());
        break;
      case 2:
        emit(const CartState());
        break;
      default:
        emit(const HomeState());
    }
  }
}