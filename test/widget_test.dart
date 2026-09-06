import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:e_commers_app/core/network/api_client.dart';
import 'package:e_commers_app/core/network/api_exceptions.dart';
import 'package:e_commers_app/core/navigation_cubit.dart' as nav;
import 'package:e_commers_app/core/views/main_screen.dart';
import 'package:e_commers_app/features/home/data/models/product_model.dart';
import 'package:e_commers_app/features/home/data/repositories/product_repository.dart';
import 'package:e_commers_app/features/home/cubit/product_cubit.dart';
import 'package:e_commers_app/features/home/cubit/product_state.dart';
import 'package:e_commers_app/features/cart/cubit/cart_cubit.dart';
import 'package:e_commers_app/features/auth/cubit/auth_cubit.dart';
import 'package:e_commers_app/features/auth/data/repositories/auth_repository.dart';
import 'package:e_commers_app/features/favorites/cubit/favorites_cubit.dart';
import 'package:e_commers_app/main.dart';

// Mock ProductRepository for unit testing
class MockProductRepository implements ProductRepository {
  final List<ProductModel> products;
  final List<String> categories;
  final bool shouldThrow;

  MockProductRepository({
    this.products = const [],
    this.categories = const [],
    this.shouldThrow = false,
  });

  @override
  Future<List<ProductModel>> getProducts() async {
    if (shouldThrow) throw const NetworkException('Connection failed');
    return products;
  }

  @override
  Future<List<String>> getCategories() async {
    if (shouldThrow) throw const NetworkException('Connection failed');
    return categories;
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    if (shouldThrow) throw const NetworkException('Connection failed');
    return products.firstWhere((p) => p.id == id);
  }
}

// Mock AuthRepository for unit testing
class MockAuthRepository implements AuthRepository {
  final bool shouldFail;
  String? savedToken;
  String? savedUsername;

  MockAuthRepository({this.shouldFail = false, this.savedToken});

  @override
  Future<String> signIn(String username, String password) async {
    if (shouldFail) throw const AuthException('Invalid credentials.');
    savedToken = 'mock_token_123';
    savedUsername = username;
    return savedToken!;
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (shouldFail) throw const ClientException('Registration failed.');
  }

  @override
  Future<void> signOut() async {
    savedToken = null;
    savedUsername = null;
  }

  @override
  Future<String?> getSavedToken() async => savedToken;

  @override
  Future<String?> getSavedUsername() async => savedUsername;

  @override
  Future<bool> isAuthenticated() async =>
      savedToken != null && savedToken!.isNotEmpty;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ProductModel Tests', () {
    test('Correctly deserializes from JSON with integer price', () {
      final json = {
        'id': 1,
        'title': 'Test Jacket',
        'price': 45, // int instead of double
        'description': 'A warm jacket',
        'category': 'clothing',
        'image': 'https://fakestoreapi.com/img/jacket.jpg',
        'rating': {'rate': 4.5, 'count': 120}
      };

      final product = ProductModel.fromJson(json);

      expect(product.id, 1);
      expect(product.title, 'Test Jacket');
      expect(product.price, 45.0);
      expect(product.rating.rate, 4.5);
      expect(product.rating.count, 120);
    });

    test('Correctly converts to Map via toMap()', () {
      final product = ProductModel(
        id: 2,
        title: 'Running Shoes',
        price: 89.99,
        description: 'Sport shoes',
        category: 'footwear',
        image: 'https://fakestoreapi.com/img/shoes.jpg',
        rating: Rating(rate: 4.8, count: 200),
      );

      final map = product.toMap();

      expect(map['id'], 2);
      expect(map['title'], 'Running Shoes');
      expect(map['price'], 89.99);
      expect(map['rating']['rate'], 4.8);
      expect(map['rating']['count'], 200);
    });
  });

  group('CartItem Tests', () {
    test('Calculates total price based on quantity', () {
      final item = CartItem(
        id: 3,
        title: 'Coffee Mug',
        price: 12.50,
        image: 'https://fakestoreapi.com/img/mug.jpg',
        quantity: 3,
      );
      expect(item.totalPrice, 37.50);

      final singleItem = CartItem(
        id: 3,
        title: 'Coffee Mug',
        price: 12.50,
        image: 'https://fakestoreapi.com/img/mug.jpg',
      );
      expect(singleItem.quantity, 1);
      expect(singleItem.totalPrice, 12.50);
    });
  });

  group('NavigationCubit Tests', () {
    test('Initial state is SignInState with tabIndex 0', () {
      final cubit = nav.NavigationCubit();
      expect(cubit.state, isA<nav.SignInState>());
      expect(cubit.state.tabIndex, 0);
      cubit.close();
    });

    test('State transitions emit expected states', () {
      final cubit = nav.NavigationCubit();

      cubit.showSignUp();
      expect(cubit.state, isA<nav.SignUpState>());

      cubit.showHome();
      expect(cubit.state, isA<nav.HomeState>());
      expect(cubit.state.tabIndex, 0);

      cubit.showFavorites();
      expect(cubit.state, isA<nav.FavoritesState>());
      expect(cubit.state.tabIndex, 1);

      cubit.showCart();
      expect(cubit.state, isA<nav.CartState>());
      expect(cubit.state.tabIndex, 2);

      cubit.showSignIn();
      expect(cubit.state, isA<nav.SignInState>());

      cubit.close();
    });

    test('changeTab switches between Home, Favorites, and Cart', () {
      final cubit = nav.NavigationCubit();

      cubit.changeTab(1);
      expect(cubit.state, isA<nav.FavoritesState>());
      expect(cubit.state.tabIndex, 1);

      cubit.changeTab(2);
      expect(cubit.state, isA<nav.CartState>());
      expect(cubit.state.tabIndex, 2);

      cubit.changeTab(0);
      expect(cubit.state, isA<nav.HomeState>());
      expect(cubit.state.tabIndex, 0);

      cubit.close();
    });
  });

  group('ApiClient Resilience & Retry Tests', () {
    test('Successful GET parses JSON response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
            json.encode([
              {'id': 1, 'title': 'Product 1'}
            ]),
            200);
      });

      final apiClient = ApiClient(httpClient: mockClient);
      final result = await apiClient.get('https://fakestoreapi.com/products');

      expect(result, isA<List>());
      expect((result as List).first['title'], 'Product 1');
    });

    test('Immediate 401 throws AuthException without retrying', () async {
      int requestCount = 0;
      final mockClient = MockClient((request) async {
        requestCount++;
        return http.Response('{"error": "Unauthorized"}', 401);
      });

      final apiClient = ApiClient(httpClient: mockClient, defaultMaxRetries: 3);

      await expectLater(
        apiClient.post('https://fakestoreapi.com/auth/login', body: {}),
        throwsA(isA<AuthException>()),
      );
      // Non-transient errors must NOT be retried
      expect(requestCount, 1);
    });

    test('Retries on 500 server error and throws ServerException when exhausted',
        () async {
      int requestCount = 0;
      final mockClient = MockClient((request) async {
        requestCount++;
        return http.Response('Server Error', 500);
      });

      final apiClient = ApiClient(httpClient: mockClient, defaultMaxRetries: 2);

      await expectLater(
        apiClient.get('https://fakestoreapi.com/products'),
        throwsA(isA<ServerException>()),
      );
      expect(requestCount, 2);
    });
  });

  group('ProductCubit Domain/Repository Injection Tests', () {
    final sampleProducts = [
      ProductModel(
        id: 1,
        title: 'Mens Cotton Jacket',
        price: 55.99,
        description: 'Great outerwear',
        category: 'men\'s clothing',
        image: 'https://fakestoreapi.com/img/1.jpg',
        rating: Rating(rate: 4.7, count: 500),
      ),
      ProductModel(
        id: 2,
        title: 'Gold Ring',
        price: 199.99,
        description: 'Fine jewelry',
        category: 'jewelery',
        image: 'https://fakestoreapi.com/img/2.jpg',
        rating: Rating(rate: 4.9, count: 80),
      ),
    ];
    final sampleCategories = ['men\'s clothing', 'jewelery'];

    test('loadInitialData loads categories and products via mock repository',
        () async {
      final mockRepo = MockProductRepository(
        products: sampleProducts,
        categories: sampleCategories,
      );
      final cubit = ProductCubit(repository: mockRepo);

      await cubit.loadInitialData();

      expect(cubit.state, isA<ProductsLoaded>());
      final loadedState = cubit.state as ProductsLoaded;
      expect(loadedState.products.length, 2);
      expect(loadedState.categories, ['All', ...sampleCategories]);
      cubit.close();
    });

    test('selectCategory filters loaded products in-memory', () async {
      final mockRepo = MockProductRepository(
        products: sampleProducts,
        categories: sampleCategories,
      );
      final cubit = ProductCubit(repository: mockRepo);

      await cubit.loadInitialData();
      cubit.selectCategory('jewelery');

      final loadedState = cubit.state as ProductsLoaded;
      expect(loadedState.products.length, 1);
      expect(loadedState.products.first.title, 'Gold Ring');
      cubit.close();
    });

    test('loadInitialData emits ProductError when repository throws', () async {
      final mockRepo = MockProductRepository(shouldThrow: true);
      final cubit = ProductCubit(repository: mockRepo);

      await cubit.loadInitialData();

      expect(cubit.state, isA<ProductError>());
      final errorState = cubit.state as ProductError;
      expect(errorState.message, contains('Connection failed'));
      cubit.close();
    });
  });

  group('AuthCubit Domain/Repository Injection Tests', () {
    test('signIn emits AuthLoading then AuthSuccess on valid credentials',
        () async {
      final mockAuthRepo = MockAuthRepository();
      final cubit = AuthCubit(repository: mockAuthRepo);

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ]),
      );

      await cubit.signIn('mor_2314', '83r5^_');
      expect(mockAuthRepo.savedToken, 'mock_token_123');
      cubit.close();
    });

    test('signIn emits AuthError when repository throws AuthException',
        () async {
      final mockAuthRepo = MockAuthRepository(shouldFail: true);
      final cubit = AuthCubit(repository: mockAuthRepo);

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthError>(),
        ]),
      );

      await cubit.signIn('invalid_user', 'wrong_pass');
      cubit.close();
    });

    test('signOut clears repository session and emits AuthUnauthenticated',
        () async {
      final mockAuthRepo =
          MockAuthRepository(savedToken: 'existing_token_xyz');
      final cubit = AuthCubit(repository: mockAuthRepo, isLoggedIn: true);

      await cubit.signOut();

      expect(cubit.state, isA<AuthUnauthenticated>());
      expect(mockAuthRepo.savedToken, isNull);
      cubit.close();
    });
  });

  group('App Smoke & Navigation Tests', () {
    testWidgets('Renders SignInPage on initial launch',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Sizer(
          builder: (context, orientation, deviceType) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => nav.NavigationCubit()),
                BlocProvider(create: (context) => ProductCubit()),
                BlocProvider(create: (context) => AuthCubit()),
                BlocProvider(create: (context) => FavoritesCubit()),
                BlocProvider(create: (context) => CartCubit()),
              ],
              child: const MyApp(),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      // Verify that Sign In page is present
      expect(find.text('Sign In'), findsWidgets);
    });

    testWidgets('Renders MainScreen with IndexedStack when in HomeState',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Sizer(
          builder: (context, orientation, deviceType) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => nav.NavigationCubit(
                    initialState: const nav.HomeState(),
                  ),
                ),
                BlocProvider(create: (context) => ProductCubit()),
                BlocProvider(create: (context) => AuthCubit(isLoggedIn: true)),
                BlocProvider(create: (context) => FavoritesCubit()),
                BlocProvider(create: (context) => CartCubit()),
              ],
              child: const MyApp(),
            );
          },
        ),
      );

      await tester.pump();

      // Verify MainScreen and BottomNavigationBar exist
      expect(find.byType(MainScreen), findsOneWidget);
      expect(find.byType(IndexedStack), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
