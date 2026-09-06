import '../../../../core/services/database_helper.dart';

abstract class FavoritesRepository {
  Future<List<Map<String, dynamic>>> getFavorites();
  Future<void> addFavorite(Map<String, dynamic> item);
  Future<void> deleteFavorite(int id);
  Future<void> clearFavorites();
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  final DatabaseHelper databaseHelper;

  FavoritesRepositoryImpl({DatabaseHelper? dbHelper})
      : databaseHelper = dbHelper ?? DatabaseHelper();

  @override
  Future<List<Map<String, dynamic>>> getFavorites() async {
    return await databaseHelper.getFavorites();
  }

  @override
  Future<void> addFavorite(Map<String, dynamic> item) async {
    await databaseHelper.insertFavorite(item);
  }

  @override
  Future<void> deleteFavorite(int id) async {
    await databaseHelper.deleteFavorite(id);
  }

  @override
  Future<void> clearFavorites() async {
    await databaseHelper.clearFavorites();
  }
}
