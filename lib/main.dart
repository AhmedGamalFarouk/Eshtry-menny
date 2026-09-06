import 'package:e_commers_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'core/navigation_cubit.dart';
import 'core/views/main_screen.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/views/signin_ui.dart';
import 'features/auth/views/signup_ui.dart';
import 'features/cart/cubit/cart_cubit.dart';
import 'features/favorites/cubit/favorites_cubit.dart';
import 'features/home/cubit/product_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(AuthCubit.tokenKey);
  final isLoggedIn = token != null && token.isNotEmpty;

  runApp(Sizer(
    builder: (context, orientation, deviceType) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NavigationCubit(
              initialState:
                  isLoggedIn ? const HomeState() : const SignInState(),
            ),
          ),
          BlocProvider(create: (context) => ProductCubit()),
          BlocProvider(create: (context) => AuthCubit(isLoggedIn: isLoggedIn)),
          BlocProvider(create: (context) => FavoritesCubit()),
          BlocProvider(create: (context) => CartCubit()),
        ],
        child: const MyApp(),
      );
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: state is SignInState
              ? const SignInPage()
              : state is SignUpState
                  ? const SignUpPage()
                  : const MainScreen(),
          theme: AppTheme.darkTheme,
        );
      },
    );
  }
}
