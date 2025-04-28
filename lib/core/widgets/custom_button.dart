import 'package:flutter/material.dart';
import '../constants/mycolors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: isOutlined
            ? ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: backgroundColor ?? Color(MyColors.primaryRed),
                padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 25),
                  side: BorderSide(
                    color: backgroundColor ?? Color(MyColors.primaryRed),
                    width: 1,
                  ),
                ),
              )
            : ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? Color(MyColors.primaryRed),
                foregroundColor: textColor ?? Color(MyColors.textColor),
                padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 25),
                ),
              ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isOutlined
                      ? (backgroundColor ?? Color(MyColors.primaryRed))
                      : (textColor ?? Color(MyColors.textColor)),
                ),
              ),
      ),
    );
  }
}
