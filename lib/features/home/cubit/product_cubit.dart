import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());
  List<dynamic> _allProducts = [];
  List<dynamic> _filteredProducts = [];
  String? _selectedCategory;
  List<String> _categories = [];

  Future<void> fetchCategories() async {
    try {
      emit(ProductLoading());
      final response = await http
          .get(Uri.parse('https://fakestoreapi.com/products/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> rawCategories = json.decode(response.body);
        _categories = rawCategories.map((category) => category.toString()).toList();
        // Add "All" category at the beginning
        _categories.insert(0, 'All');
        // Set "All" as default selected category if none is selected
        if (_selectedCategory == null) {
          _selectedCategory = 'All';
        }
        emit(CategoryLoaded(_categories, selectedCategory: _selectedCategory));
      } else {
        emit(ProductError('Failed to load categories: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      emit(ProductLoading(categories: _categories, selectedCategory: _selectedCategory));
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        _allProducts = json.decode(response.body);
        _filteredProducts = _allProducts;
        emit(ProductsLoaded(_filteredProducts, categories: _categories, selectedCategory: _selectedCategory));
      } else {
        emit(ProductError('Failed to load products: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    emit(CategoryLoaded(_categories, selectedCategory: _selectedCategory));
    
    if (category == 'All') {
      fetchAllProducts();
    } else {
      fetchProductsByCategory(category);
    }
  }

  Future<void> fetchProductsByCategory(String category) async {
    try {
      emit(ProductLoading(categories: _categories, selectedCategory: _selectedCategory));
      final response = await http.get(
          Uri.parse('https://fakestoreapi.com/products/category/$category'));
      if (response.statusCode == 200) {
        final products = json.decode(response.body);
        emit(ProductsLoaded(products, categories: _categories, selectedCategory: _selectedCategory));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _allProducts;
    } else {
      _filteredProducts = _allProducts.where((product) {
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
    emit(ProductsLoaded(_filteredProducts, categories: _categories, selectedCategory: _selectedCategory));
  }
}
