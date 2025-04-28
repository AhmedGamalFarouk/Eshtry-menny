import 'package:flutter_bloc/flutter_bloc.dart';

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
  FavoritesCubit() : super(FavoritesInitial());

  final List<dynamic> _favorites = [];

  void toggleFavorite(dynamic product) {
    if (_favorites.any((item) => item['id'] == product['id'])) {
      _favorites.removeWhere((item) => item['id'] == product['id']);
    } else {
      _favorites.add(product);
    }
    emit(FavoritesLoaded(_favorites));
  }

  bool isFavorite(dynamic product) {
    return _favorites.any((item) => item['id'] == product['id']);
  }

  void getFavorites() {
    emit(FavoritesLoaded(_favorites));
  }
}