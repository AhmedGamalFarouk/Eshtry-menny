import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/cart_repository.dart';

class CartItem {
  final int id;
  final String title;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}

// Cart States
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalPrice;

  CartLoaded(this.items)
      : totalPrice = items.fold(0, (sum, item) => sum + item.totalPrice);
}

// Cart Cubit
class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;
  final List<CartItem> _items = [];

  CartCubit({CartRepository? repository})
      : _cartRepository = repository ?? CartRepositoryImpl(),
        super(CartInitial()) {
    loadCart();
  }

  bool isInCart(dynamic product) {
    return _items.any((item) => item.id == product['id']);
  }

  Future<void> addToCart({
    required int id,
    required String title,
    required double price,
    required String image,
  }) async {
    final existingItem = _items.firstWhere(
      (item) => item.id == id,
      orElse: () => CartItem(id: -1, title: '', price: 0, image: ''),
    );

    if (existingItem.id != -1) {
      existingItem.quantity++;
      await _cartRepository.updateCartItemQuantity(id, existingItem.quantity);
    } else {
      final cartItem = CartItem(
        id: id,
        title: title,
        price: price,
        image: image,
      );
      _items.add(cartItem);
      await _cartRepository.addCartItem(cartItem);
    }

    emit(CartLoaded(_items));
  }

  Future<void> loadCart() async {
    try {
      _items.clear();
      _items.addAll(await _cartRepository.getCartItems());
      emit(CartLoaded(_items));
    } catch (e) {
      emit(CartInitial());
    }
  }

  Future<void> removeFromCart(int id) async {
    _items.removeWhere((item) => item.id == id);
    await _cartRepository.deleteCartItem(id);
    emit(CartLoaded(_items));
  }

  Future<void> updateQuantity(int id, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(id);
      return;
    }

    final item = _items.firstWhere((item) => item.id == id);
    item.quantity = quantity;
    await _cartRepository.updateCartItemQuantity(id, quantity);
    emit(CartLoaded(_items));
  }

  Future<void> clearCart() async {
    _items.clear();
    await _cartRepository.clearCart();
    emit(CartLoaded(_items));
  }
}
