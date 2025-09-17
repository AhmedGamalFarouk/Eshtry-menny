import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/mycolors.dart';

class CategoriesTopRow extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoriesTopRow({
    super.key, 
    required this.text,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<CategoriesTopRow> createState() => _CategoriesTopRowState();
}

class _CategoriesTopRowState extends State<CategoriesTopRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: widget.isSelected 
                    ? const Color(MyColors.primaryRed)
                    : const Color(MyColors.textfieldBakground),
                boxShadow: widget.isSelected ? [
                  BoxShadow(
                    color: const Color(MyColors.primaryRed).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ] : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: widget.isSelected ? null : Border.all(
                  color: const Color(MyColors.secondaryGrey).withOpacity(0.2),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Center(
                child: Text(
                  widget.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.isSelected 
                        ? Colors.white
                        : const Color(MyColors.textColor),
                    fontSize: 14.sp,
                    fontWeight: widget.isSelected 
                        ? FontWeight.w600 
                        : FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
