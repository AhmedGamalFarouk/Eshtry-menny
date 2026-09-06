import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();
  Future<List<String>> getCategories();
  Future<ProductModel> getProductDetails(int id);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({ProductRemoteDataSource? dataSource})
      : remoteDataSource = dataSource ?? ProductRemoteDataSourceImpl();

  @override
  Future<List<ProductModel>> getProducts() async {
    return await remoteDataSource.getProducts();
  }

  @override
  Future<List<String>> getCategories() async {
    return await remoteDataSource.getCategories();
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    return await remoteDataSource.getProductDetails(id);
  }
}
