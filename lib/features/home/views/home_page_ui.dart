import 'package:e_commers_app/core/constants/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../favorites/cubit/favorites_cubit.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import 'categories_top_row.dart';
import 'product_detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchCategories();
    fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts = products.where((product) {
          final titleMatch = product['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
          final categoryMatch = product['category']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
          return titleMatch || categoryMatch;
        }).toList();
      }
    });
  }

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
          filteredProducts = products;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Error fetching products: $e'",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.background),
      bottomNavigationBar: const BottomNavBar(),
      appBar: CustomAppBar(
        title: 'Discover',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern search bar with enhanced styling
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: filterProducts,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(MyColors.textfieldBakground),
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                    color: const Color(MyColors.secondaryGrey),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.search_rounded,
                      color: const Color(MyColors.secondaryGrey),
                      size: 24,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: const Color(MyColors.secondaryGrey),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            filterProducts('');
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
                if (state is CategoryLoaded) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.categories.map((category) {
                        final isSelected = state.selectedCategory == category;
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
                } else if (state is ProductLoading && state.categories != null) {
                  // Show categories during loading to maintain visibility
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.categories!.map((category) {
                        final isSelected = state.selectedCategory == category;
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
                } else if (state is ProductsLoaded && state.categories != null) {
                  // Show categories when products are loaded
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.categories!.map((category) {
                        final isSelected = state.selectedCategory == category;
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
                }
                // Show loading placeholder for categories to maintain row visibility
                return Container(
                  height: 50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(5, (index) => 
                        Padding(
                          padding: EdgeInsets.only(right: 3.w),
                          child: Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: const Color(MyColors.textfieldBakground),
                            ),
                            child: Center(
                              child: Container(
                                width: 40,
                                height: 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(MyColors.secondaryGrey).withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductsLoaded) {
                    return buildProductGrid(state.products);
                  } else if (state is ProductError) {
                    Fluttertoast.showToast(
                        msg: "Failed to load products",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return const Center(child: CircularProgressIndicator());
                  }
                  return buildProductGrid(
                      filteredProducts); // Use filteredProducts instead of products
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductGrid(List<dynamic> products) {
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
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
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
                            tag: 'product_${product['id']}',
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
                                        color: const Color(MyColors.primaryRed),
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
                        // Favorite button overlay
                        Positioned(
                          top: 2.w,
                          right: 2.w,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context
                                      .watch<FavoritesCubit>()
                                      .isFavorite(product)
                                  ? const Color(MyColors.primaryRed)
                                  : Colors.white.withOpacity(0.9),
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
                              icon: Icon(
                                context
                                        .watch<FavoritesCubit>()
                                        .isFavorite(product)
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: context
                                        .watch<FavoritesCubit>()
                                        .isFavorite(product)
                                    ? Colors.white
                                    : const Color(MyColors.primaryRed),
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
                                          const Color(MyColors.primaryRedLight),
                                        ],
                                      ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (context
                                                .watch<CartCubit>()
                                                .isInCart(product)
                                            ? const Color(MyColors.success)
                                            : const Color(MyColors.primaryRed))
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
          ),
        );
      },
    );
  }
}
