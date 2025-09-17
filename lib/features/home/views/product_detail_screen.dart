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
    return Scaffold(
      backgroundColor: const Color(MyColors.background),
      appBar: CustomAppBar(
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
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image Section
                    _buildProductImageSection(),
                    SizedBox(height: 3.h),

                    // Product Info Section
                    _buildProductInfoSection(),
                    SizedBox(height: 3.h),

                    // Description Section
                    _buildDescriptionSection(),
                    SizedBox(height: 3.h),

                    // Rating Section
                    _buildRatingSection(),
                    SizedBox(height: 4.h),

                    // Action Buttons
                    _buildActionButtons(),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImageSection() {
    return Container(
      height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Hero(
              tag: 'product_${widget.product['id']}',
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(6.w),
                child: Image.network(
                  widget.product['image'],
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: const Color(MyColors.primaryRed),
                        strokeWidth: 3,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: Color(MyColors.secondaryGrey),
                        size: 64,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Favorite button overlay
          Positioned(
            top: 3.w,
            right: 3.w,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    context.watch<FavoritesCubit>().isFavorite(widget.product)
                        ? const Color(MyColors.primaryRed)
                        : Colors.white.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.all(3.w),
                icon: Icon(
                  context.watch<FavoritesCubit>().isFavorite(widget.product)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color:
                      context.watch<FavoritesCubit>().isFavorite(widget.product)
                          ? Colors.white
                          : const Color(MyColors.primaryRed),
                  size: 24,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.read<FavoritesCubit>().toggleFavorite(widget.product);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfoSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(MyColors.textfieldBakground),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Title
          Text(
            widget.product['title'],
            style: TextStyle(
              color: const Color(MyColors.textColor),
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          SizedBox(height: 1.h),

          // Category
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(MyColors.primaryRed).withOpacity(0.1),
              border: Border.all(
                color: const Color(MyColors.primaryRed).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              widget.product['category'].toString().toUpperCase(),
              style: TextStyle(
                color: const Color(MyColors.primaryRed),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Price
          Row(
            children: [
              Text(
                'Price: ',
                style: TextStyle(
                  color: const Color(MyColors.textSecondary),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '\$${widget.product['price'].toStringAsFixed(2)}',
                style: TextStyle(
                  color: const Color(MyColors.primaryRed),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(MyColors.textfieldBakground),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              color: const Color(MyColors.textColor),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.5.h),
          Text(
            widget.product['description'],
            style: TextStyle(
              color: const Color(MyColors.textSecondary),
              fontSize: 14.sp,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    final rating = widget.product['rating'];
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(MyColors.textfieldBakground),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.star_rounded,
            color: const Color(MyColors.warning),
            size: 24,
          ),
          SizedBox(width: 2.w),
          Text(
            '${rating['rate'].toStringAsFixed(1)}',
            style: TextStyle(
              color: const Color(MyColors.textColor),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            '(${rating['count']} reviews)',
            style: TextStyle(
              color: const Color(MyColors.textSecondary),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          // Star rating display
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating['rate'].floor()
                    ? Icons.star_rounded
                    : index < rating['rate']
                        ? Icons.star_half_rounded
                        : Icons.star_border_rounded,
                color: const Color(MyColors.warning),
                size: 20,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      width: double.infinity,
      height: 6.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: context.watch<CartCubit>().isInCart(widget.product)
            ? LinearGradient(
                colors: [
                  const Color(MyColors.success),
                  const Color(MyColors.success).withOpacity(0.8),
                ],
              )
            : LinearGradient(
                colors: [
                  const Color(MyColors.primaryRed),
                  const Color(MyColors.primaryRedLight),
                ],
              ),
        boxShadow: [
          BoxShadow(
            color: (context.watch<CartCubit>().isInCart(widget.product)
                    ? const Color(MyColors.success)
                    : const Color(MyColors.primaryRed))
                .withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.mediumImpact();
            context.read<CartCubit>().addToCart(
                  id: widget.product['id'],
                  title: widget.product['title'],
                  price: widget.product['price'].toDouble(),
                  image: widget.product['image'],
                );
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  context.watch<CartCubit>().isInCart(widget.product)
                      ? Icons.check_rounded
                      : Icons.add_shopping_cart_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  context.watch<CartCubit>().isInCart(widget.product)
                      ? 'Added to Cart'
                      : 'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
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
