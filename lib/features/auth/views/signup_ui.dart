import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/navigation_cubit.dart';
import '../../../core/constants/mycolors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../cubit/auth_cubit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
        appBar: const CustomAppBar(title: 'Sign Up'),
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
                      // Name field
                      _buildNameField(),
                      SizedBox(height: 3.h),

                      // Email field
                      _buildEmailField(),
                      SizedBox(height: 3.h),

                      // Password field
                      _buildPasswordField(),
                      SizedBox(height: 4.h),

                      // Sign up button
                      _buildSignUpButton(),
                      SizedBox(height: 3.h),

                      // Sign in link
                      _buildSignInLink(),
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
            Icons.person_add_rounded,
            size: 12.w,
            color: const Color(MyColors.primaryRed),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Create Account',
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
          'Join us and start your shopping adventure',
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

  Widget _buildNameField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        controller: _nameController,
        style: TextStyle(
          color: const Color(MyColors.textColor),
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: 'Full Name',
          labelStyle: TextStyle(
            color: const Color(MyColors.textSecondary),
            fontSize: 14.sp,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(3.w),
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(MyColors.primaryRed).withOpacity(0.1),
                  const Color(MyColors.primaryRedLight).withOpacity(0.05),
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
            child: Icon(
              Icons.person_rounded,
              color: const Color(MyColors.primaryRed),
              size: 20,
            ),
          ),
          filled: true,
          fillColor: const Color(MyColors.textfieldBakground),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: const Color(MyColors.primaryRed).withOpacity(0.3),
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.5.h,
          ),
        ),
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your full name';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        controller: _emailController,
        style: TextStyle(
          color: const Color(MyColors.textColor),
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: 'Email Address',
          labelStyle: TextStyle(
            color: const Color(MyColors.textSecondary),
            fontSize: 14.sp,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(3.w),
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(MyColors.primaryRed).withOpacity(0.1),
                  const Color(MyColors.primaryRedLight).withOpacity(0.05),
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
            child: Icon(
              Icons.email_rounded,
              color: const Color(MyColors.primaryRed),
              size: 20,
            ),
          ),
          filled: true,
          fillColor: const Color(MyColors.textfieldBakground),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: const Color(MyColors.primaryRed).withOpacity(0.3),
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.5.h,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email address';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        style: TextStyle(
          color: const Color(MyColors.textColor),
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            color: const Color(MyColors.textSecondary),
            fontSize: 14.sp,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(3.w),
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(MyColors.primaryRed).withOpacity(0.1),
                  const Color(MyColors.primaryRedLight).withOpacity(0.05),
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
            child: Icon(
              Icons.lock_rounded,
              color: const Color(MyColors.primaryRed),
              size: 20,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              color: const Color(MyColors.textSecondary),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          filled: true,
          fillColor: const Color(MyColors.textfieldBakground),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: const Color(MyColors.primaryRed).withOpacity(0.3),
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.5.h,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      height: 7.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(MyColors.primaryRed),
            const Color(MyColors.primaryRedLight),
          ],
          stops: const [0.0, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(MyColors.primaryRed).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: _isLoading ? null : _handleSignUp,
          child: Container(
            alignment: Alignment.center,
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_add_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: const Color(MyColors.textSecondary),
            fontSize: 14.sp,
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              HapticFeedback.lightImpact();
              context.read<NavigationCubit>().showSignIn();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: const Color(MyColors.primaryRed),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      context.read<AuthCubit>().signUp(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }
}
