import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../cubit/favorites_cubit.dart';
import 'empty_favorites.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.background),
      bottomNavigationBar: const BottomNavBar(),
      appBar: CustomAppBar(
        title: 'My Favorites',
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
                  return _buildFavoritesGrid(state.favorites);
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(MyColors.primaryRed),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesGrid(List<dynamic> favorites) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(2.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.w,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final product = favorites[index];
        return _buildFavoriteCard(product, index);
      },
    );
  }

  Widget _buildFavoriteCard(dynamic product, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            (index * 0.1).clamp(0.0, 1.0),
            ((index * 0.1) + 0.3).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ));

        return SlideTransition(
          position: slideAnimation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(MyColors.textfieldBakground),
                  const Color(MyColors.textfieldBakground).withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: const Color(MyColors.primaryRed).withOpacity(0.05),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image with hero animation
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.95),
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Hero(
                              tag: 'favorite_${product['id']}',
                              child: Padding(
                                padding: EdgeInsets.all(3.w),
                                child: Image.network(
                                  product['image'],
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: const Color(MyColors.background),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                          color:
                                              const Color(MyColors.primaryRed),
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: const Color(MyColors.background),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.image_not_supported_rounded,
                                        color: Color(MyColors.secondaryGrey),
                                        size: 48,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Remove from favorites button overlay
                          Positioned(
                            top: 2.w,
                            right: 2.w,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(MyColors.primaryRed),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.all(2.w),
                                icon: const Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  context
                                      .read<FavoritesCubit>()
                                      .toggleFavorite(product);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Product details
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Product title
                          Flexible(
                            child: Text(
                              product['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(MyColors.textColor),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          // Price and cart button row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Price
                              Expanded(
                                child: Text(
                                  '\$${product['price'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: const Color(MyColors.primaryRed),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Enhanced cart button
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: context
                                          .watch<CartCubit>()
                                          .isInCart(product)
                                      ? LinearGradient(
                                          colors: [
                                            const Color(MyColors.success),
                                            const Color(MyColors.success)
                                                .withOpacity(0.8),
                                          ],
                                        )
                                      : LinearGradient(
                                          colors: [
                                            const Color(MyColors.primaryRed),
                                            const Color(
                                                MyColors.primaryRedLight),
                                          ],
                                        ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (context
                                                  .watch<CartCubit>()
                                                  .isInCart(product)
                                              ? const Color(MyColors.success)
                                              : const Color(
                                                  MyColors.primaryRed))
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                      context.read<CartCubit>().addToCart(
                                            id: product['id'],
                                            title: product['title'],
                                            price: product['price'].toDouble(),
                                            image: product['image'],
                                          );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                        vertical: 1.5.h,
                                      ),
                                      child: Icon(
                                        context
                                                .watch<CartCubit>()
                                                .isInCart(product)
                                            ? Icons.check_rounded
                                            : Icons.add_shopping_cart_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
