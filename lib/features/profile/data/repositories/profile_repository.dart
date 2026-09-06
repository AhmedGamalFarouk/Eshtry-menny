import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_order_model.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRepository {
  Future<UserProfileModel> getProfile();
  Future<List<UserOrderModel>> getOrders(int userId);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    ProfileRemoteDataSource? remote,
    AuthLocalDataSource? local,
  })  : remoteDataSource = remote ?? ProfileRemoteDataSourceImpl(),
        localDataSource = local ?? AuthLocalDataSourceImpl();

  @override
  Future<UserProfileModel> getProfile() async {
    final savedUsername = await localDataSource.getUsername();

    // If a saved username exists, locate matching user from FakeStore API
    if (savedUsername != null && savedUsername.isNotEmpty) {
      try {
        final users = await remoteDataSource.getAllUsers();
        final match = users.firstWhere(
          (u) => u.username.toLowerCase() == savedUsername.toLowerCase(),
          orElse: () => users.first,
        );
        return match;
      } catch (_) {
        // Fallback to user 2 (mor_2314)
        return await remoteDataSource.getUserProfile(2);
      }
    }

    // Default to user 2 (David Morrison)
    return await remoteDataSource.getUserProfile(2);
  }

  @override
  Future<List<UserOrderModel>> getOrders(int userId) async {
    return await remoteDataSource.getUserOrders(userId);
  }
}
