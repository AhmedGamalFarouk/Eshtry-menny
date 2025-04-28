import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/navigation_cubit.dart';
import '../../../core/constants/mycolors.dart';
import '../cubit/auth_cubit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
          padding: EdgeInsets.symmetric(
              horizontal: 3.h, vertical: 15.w), // Changed from 15.h to 15.w
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Text(
                'Sign up',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 6.h),
              TextField(
                controller: _nameController,
                style: TextStyle(color: Color(MyColors.textColor)),
                decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Color(MyColors.secondaryGrey)),
                    fillColor: Color(MyColors.textfieldBakground),
                    filled: true,
                    contentPadding: EdgeInsets.all(1.5.h)),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 1.h),
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
              TextField(
                controller: _passwordController,
                style: TextStyle(color: Color(MyColors.textColor)),
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Color(MyColors.secondaryGrey)),
                    fillColor: Color(MyColors
                        .textfieldBakground), // Changed from MyColors.textColor to MyColors.textfieldBakground
                    filled: true,
                    contentPadding: EdgeInsets.all(1.5.h)),
                obscureText: true,
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => context.read<NavigationCubit>().showSignIn(),
                    child: Row(
                      children: [
                        Text(
                          'Already have an account?',
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
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill all fields')),
                        );
                        return;
                      }
                      context.read<AuthCubit>().signUp(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(MyColors.primaryRed),
                      minimumSize: Size(double.infinity, 6.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: state is AuthLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('SIGN UP',
                            style: Theme.of(context).textTheme.labelLarge),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
