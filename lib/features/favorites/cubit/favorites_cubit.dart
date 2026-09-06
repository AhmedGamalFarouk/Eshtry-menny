import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/database_helper.dart';

// States
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<dynamic> favorites;
  FavoritesLoaded(this.favorites);
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}

// Cubit
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial()) {
    loadFavorites();
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final List<dynamic> _favorites = [];

  Future<void> loadFavorites() async {
    try {
      _favorites.clear();
      final persisted = await _databaseHelper.getFavorites();
      _favorites.addAll(persisted);
      emit(FavoritesLoaded(List.from(_favorites)));
    } catch (e) {
      emit(FavoritesLoaded(List.from(_favorites)));
    }
  }

  Future<void> toggleFavorite(dynamic product) async {
    final productId = product['id'];
    final exists = _favorites.any((item) => item['id'] == productId);

    if (exists) {
      _favorites.removeWhere((item) => item['id'] == productId);
      await _databaseHelper.deleteFavorite(productId);
    } else {
      _favorites.add(product);
      await _databaseHelper.insertFavorite(
        product is Map<String, dynamic>
            ? product
            : Map<String, dynamic>.from(product as Map),
      );
    }
    emit(FavoritesLoaded(List.from(_favorites)));
  }

  bool isFavorite(dynamic product) {
    final productId = product['id'];
    return _favorites.any((item) => item['id'] == productId);
  }

  void getFavorites() {
    emit(FavoritesLoaded(List.from(_favorites)));
  }
}