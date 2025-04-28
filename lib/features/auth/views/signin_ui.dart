import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/navigation_cubit.dart';
import '../cubit/auth_cubit.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.read<NavigationCubit>().showHome();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Color(MyColors.background),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Text(
                'Sign in',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 6.h),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Color(MyColors.textColor)),
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Color(MyColors.secondaryGrey)),
                    fillColor: Color(MyColors.textfieldBakground),
                    filled: true,
                    contentPadding: EdgeInsets.all(1.5.h)),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 1.h),
              // Padding(
              //   padding: EdgeInsets.only(left: 1.h),
              //   child: Text(
              //     'mor_2314',
              //     style: Theme.of(context).textTheme.labelSmall,
              //   ),
              // ),
              SizedBox(height: 1.h),
              TextField(
                controller: _passwordController,
                style: TextStyle(color: Color(MyColors.textColor)),
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Color(MyColors.secondaryGrey)),
                    fillColor: Color(MyColors.textfieldBakground),
                    filled: true,
                    contentPadding: EdgeInsets.all(1.5.h)),
                obscureText: true,
              ),
              SizedBox(height: 1.h),
              // Padding(
              //   padding: EdgeInsets.only(left: 1.h),
              //   child: Text(
              //     '83r5^_',
              //     style: Theme.of(context).textTheme.labelSmall,
              //   ),
              // ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      context.read<NavigationCubit>().showSignUp();
                    },
                    child: Row(
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          '→',
                          style: TextStyle(
                              color: Color(MyColors.primaryRed),
                              fontSize: 20.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().signIn(
                        _emailController.text,
                        _passwordController.text,
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(MyColors.primaryRed),
                ),
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return state is AuthLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'LOGIN',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Colors.white),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
