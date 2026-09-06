class ApiEndpoints {
  static const String baseUrl = 'https://fakestoreapi.com';

  // Products
  static const String products = '$baseUrl/products';
  static const String categories = '$baseUrl/products/categories';
  static String productsByCategory(String category) =>
      '$baseUrl/products/category/$category';
  static String productDetails(int id) => '$baseUrl/products/$id';

  // Auth & Users
  static const String login = '$baseUrl/auth/login';
  static const String users = '$baseUrl/users';
  static String user(int id) => '$baseUrl/users/$id';
  static String userCarts(int userId) => '$baseUrl/carts/user/$userId';
}
