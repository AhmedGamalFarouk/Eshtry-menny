import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<String>> getCategories();
  Future<ProductModel> getProductDetails(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({ApiClient? client})
      : apiClient = client ?? ApiClient();

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await apiClient.get(ApiEndpoints.products);
    if (response is List) {
      return response
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await apiClient.get(ApiEndpoints.categories);
    if (response is List) {
      return response.map((item) => item.toString()).toList();
    }
    return [];
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    final response = await apiClient.get(ApiEndpoints.productDetails(id));
    return ProductModel.fromJson(response as Map<String, dynamic>);
  }
}
