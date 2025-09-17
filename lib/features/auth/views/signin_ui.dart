import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/navigation_cubit.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../cubit/auth_cubit.dart';

import 'signup_ui.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
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
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(MyColors.error),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
        setState(() {
          _isLoading = state is AuthLoading;
        });
      },
      child: Scaffold(
        backgroundColor: const Color(MyColors.background),
        appBar: const CustomAppBar(title: 'Sign In'),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Welcome section
                      _buildWelcomeSection(),
                      SizedBox(height: 6.h),

                      // Email field
                      _buildEmailField(),
                      SizedBox(height: 3.h),

                      // Password field
                      _buildPasswordField(),
                      SizedBox(height: 2.h),

                      // Forgot password
                      _buildForgotPassword(),
                      SizedBox(height: 4.h),

                      // Sign in button
                      _buildSignInButton(),
                      SizedBox(height: 2.h),

                      // Test login button
                      _buildTestLoginButton(),
                      SizedBox(height: 3.h),

                      // Divider
                      _buildDivider(),
                      SizedBox(height: 3.h),

                      // Sign up link
                      _buildSignUpLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                const Color(MyColors.primaryRed).withOpacity(0.15),
                const Color(MyColors.primaryRedLight).withOpacity(0.1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(MyColors.primaryRed).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.shopping_bag_rounded,
            size: 12.w,
            color: const Color(MyColors.primaryRed),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Welcome Back!',
          style: TextStyle(
            color: const Color(MyColors.textColor),
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.8,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.5.h),
        Text(
          'Sign in to continue your shopping journey',
          style: TextStyle(
            color: const Color(MyColors.textSecondary),
            fontSize: 16.sp,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: TextStyle(
            color: const Color(MyColors.textColor),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            color: const Color(MyColors.textColor),
            fontSize: 16.sp,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your username',
            hintStyle: TextStyle(
              color: const Color(MyColors.textSecondary),
              fontSize: 16.sp,
            ),
            filled: true,
            fillColor: const Color(MyColors.textfieldBakground),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(MyColors.primaryRed),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(MyColors.error),
                width: 2,
              ),
            ),
            prefixIcon: Container(
              margin: EdgeInsets.all(3.w),
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(MyColors.primaryRed).withOpacity(0.15),
                    const Color(MyColors.primaryRedLight).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(MyColors.primaryRed).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color(MyColors.primaryRed),
                size: 20,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your username';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            color: const Color(MyColors.textColor),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          style: TextStyle(
            color: const Color(MyColors.textColor),
            fontSize: 16.sp,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: TextStyle(
              color: const Color(MyColors.textSecondary),
              fontSize: 16.sp,
            ),
            filled: true,
            fillColor: const Color(MyColors.textfieldBakground),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(MyColors.primaryRed),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(MyColors.error),
                width: 2,
              ),
            ),
            prefixIcon: Container(
              margin: EdgeInsets.all(3.w),
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(MyColors.primaryRed).withOpacity(0.15),
                    const Color(MyColors.primaryRedLight).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(MyColors.primaryRed).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Color(MyColors.primaryRed),
                size: 20,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: const Color(MyColors.textSecondary),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Implement forgot password functionality
          HapticFeedback.lightImpact();
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: const Color(MyColors.primaryRed),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      context.read<AuthCubit>().signIn(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  Widget _buildSignInButton() {
    return Container(
      height: 7.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(MyColors.primaryRed),
            Color(MyColors.primaryRedLight),
            Color(MyColors.primaryRedDark),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(MyColors.primaryRed).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(MyColors.primaryRed).withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _isLoading
              ? null
              : () {
                  HapticFeedback.mediumImpact();
                  _handleSignIn();
                },
          child: Container(
            alignment: Alignment.center,
            child: _isLoading
                ? SizedBox(
                    height: 6.w,
                    width: 6.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(MyColors.secondaryGrey),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: const Color(MyColors.textSecondary),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(MyColors.secondaryGrey),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTestLoginButton() {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            const Color(MyColors.textfieldBakground),
            const Color(MyColors.textfieldBakground).withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: const Color(MyColors.primaryRed).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: _isLoading
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  _handleTestLogin();
                },
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Test Login (mor_2314)',
              style: TextStyle(
                color: const Color(MyColors.primaryRed),
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTestLogin() {
    HapticFeedback.lightImpact();
    _emailController.text = 'mor_2314';
    _passwordController.text = '83r5^_';
    context.read<AuthCubit>().signIn(
          'mor_2314',
          '83r5^_',
        );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: TextStyle(
            color: const Color(MyColors.textSecondary),
            fontSize: 16.sp,
          ),
        ),
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: const Color(MyColors.primaryRed),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
