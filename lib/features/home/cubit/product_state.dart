import 'package:equatable/equatable.dart';
import '../data/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {
  final List<String>? categories;
  final String? selectedCategory;

  const ProductLoading({this.categories, this.selectedCategory});

  @override
  List<Object?> get props => [categories, selectedCategory];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoryLoaded extends ProductState {
  final List<String> categories;
  final String? selectedCategory;

  const CategoryLoaded(this.categories, {this.selectedCategory});

  @override
  List<Object?> get props => [categories, selectedCategory];
}

class ProductsLoaded extends ProductState {
  final List<ProductModel> products;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;

  const ProductsLoaded({
    required this.products,
    required this.categories,
    this.selectedCategory = 'All',
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [products, categories, selectedCategory, searchQuery];
}
