import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/widgets/custom_app_bar.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _scaleController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.background),
      appBar: const CustomAppBar(title: 'Order Confirmed'),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success Icon with Animation
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildSuccessIcon(),
                    ),
                    SizedBox(height: 6.h),

                    // Success Message
                    _buildSuccessMessage(),
                    SizedBox(height: 4.h),

                    // Order Details Card
                    _buildOrderDetailsCard(),
                    SizedBox(height: 6.h),

                    // Continue Shopping Button
                    _buildContinueShoppingButton(),
                    SizedBox(height: 2.h),

                    // Track Order Button
                    _buildTrackOrderButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 35.w,
      height: 35.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(MyColors.primaryRed).withOpacity(0.1),
            const Color(MyColors.primaryRedLight).withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(MyColors.primaryRed).withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(MyColors.primaryRed),
              const Color(MyColors.primaryRedLight),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(MyColors.primaryRed).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          Icons.check_rounded,
          size: 15.w,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        Text(
          'Order Confirmed!',
          style: TextStyle(
            color: const Color(MyColors.textColor),
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),
        Text(
          'Your order has been placed successfully.\nWe\'ll send you a confirmation email shortly.',
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

  Widget _buildOrderDetailsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(MyColors.textfieldBakground),
            const Color(MyColors.textfieldBakground).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(MyColors.primaryRed).withOpacity(0.1),
                      const Color(MyColors.primaryRedLight).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.shopping_bag_rounded,
                  color: const Color(MyColors.primaryRed),
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Order Details',
                style: TextStyle(
                  color: const Color(MyColors.textColor),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildOrderDetailRow('Order ID',
              '#ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'),
          SizedBox(height: 1.5.h),
          _buildOrderDetailRow('Estimated Delivery', '3-5 Business Days'),
          SizedBox(height: 1.5.h),
          _buildOrderDetailRow('Payment Method', 'Credit Card'),
        ],
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(MyColors.textSecondary),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(MyColors.textColor),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueShoppingButton() {
    return Container(
      width: double.infinity,
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
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Continue Shopping',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrackOrderButton() {
    return Container(
      width: double.infinity,
      height: 6.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(MyColors.primaryRed).withOpacity(0.3),
          width: 2,
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
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.lightImpact();
            // Add track order functionality here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Track order feature coming soon!'),
                backgroundColor: const Color(MyColors.primaryRed),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_shipping_rounded,
                  color: const Color(MyColors.primaryRed),
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Track Your Order',
                  style: TextStyle(
                    color: const Color(MyColors.primaryRed),
                    fontSize: 14.sp,
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
}
