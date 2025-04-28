import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.background),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/bags.png',
                width: 40.w,
                height: 40.w,
              ),
              SizedBox(height: 4.h),
              Text(
                'Success!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Color(MyColors.textColor),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Your order will be delivered soon.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Color(MyColors.textSecondary),
                    ),
              ),
              Text(
                'Thank you for choosing our app!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Color(MyColors.textSecondary),
                    ),
              ),
              SizedBox(height: 6.h),
              SizedBox(
                width: 80.w,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: () {
                    // Pop until we reach the main shopping interface
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(MyColors.primaryRed),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'CONTINUE SHOPPING',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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