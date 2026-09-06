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
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE cart_items(id INTEGER PRIMARY KEY, title TEXT, price REAL, image TEXT, quantity INTEGER)',
        );
        await db.execute(
          'CREATE TABLE favorites(id INTEGER PRIMARY KEY, title TEXT, price REAL, description TEXT, category TEXT, image TEXT, rating_rate REAL, rating_count INTEGER)',
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'CREATE TABLE IF NOT EXISTS favorites(id INTEGER PRIMARY KEY, title TEXT, price REAL, description TEXT, category TEXT, image TEXT, rating_rate REAL, rating_count INTEGER)',
          );
        }
      },
    );
  }

  // Cart Operations
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

  // Favorites Operations
  Future<void> insertFavorite(Map<String, dynamic> item) async {
    final db = await database;
    final rating = item['rating'];
    double ratingRate = 0.0;
    int ratingCount = 0;

    if (rating is Map) {
      ratingRate = rating['rate'] != null ? (rating['rate'] as num).toDouble() : 0.0;
      ratingCount = rating['count'] != null ? (rating['count'] as num).toInt() : 0;
    }

    await db.insert(
      'favorites',
      {
        'id': item['id'],
        'title': item['title'] ?? '',
        'price': item['price'] != null ? (item['price'] as num).toDouble() : 0.0,
        'description': item['description'] ?? '',
        'category': item['category'] ?? '',
        'image': item['image'] ?? '',
        'rating_rate': ratingRate,
        'rating_count': ratingCount,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return maps.map((map) {
      return {
        'id': map['id'],
        'title': map['title'],
        'price': map['price'],
        'description': map['description'],
        'category': map['category'],
        'image': map['image'],
        'rating': {
          'rate': map['rating_rate'] ?? 0.0,
          'count': map['rating_count'] ?? 0,
        },
      };
    }).toList();
  }

  Future<void> deleteFavorite(int id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearFavorites() async {
    final db = await database;
    await db.delete('favorites');
  }
}
