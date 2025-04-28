import 'package:equatable/equatable.dart';
import '../data/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;

  const ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}

class CategoryLoaded extends ProductState {
  final List<String> categories;
  CategoryLoaded(this.categories);
}

class ProductsLoaded extends ProductState {
  final List<dynamic> products;
  ProductsLoaded(this.products);
}
