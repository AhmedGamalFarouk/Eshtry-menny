import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: Color(MyColors.primaryRed),
          ),
          SizedBox(height: 2.h),
          Text(
            'No favorites yet',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Color(MyColors.textColor),
                ),
          ),
        ],
      ),
    );
  }
}