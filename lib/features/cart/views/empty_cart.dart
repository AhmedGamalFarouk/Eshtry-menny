import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/navigation_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmptyCart extends StatefulWidget {
  const EmptyCart({super.key});

  @override
  State<EmptyCart> createState() => _EmptyCartState();
}

class _EmptyCartState extends State<EmptyCart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated cart illustration
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 35.w,
                  height: 35.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(MyColors.primaryRed).withOpacity(0.1),
                        const Color(MyColors.primaryRed).withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 15.w,
                    color: const Color(MyColors.primaryRed),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              // Main message
              Text(
                'Your cart is empty',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(MyColors.textColor),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              // Subtitle
              Text(
                'Looks like you haven\'t added anything to your cart yet.\nStart shopping to fill it up!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(MyColors.textSecondary),
                      fontSize: 12.sp,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              // Shop now button
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 60.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(MyColors.primaryRed),
                        const Color(MyColors.primaryRedLight),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color(MyColors.primaryRed).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<NavigationCubit>().showHome();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Start Shopping',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
