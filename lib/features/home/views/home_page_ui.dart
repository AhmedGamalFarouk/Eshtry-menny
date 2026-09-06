import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../favorites/cubit/favorites_cubit.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import '../data/models/product_model.dart';
import 'categories_top_row.dart';
import 'product_detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.background),
      bottomNavigationBar: const BottomNavBar(),
      appBar: const CustomAppBar(
        title: 'Discover',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern search bar with enhanced styling
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  context.read<ProductCubit>().searchProducts(query);
                  setState(() {});
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(MyColors.textfieldBakground),
                  hintText: 'Search products...',
                  hintStyle: const TextStyle(
                    color: Color(MyColors.secondaryGrey),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.search_rounded,
                      color: Color(MyColors.secondaryGrey),
                      size: 24,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Color(MyColors.secondaryGrey),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            context.read<ProductCubit>().searchProducts('');
                            setState(() {});
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(MyColors.primaryRed),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(
                  color: Color(MyColors.textColor),
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                List<String> categories = ['All'];
                String selectedCategory = 'All';
                if (state is ProductsLoaded) {
                  categories = state.categories;
                  selectedCategory = state.selectedCategory;
                } else if (state is ProductLoading && state.categories != null) {
                  categories = state.categories!;
                  selectedCategory = state.selectedCategory ?? 'All';
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      final isSelected = selectedCategory == category;
                      return Padding(
                        padding: EdgeInsets.only(right: 3.w),
                        child: CategoriesTopRow(
                          text: category,
                          isSelected: isSelected,
                          onTap: () {
                            context
                                .read<ProductCubit>()
                                .selectCategory(category);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(MyColors.primaryRed),
                      ),
                    );
                  } else if (state is ProductError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_off_rounded,
                            size: 64,
                            color: Color(MyColors.secondaryGrey),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(MyColors.textSecondary),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProductCubit>().loadInitialData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(MyColors.primaryRed),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Try Again',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ProductsLoaded) {
                    if (state.products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: Color(MyColors.secondaryGrey),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              state.searchQuery.isNotEmpty
                                  ? 'No products found matching "${state.searchQuery}"'
                                  : 'No products in category "${state.selectedCategory}"',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(MyColors.textSecondary),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return buildProductGrid(state.products);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductGrid(List<ProductModel> products) {
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.w,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final productMap = product.toMap();
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: productMap),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(MyColors.textfieldBakground),
                    const Color(MyColors.textfieldBakground)
                        .withValues(alpha: 0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color:
                        const Color(MyColors.primaryRed).withValues(alpha: 0.05),
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
                              Colors.white.withValues(alpha: 0.95),
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
                                tag: 'product_${product.id}',
                                child: Padding(
                                  padding: EdgeInsets.all(3.w),
                                  child: CachedNetworkImage(
                                    imageUrl: product.image,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        color: const Color(MyColors.background),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(MyColors.primaryRed),
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        color: const Color(MyColors.background),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.image_not_supported_rounded,
                                        color: Color(MyColors.secondaryGrey),
                                        size: 48,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Favorite button overlay
                            Positioned(
                              top: 2.w,
                              right: 2.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context
                                          .watch<FavoritesCubit>()
                                          .isFavorite(productMap)
                                      ? const Color(MyColors.primaryRed)
                                      : Colors.white.withValues(alpha: 0.9),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.all(2.w),
                                  icon: Icon(
                                    context
                                            .watch<FavoritesCubit>()
                                            .isFavorite(productMap)
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: context
                                            .watch<FavoritesCubit>()
                                            .isFavorite(productMap)
                                        ? Colors.white
                                        : const Color(MyColors.primaryRed),
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    context
                                        .read<FavoritesCubit>()
                                        .toggleFavorite(productMap);
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
                                product.title,
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
                                    '\$${product.price.toStringAsFixed(2)}',
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
                                            .isInCart(productMap)
                                        ? LinearGradient(
                                            colors: [
                                              const Color(MyColors.success),
                                              const Color(MyColors.success)
                                                  .withValues(alpha: 0.8),
                                            ],
                                          )
                                        : const LinearGradient(
                                            colors: [
                                              Color(MyColors.primaryRed),
                                              Color(MyColors.primaryRedLight),
                                            ],
                                          ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (context
                                                    .watch<CartCubit>()
                                                    .isInCart(productMap)
                                                ? const Color(MyColors.success)
                                                : const Color(
                                                    MyColors.primaryRed))
                                            .withValues(alpha: 0.3),
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
                                              id: product.id,
                                              title: product.title,
                                              price: product.price,
                                              image: product.image,
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
                                                  .isInCart(productMap)
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
          ),
        );
      },
    );
  }
}
