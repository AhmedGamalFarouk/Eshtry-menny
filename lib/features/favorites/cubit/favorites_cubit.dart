import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/favorites_repository.dart';

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
  final FavoritesRepository _favoritesRepository;
  final List<dynamic> _favorites = [];

  FavoritesCubit({FavoritesRepository? repository})
      : _favoritesRepository = repository ?? FavoritesRepositoryImpl(),
        super(FavoritesInitial()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      _favorites.clear();
      final persisted = await _favoritesRepository.getFavorites();
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
      await _favoritesRepository.deleteFavorite(productId);
    } else {
      _favorites.add(product);
      await _favoritesRepository.addFavorite(
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