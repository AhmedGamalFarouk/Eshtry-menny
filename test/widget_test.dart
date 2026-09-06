import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:e_commers_app/core/navigation_cubit.dart' as nav;
import 'package:e_commers_app/features/home/data/models/product_model.dart';
import 'package:e_commers_app/features/cart/cubit/cart_cubit.dart';
import 'package:e_commers_app/features/auth/cubit/auth_cubit.dart';
import 'package:e_commers_app/features/favorites/cubit/favorites_cubit.dart';
import 'package:e_commers_app/features/home/cubit/product_cubit.dart';
import 'package:e_commers_app/main.dart';

void main() {
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
        category: 'shoes',
        image: 'https://example.com/shoes.jpg',
        rating: Rating(rate: 4.8, count: 50),
      );

      final map = product.toMap();

      expect(map['id'], 2);
      expect(map['title'], 'Running Shoes');
      expect(map['price'], 89.99);
      expect(map['category'], 'shoes');
      expect(map['rating']['rate'], 4.8);
    });
  });

  group('CartItem Tests', () {
    test('Calculates total price based on quantity', () {
      final item = CartItem(
        id: 1,
        title: 'Backpack',
        price: 25.50,
        image: 'https://example.com/bag.jpg',
        quantity: 3,
      );

      expect(item.totalPrice, 76.50);
    });
  });

  group('NavigationCubit Tests', () {
    test('Initial state is SignInState', () {
      final cubit = nav.NavigationCubit();
      expect(cubit.state, isA<nav.SignInState>());
      cubit.close();
    });

    test('State transitions emit expected states', () {
      final cubit = nav.NavigationCubit();

      cubit.showSignUp();
      expect(cubit.state, isA<nav.SignUpState>());

      cubit.showHome();
      expect(cubit.state, isA<nav.HomeState>());

      cubit.showFavorites();
      expect(cubit.state, isA<nav.FavoritesState>());

      cubit.showCart();
      expect(cubit.state, isA<nav.CartState>());

      cubit.showSignIn();
      expect(cubit.state, isA<nav.SignInState>());

      cubit.close();
    });
  });

  group('App Smoke Test', () {
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
  });
}
