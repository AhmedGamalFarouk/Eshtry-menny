import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/mycolors.dart';

class CategoriesTopRow extends StatelessWidget {
  final String text;

  const CategoriesTopRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(MyColors.textfieldBakground),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Color(MyColors.textColor),
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }
}
