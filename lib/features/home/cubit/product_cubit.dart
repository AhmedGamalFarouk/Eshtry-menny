import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../data/models/product_model.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  List<ProductModel> _allProducts = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  /// Loads both categories and all products concurrently with error handling.
  Future<void> loadInitialData() async {
    try {
      emit(ProductLoading(
        categories: _categories,
        selectedCategory: _selectedCategory,
      ));

      final results = await Future.wait([
        http
            .get(Uri.parse('https://fakestoreapi.com/products/categories'))
            .timeout(const Duration(seconds: 15)),
        http
            .get(Uri.parse('https://fakestoreapi.com/products'))
            .timeout(const Duration(seconds: 15)),
      ]);

      final categoriesResponse = results[0];
      final productsResponse = results[1];

      if (categoriesResponse.statusCode == 200 &&
          productsResponse.statusCode == 200) {
        final List<dynamic> rawCategories =
            json.decode(categoriesResponse.body);
        _categories = ['All', ...rawCategories.map((c) => c.toString())];

        final List<dynamic> rawProducts = json.decode(productsResponse.body);
        _allProducts = rawProducts
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();

        _emitFilteredProducts();
      } else {
        emit(ProductError(
            'Failed to load products: status ${productsResponse.statusCode}'));
      }
    } catch (e) {
      emit(ProductError('Connection error: $e'));
    }
  }

  /// Selects a category and instantly filters products in-memory.
  void selectCategory(String category) {
    _selectedCategory = category;
    _emitFilteredProducts();
  }

  /// Searches products across title, category, and description.
  void searchProducts(String query) {
    _searchQuery = query.trim();
    _emitFilteredProducts();
  }

  /// Refreshes all products from network.
  Future<void> refresh() async {
    await loadInitialData();
  }

  /// Backward-compatible aliases
  Future<void> fetchCategories() => loadInitialData();
  Future<void> fetchAllProducts() => loadInitialData();
  void filterProducts(String query) => searchProducts(query);

  void _emitFilteredProducts() {
    final filtered = _allProducts.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();

      final matchesSearch = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    emit(ProductsLoaded(
      products: filtered,
      categories: _categories,
      selectedCategory: _selectedCategory,
      searchQuery: _searchQuery,
    ));
  }
}
