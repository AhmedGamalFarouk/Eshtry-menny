import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/navigation_cubit.dart';

class EmptyFavorites extends StatefulWidget {
  const EmptyFavorites({super.key});

  @override
  State<EmptyFavorites> createState() => _EmptyFavoritesState();
}

class _EmptyFavoritesState extends State<EmptyFavorites>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Elevated Wishlist illustration
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(MyColors.textfieldBakground),
                    border: Border.all(
                      color: const Color(MyColors.borderSubtle),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(MyColors.primaryRed)
                            .withValues(alpha: 0.15),
                        blurRadius: 32,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 48,
                      color: Color(MyColors.primaryRed),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Main message
              const Text(
                'Your Wishlist is Empty',
                style: TextStyle(
                  color: Color(MyColors.textColor),
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  letterSpacing: -0.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Subtitle
              const Text(
                'Explore the curated collection and tap the heart on items you want to save.',
                style: TextStyle(
                  color: Color(MyColors.textSecondary),
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Explore Catalog button
              ScaleTransition(
                scale: _scaleAnimation,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.read<NavigationCubit>().showHome();
                  },
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('Explore Catalog'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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