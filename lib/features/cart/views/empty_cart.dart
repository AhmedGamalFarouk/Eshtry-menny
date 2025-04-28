import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Color(MyColors.primaryRed),
          ),
          SizedBox(height: 2.h),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Color(MyColors.textColor),
                ),
          ),
        ],
      ),
    );
  }
}