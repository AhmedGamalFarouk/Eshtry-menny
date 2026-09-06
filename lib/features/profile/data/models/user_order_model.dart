class UserOrderModel {
  final int id;
  final int userId;
  final DateTime date;
  final List<OrderProductItem> products;

  UserOrderModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  int get totalItemCount =>
      products.fold(0, (sum, item) => sum + item.quantity);

  String get formattedDate {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  factory UserOrderModel.fromJson(Map<String, dynamic> json) {
    var rawProducts = json['products'] as List? ?? [];
    return UserOrderModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      products: rawProducts
          .map((p) => OrderProductItem.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}

class OrderProductItem {
  final int productId;
  final int quantity;

  OrderProductItem({required this.productId, required this.quantity});

  factory OrderProductItem.fromJson(Map<String, dynamic> json) {
    return OrderProductItem(
      productId: json['productId'] ?? 0,
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}
