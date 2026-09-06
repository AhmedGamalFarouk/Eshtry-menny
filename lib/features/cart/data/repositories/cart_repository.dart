import '../../../../core/services/database_helper.dart';
import '../../cubit/cart_cubit.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> addCartItem(CartItem item);
  Future<void> updateCartItemQuantity(int id, int quantity);
  Future<void> deleteCartItem(int id);
  Future<void> clearCart();
}

class CartRepositoryImpl implements CartRepository {
  final DatabaseHelper databaseHelper;

  CartRepositoryImpl({DatabaseHelper? dbHelper})
      : databaseHelper = dbHelper ?? DatabaseHelper();

  @override
  Future<List<CartItem>> getCartItems() async {
    return await databaseHelper.getCartItems();
  }

  @override
  Future<void> addCartItem(CartItem item) async {
    await databaseHelper.insertCartItem(item);
  }

  @override
  Future<void> updateCartItemQuantity(int id, int quantity) async {
    await databaseHelper.updateCartItemQuantity(id, quantity);
  }

  @override
  Future<void> deleteCartItem(int id) async {
    await databaseHelper.deleteCartItem(id);
  }

  @override
  Future<void> clearCart() async {
    await databaseHelper.clearCart();
  }
}
