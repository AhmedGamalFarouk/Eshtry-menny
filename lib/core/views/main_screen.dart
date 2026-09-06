import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../navigation_cubit.dart';
import '../widgets/bottom_nav_bar.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/home/views/home_page_ui.dart';
import '../../features/favorites/views/favorites_screen.dart';
import '../../features/cart/views/cart_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.read<NavigationCubit>().showSignIn();
        }
      },
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          final int currentIndex = (state is HomeState ||
                  state is FavoritesState ||
                  state is CartState)
              ? state.tabIndex
              : 0;

          return Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: const [
                HomePage(),
                FavoritesScreen(),
                CartScreen(),
              ],
            ),
            bottomNavigationBar: const BottomNavBar(),
          );
        },
      ),
    );
  }
}
