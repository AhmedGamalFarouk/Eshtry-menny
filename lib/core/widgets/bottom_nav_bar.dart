import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/mycolors.dart';
import '../../core/navigation_cubit.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        final currentIndex = (state is HomeState ||
                state is FavoritesState ||
                state is CartState)
            ? state.tabIndex
            : 0;

        return BottomNavigationBar(
          backgroundColor: const Color(MyColors.background),
          currentIndex: currentIndex,
          selectedItemColor: const Color(MyColors.primaryRed),
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            context.read<NavigationCubit>().changeTab(index);
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
