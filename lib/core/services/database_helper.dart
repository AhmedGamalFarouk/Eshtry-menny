import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/cart/cubit/cart_cubit.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE cart_items(id INTEGER PRIMARY KEY, title TEXT, price REAL, image TEXT, quantity INTEGER)',
        );
      },
    );
  }

  Future<void> insertCartItem(CartItem item) async {
    final db = await database;
    await db.insert(
      'cart_items',
      {
        'id': item.id,
        'title': item.title,
        'price': item.price,
        'image': item.image,
        'quantity': item.quantity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart_items');
    return List.generate(maps.length, (i) {
      return CartItem(
        id: maps[i]['id'],
        title: maps[i]['title'],
        price: maps[i]['price'],
        image: maps[i]['image'],
        quantity: maps[i]['quantity'],
      );
    });
  }

  Future<void> updateCartItemQuantity(int id, int quantity) async {
    final db = await database;
    await db.update(
      'cart_items',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteCartItem(int id) async {
    final db = await database;
    await db.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart_items');
  }
}
