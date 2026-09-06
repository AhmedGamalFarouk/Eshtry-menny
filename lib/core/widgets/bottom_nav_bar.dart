import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/mycolors.dart';
import '../../core/navigation_cubit.dart';
import '../../features/cart/cubit/cart_cubit.dart' hide CartState;

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        final currentIndex = (state is HomeState ||
                state is FavoritesState ||
                state is CartState ||
                state is ProfileNavState)
            ? state.tabIndex
            : 0;

        final cartItemsCount = context.select<CartCubit, int>((cubit) {
          final s = cubit.state;
          if (s is CartLoaded) {
            return s.items.fold<int>(0, (sum, i) => sum + i.quantity);
          }
          return 0;
        });

        return Container(
          decoration: const BoxDecoration(
            color: Color(MyColors.background),
            border: Border(
              top: BorderSide(
                color: Color(MyColors.borderSubtle),
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color(MyColors.background),
            currentIndex: currentIndex,
            selectedItemColor: const Color(MyColors.primaryRed),
            unselectedItemColor: const Color(MyColors.secondaryGrey),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            onTap: (index) {
              context.read<NavigationCubit>().changeTab(index);
            },
            items: [
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.storefront_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.storefront_rounded),
                ),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.favorite_outline_rounded),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.favorite_rounded),
                ),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Badge(
                    isLabelVisible: cartItemsCount > 0,
                    label: Text(
                      '$cartItemsCount',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: const Color(MyColors.primaryRed),
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Badge(
                    isLabelVisible: cartItemsCount > 0,
                    label: Text(
                      '$cartItemsCount',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: const Color(MyColors.primaryRed),
                    child: const Icon(Icons.shopping_bag_rounded),
                  ),
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person_outline_rounded),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person_rounded),
                ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
