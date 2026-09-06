import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../home/views/product_detail_screen.dart';
import '../cubit/favorites_cubit.dart';
import 'empty_favorites.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.background),
      appBar: const CustomAppBar(
        title: 'My Favorites',
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesInitial) {
            context.read<FavoritesCubit>().getFavorites();
            return const EmptyFavorites();
          }
          if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return const EmptyFavorites();
            }
            return _buildFavoritesGrid(state.favorites);
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Color(MyColors.primaryRed),
              strokeWidth: 2.5,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesGrid(List<dynamic> favorites) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.64,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final product = favorites[index];
        final productMap = product is Map<String, dynamic>
            ? product
            : Map<String, dynamic>.from(product as Map);
        return _buildFavoriteCard(productMap);
      },
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> product) {
    final inCart = context.watch<CartCubit>().isInCart(product);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(MyColors.cardSurface),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(MyColors.borderSubtle),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container with heart overlay
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(17),
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Hero(
                        tag: 'fav_img_${product['id']}',
                        child: CachedNetworkImage(
                          imageUrl: product['image']?.toString() ?? '',
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(MyColors.primaryRed),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.read<FavoritesCubit>().toggleFavorite(product);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            size: 16,
                            color: Color(MyColors.primaryRed),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Title and price details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['title']?.toString() ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(MyColors.textColor),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${(product['price'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                            color: Color(MyColors.primaryRed),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        // Compact Cart Button
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            context.read<CartCubit>().addToCart(
                                  id: product['id'],
                                  title: product['title'],
                                  price: (product['price'] as num).toDouble(),
                                  image: product['image'],
                                );
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: inCart
                                  ? const Color(0xFF10B981)
                                  : const Color(MyColors.primaryRed),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              inCart ? Icons.check : Icons.add_shopping_cart_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

