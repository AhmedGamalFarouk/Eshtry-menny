import 'package:e_commers_app/core/constants/mycolors.dart';
import 'package:flutter/material.dart';
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
            TextField(
              controller: _searchController,
              onChanged: filterProducts,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(MyColors.textfieldBakground),
                hintText: 'Search',
                hintStyle: TextStyle(color: Color(MyColors.secondaryGrey)),
                prefixIcon:
                    Icon(Icons.search, color: Color(MyColors.secondaryGrey)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              style: TextStyle(color: Color(MyColors.textColor)),
            ),
            SizedBox(height: 2.h),
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is CategoryLoaded) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.categories.map((category) {
                        return Padding(
                          padding: EdgeInsets.only(right: 3.w),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<ProductCubit>()
                                  .fetchProductsByCategory(category);
                            },
                            child: CategoriesTopRow(text: category),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
                return SizedBox(
                  height: 0,
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
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product["price"].toStringAsFixed(2)}',
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
                              icon: Icon(
                                Icons.favorite,
                                color: context
                                        .watch<FavoritesCubit>()
                                        .isFavorite(product)
                                    ? Color(MyColors.primaryRed)
                                    : Color(MyColors.secondaryGrey),
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
                              icon: Icon(
                                Icons.add_shopping_cart,
                                color:
                                    context.watch<CartCubit>().isInCart(product)
                                        ? Color(MyColors.primaryRed)
                                        : Color(MyColors.secondaryGrey),
                                size: 25,
                              ),
                              onPressed: () {
                                context.read<CartCubit>().addToCart(
                                      id: product['id'],
                                      title: product['title'],
                                      price: product['price'].toDouble(),
                                      image: product['image'],
                                    );
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
}
