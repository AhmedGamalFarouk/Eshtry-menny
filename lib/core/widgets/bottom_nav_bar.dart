import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/mycolors.dart';
import '../../core/navigation_cubit.dart';
import '../../features/favorites/views/favorites_screen.dart';
import '../../features/cart/views/cart_screen.dart';
import '../../features/home/views/home_page_ui.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
          backgroundColor: Color(MyColors.background),
          currentIndex: state is HomeState
              ? 0
              : state is FavoritesState
                  ? 1
                  : state is CartState
                      ? 2
                      : 0,
          selectedItemColor: Color(MyColors.primaryRed),
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == 0) {
              context.read<NavigationCubit>().showHome();
              if (state is! HomeState) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
            } else if (index == 1) {
              context.read<NavigationCubit>().showFavorites();
              if (state is! FavoritesState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoritesScreen()),
                );
              }
            } else if (index == 2) {
              context.read<NavigationCubit>().showCart();
              if (state is! CartState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              }
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
          ],
        );
      },
    );
  }
}
