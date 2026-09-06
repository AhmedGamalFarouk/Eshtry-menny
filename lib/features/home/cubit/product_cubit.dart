import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit({ProductRepository? repository})
      : _repository = repository ?? ProductRepositoryImpl(),
        super(ProductInitial());

  List<ProductModel> _allProducts = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  /// Loads both categories and all products concurrently with clean error handling.
  Future<void> loadInitialData() async {
    try {
      emit(ProductLoading(
        categories: _categories,
        selectedCategory: _selectedCategory,
      ));

      final results = await Future.wait([
        _repository.getCategories(),
        _repository.getProducts(),
      ]);

      final rawCategories = results[0] as List<String>;
      final rawProducts = results[1] as List<ProductModel>;

      _categories = ['All', ...rawCategories];
      _allProducts = rawProducts;

      _emitFilteredProducts();
    } catch (e) {
      emit(ProductError(e.toString()));
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
