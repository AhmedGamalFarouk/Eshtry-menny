import 'package:flutter/material.dart';
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

  String _formatCategory(String text) {
    if (text.isEmpty) return text;
    if (text.toLowerCase() == 'all') return 'All Items';
    return text
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : word)
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _formatCategory(widget.text);

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
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: widget.isSelected
                    ? const Color(MyColors.primaryRed)
                    : const Color(MyColors.textfieldBakground),
                border: Border.all(
                  color: widget.isSelected
                      ? const Color(MyColors.primaryRed)
                      : const Color(MyColors.borderSubtle),
                  width: 1,
                ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: const Color(MyColors.primaryRed)
                              .withValues(alpha: 0.28),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Center(
                child: Text(
                  displayText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.isSelected
                        ? Colors.white
                        : const Color(MyColors.textSecondary),
                    fontSize: 13,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    letterSpacing: -0.1,
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
