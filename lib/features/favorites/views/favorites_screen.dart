import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../cubit/favorites_cubit.dart';
import 'empty_favorites.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.background),
      bottomNavigationBar: const BottomNavBar(),
      appBar: CustomAppBar(
        title: 'Favorites',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 10.w),
        child: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesInitial) {
              context.read<FavoritesCubit>().getFavorites();
              return const Center(child: EmptyFavorites());
            }
            if (state is FavoritesLoaded) {
              if (state.favorites.isEmpty) {
                return const EmptyFavorites();
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final product = state.favorites[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Color(MyColors.background),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Image.network(
                                product['image'],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['title'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(MyColors.textColor),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${product['price'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Color(MyColors.primaryRed),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        constraints: BoxConstraints(),
                                        icon: const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 25,
                                        ),
                                        onPressed: () {
                                          context
                                              .read<FavoritesCubit>()
                                              .toggleFavorite(product);
                                        },
                                      ),
                                      IconButton(
                                        constraints: BoxConstraints(),
                                        icon: BlocBuilder<CartCubit, CartState>(
                                          builder: (context, cartState) {
                                            final isInCart = cartState
                                                    is CartLoaded &&
                                                cartState.items.any((item) =>
                                                    item.id == product['id']);
                                            return Icon(
                                              Icons.add_shopping_cart,
                                              color: isInCart
                                                  ? Color(MyColors.primaryRed)
                                                  : Color(
                                                      MyColors.secondaryGrey),
                                              size: 25,
                                            );
                                          },
                                        ),
                                        onPressed: () {
                                          final isInCart = context
                                                  .read<CartCubit>()
                                                  .state is CartLoaded &&
                                              (context.read<CartCubit>().state
                                                      as CartLoaded)
                                                  .items
                                                  .any((item) =>
                                                      item.id == product['id']);

                                          if (isInCart) {
                                            context
                                                .read<CartCubit>()
                                                .removeFromCart(product['id']);
                                          } else {
                                            context.read<CartCubit>().addToCart(
                                                  id: product['id'],
                                                  title: product['title'],
                                                  price: product['price']
                                                      .toDouble(),
                                                  image: product['image'],
                                                );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
