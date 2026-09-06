import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/navigation_cubit.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../auth/cubit/auth_cubit.dart';
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(MyColors.textfieldBakground),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Sign Out',
          style: TextStyle(color: Color(MyColors.textColor)),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Color(MyColors.textSecondary)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(MyColors.textSecondary)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(MyColors.primaryRed),
              minimumSize: const Size(80, 36),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<AuthCubit>().signOut();
              if (context.mounted) {
                context.read<NavigationCubit>().showSignIn();
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.background),
      appBar: CustomAppBar(
        title: 'Discover',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(MyColors.textColor)),
            tooltip: 'Sign Out',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern search bar with subtle borders and clear action
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(MyColors.textfieldBakground),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(MyColors.borderSubtle)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  context.read<ProductCubit>().searchProducts(query);
                  setState(() {});
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  isDense: true,
                  filled: false,
                  hintText: 'Search products, brands...',
                  hintStyle: const TextStyle(
                    color: Color(MyColors.secondaryGrey),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(MyColors.secondaryGrey),
                    size: 20,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Color(MyColors.secondaryGrey),
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            context.read<ProductCubit>().searchProducts('');
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(
                  color: Color(MyColors.textColor),
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 1.5.h),
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

                return SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = selectedCategory == category;
                      return CategoriesTopRow(
                        text: category,
                        isSelected: isSelected,
                        onTap: () {
                          context
                              .read<ProductCubit>()
                              .selectCategory(category);
                        },
                      );
                    },
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color(MyColors.primaryRed),
                            strokeWidth: 2.5,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Curating products...',
                            style: TextStyle(
                              color: Color(MyColors.textSecondary),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ProductError) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(MyColors.cardBackground),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(MyColors.borderSubtle),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              size: 48,
                              color: Color(MyColors.primaryRed),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Failed to load products',
                              style: TextStyle(
                                color: Color(MyColors.textColor),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(MyColors.textSecondary),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<ProductCubit>().loadInitialData();
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(140, 42),
                              ),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is ProductsLoaded) {
                    if (state.products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: const Color(MyColors.textfieldBakground),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(MyColors.borderSubtle),
                                ),
                              ),
                              child: const Icon(
                                Icons.search_off_rounded,
                                size: 36,
                                color: Color(MyColors.secondaryGrey),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No products found',
                              style: TextStyle(
                                color: Color(MyColors.textColor),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              state.searchQuery.isNotEmpty
                                  ? 'No matches for "${state.searchQuery}"'
                                  : 'No items found in "${state.selectedCategory}"',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(MyColors.textSecondary),
                                fontSize: 13,
                              ),
                            ),
                            if (state.searchQuery.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(120, 38),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  context
                                      .read<ProductCubit>()
                                      .searchProducts('');
                                  setState(() {});
                                },
                                child: const Text('Clear Search'),
                              ),
                            ],
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
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 24, left: 2, right: 2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.64,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final productMap = product.toMap();
        final isFav = context.watch<FavoritesCubit>().isFavorite(productMap);
        final inCart = context.watch<CartCubit>().isInCart(productMap);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
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
                color: const Color(MyColors.cardBackground),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image container with rating and favorite overlay
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Hero(
                                tag: 'product_${product.id}',
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: CachedNetworkImage(
                                    imageUrl: product.image,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(MyColors.primaryRed),
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        color: Colors.grey,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Rating chip overlay
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.72),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Color(MyColors.warning),
                                      size: 13,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      product.rating.rate.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Favorite button overlay
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    context
                                        .read<FavoritesCubit>()
                                        .toggleFavorite(productMap);
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withValues(alpha: 0.5),
                                    ),
                                    child: Icon(
                                      isFav
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      color: isFav
                                          ? const Color(MyColors.primaryRed)
                                          : Colors.white,
                                      size: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Product info section
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.category.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(MyColors.secondaryGrey),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(MyColors.textColor),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    height: 1.25,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Color(MyColors.primaryRed),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                Material(
                                  color: inCart
                                      ? const Color(MyColors.success)
                                      : const Color(MyColors.primaryRed),
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                      context.read<CartCubit>().addToCart(
                                            id: product.id,
                                            title: product.title,
                                            price: product.price,
                                            image: product.image,
                                          );
                                    },
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      alignment: Alignment.center,
                                      child: Icon(
                                        inCart
                                            ? Icons.check_rounded
                                            : Icons.add_shopping_cart_rounded,
                                        color: Colors.white,
                                        size: 16,
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
