import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../favorites/cubit/favorites_cubit.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
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
    final rating = widget.product['rating'] ?? {'rate': 0.0, 'count': 0};
    final rateValue = (rating['rate'] is num) ? (rating['rate'] as num).toDouble() : 0.0;
    final countValue = rating['count'] ?? 0;
    final inCart = context.watch<CartCubit>().isInCart(widget.product);
    final isFav = context.watch<FavoritesCubit>().isFavorite(widget.product);

    return Scaffold(
      backgroundColor: const Color(MyColors.background),
      appBar: const CustomAppBar(
        title: 'Product Details',
        automaticallyImplyLeading: true,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Showcase Hero Card
                    Container(
                      height: 38.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Hero(
                              tag: 'product_${widget.product['id']}',
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: CachedNetworkImage(
                                  imageUrl: widget.product['image'] ?? '',
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(MyColors.primaryRed),
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.grey,
                                      size: 48,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Floating Favorite Button
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  context
                                      .read<FavoritesCubit>()
                                      .toggleFavorite(widget.product);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: isFav
                                        ? const Color(MyColors.primaryRed)
                                        : Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Category Pill & Rating Badge Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(MyColors.textfieldBakground),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(MyColors.borderSubtle),
                            ),
                          ),
                          child: Text(
                            widget.product['category'].toString().toUpperCase(),
                            style: const TextStyle(
                              color: Color(MyColors.primaryRedLight),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(MyColors.warning),
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rateValue.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Color(MyColors.textColor),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '($countValue reviews)',
                              style: const TextStyle(
                                color: Color(MyColors.textSecondary),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Title
                    Text(
                      widget.product['title'] ?? '',
                      style: const TextStyle(
                        color: Color(MyColors.textColor),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Price & Stock Tag
                    Row(
                      children: [
                        Text(
                          '\$${(widget.product['price'] as num).toDouble().toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(MyColors.primaryRed),
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(MyColors.success)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(MyColors.success)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                color: Color(MyColors.success),
                                size: 13,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'In Stock',
                                style: TextStyle(
                                  color: Color(MyColors.success),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: Color(MyColors.borderSubtle)),
                    const SizedBox(height: 14),

                    // Description Section
                    const Text(
                      'Overview',
                      style: TextStyle(
                        color: Color(MyColors.textColor),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product['description'] ?? '',
                      style: const TextStyle(
                        color: Color(MyColors.textSecondary),
                        fontSize: 13.5,
                        height: 1.55,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quality Guarantees
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(MyColors.cardBackground),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(MyColors.borderSubtle),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildGuaranteeItem(
                            icon: Icons.verified_user_outlined,
                            title: 'Authentic',
                            subtitle: '100% Original',
                          ),
                          Container(
                            width: 1,
                            height: 32,
                            color: const Color(MyColors.borderSubtle),
                          ),
                          _buildGuaranteeItem(
                            icon: Icons.local_shipping_outlined,
                            title: 'Fast Shipping',
                            subtitle: 'Free standard',
                          ),
                          Container(
                            width: 1,
                            height: 32,
                            color: const Color(MyColors.borderSubtle),
                          ),
                          _buildGuaranteeItem(
                            icon: Icons.cached_rounded,
                            title: 'Easy Return',
                            subtitle: '30-day window',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // Sticky Bottom Action Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          color: Color(MyColors.surface),
          border: Border(
            top: BorderSide(color: Color(MyColors.borderSubtle), width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Price',
                    style: TextStyle(
                      color: Color(MyColors.secondaryGrey),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${(widget.product['price'] as num).toDouble().toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(MyColors.textColor),
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    context.read<CartCubit>().addToCart(
                          id: widget.product['id'],
                          title: widget.product['title'],
                          price: (widget.product['price'] as num).toDouble(),
                          image: widget.product['image'],
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: inCart
                        ? const Color(MyColors.success)
                        : const Color(MyColors.primaryRed),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        inCart
                            ? Icons.check_circle_rounded
                            : Icons.add_shopping_cart_rounded,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        inCart ? 'Added to Cart' : 'Add to Cart',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuaranteeItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(MyColors.primaryRed), size: 20),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Color(MyColors.textColor),
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(MyColors.secondaryGrey),
            fontSize: 9.5,
          ),
        ),
      ],
    );
  }
}
