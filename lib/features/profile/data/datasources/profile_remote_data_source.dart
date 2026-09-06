import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_order_model.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile(int userId);
  Future<List<UserProfileModel>> getAllUsers();
  Future<List<UserOrderModel>> getUserOrders(int userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({ApiClient? client})
      : apiClient = client ?? ApiClient();

  @override
  Future<UserProfileModel> getUserProfile(int userId) async {
    final response = await apiClient.get(ApiEndpoints.user(userId));
    return UserProfileModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<List<UserProfileModel>> getAllUsers() async {
    final response = await apiClient.get(ApiEndpoints.users);
    if (response is List) {
      return response
          .map((u) => UserProfileModel.fromJson(u as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<UserOrderModel>> getUserOrders(int userId) async {
    final response = await apiClient.get(ApiEndpoints.userCarts(userId));
    if (response is List) {
      return response
          .map((c) => UserOrderModel.fromJson(c as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
