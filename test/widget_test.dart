import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:e_commers_app/core/navigation_cubit.dart' as nav;
import 'package:e_commers_app/core/views/main_screen.dart';
import 'package:e_commers_app/features/home/data/models/product_model.dart';
import 'package:e_commers_app/features/cart/cubit/cart_cubit.dart';
import 'package:e_commers_app/features/auth/cubit/auth_cubit.dart';
import 'package:e_commers_app/features/favorites/cubit/favorites_cubit.dart';
import 'package:e_commers_app/features/home/cubit/product_cubit.dart';
import 'package:e_commers_app/main.dart';

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

  group('AuthCubit Session Tests', () {
    test('AuthCubit initializes with AuthInitial when not logged in', () {
      final cubit = AuthCubit();
      expect(cubit.state, isA<AuthInitial>());
      cubit.close();
    });

    test('AuthCubit initializes with AuthSuccess when isLoggedIn is true', () {
      final cubit = AuthCubit(isLoggedIn: true);
      expect(cubit.state, isA<AuthSuccess>());
      cubit.close();
    });

    test('checkAuthStatus emits AuthUnauthenticated when no token is saved', () async {
      SharedPreferences.setMockInitialValues({});
      final cubit = AuthCubit();
      await cubit.checkAuthStatus();
      expect(cubit.state, isA<AuthUnauthenticated>());
      cubit.close();
    });

    test('checkAuthStatus emits AuthSuccess when token exists in storage', () async {
      SharedPreferences.setMockInitialValues({
        AuthCubit.tokenKey: 'sample_jwt_token',
      });
      final cubit = AuthCubit();
      await cubit.checkAuthStatus();
      expect(cubit.state, isA<AuthSuccess>());
      cubit.close();
    });

    test('signOut removes token and emits AuthUnauthenticated', () async {
      SharedPreferences.setMockInitialValues({
        AuthCubit.tokenKey: 'sample_jwt_token',
        AuthCubit.usernameKey: 'mor_2314',
      });
      final cubit = AuthCubit(isLoggedIn: true);
      await cubit.signOut();

      expect(cubit.state, isA<AuthUnauthenticated>());

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(AuthCubit.tokenKey), isNull);
      expect(prefs.getString(AuthCubit.usernameKey), isNull);
      cubit.close();
    });
  });

  group('App Smoke & Navigation Tests', () {
    testWidgets('Renders SignInPage on initial launch', (WidgetTester tester) async {
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

    testWidgets('Renders MainScreen with IndexedStack when in HomeState', (WidgetTester tester) async {
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
