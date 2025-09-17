import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../cubit/cart_cubit.dart';
import 'checkout_screen.dart';
import 'empty_cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

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
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
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
      bottomNavigationBar: const BottomNavBar(),
      appBar: CustomAppBar(
        title: 'My Cart',
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartInitial) {
                context.read<CartCubit>().loadCart();
                return const Center(child: EmptyCart());
              }
              if (state is CartLoaded) {
                if (state.items.isEmpty) {
                  return const EmptyCart();
                }
                return _buildCartContent(state);
              }
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(MyColors.primaryRed),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCartContent(CartLoaded state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            physics: const BouncingScrollPhysics(),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              return _buildCartItem(state.items[index], index);
            },
          ),
        ),
        _buildCheckoutSection(state),
      ],
    );
  }

  Widget _buildCartItem(item, int index) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dismissible(
        key: Key('cart_item_${item.id}'),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          HapticFeedback.mediumImpact();
          context.read<CartCubit>().removeFromCart(item.id);
        },
        background: Container(
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.red.shade400,
                Colors.red.shade600,
              ],
            ),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_rounded,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(MyColors.textfieldBakground),
                const Color(MyColors.textfieldBakground).withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(2.h),
            child: Row(
              children: [
                Hero(
                  tag: 'cart_item_${item.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 28.w,
                        height: 28.w,
                        color: Colors.white,
                        child: Image.network(
                          item.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey.shade400,
                                size: 10.w,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(MyColors.textColor),
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.5.h),
                      Row(
                        children: [
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: const Color(MyColors.textSecondary),
                              fontSize: 12.sp,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '\$${(item.price * 0.9).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: const Color(MyColors.textSecondary),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQuantityControls(item),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  color: const Color(MyColors.textSecondary),
                                  fontSize: 10.sp,
                                ),
                              ),
                              Text(
                                '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: const Color(MyColors.primaryRed),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls(item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(MyColors.background),
        border: Border.all(
          color: const Color(MyColors.primaryRed).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: Icons.remove_rounded,
            onPressed: item.quantity > 1
                ? () => context
                    .read<CartCubit>()
                    .updateQuantity(item.id, item.quantity - 1)
                : null,
            isEnabled: item.quantity > 1,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
            child: Text(
              '${item.quantity}',
              style: TextStyle(
                color: const Color(MyColors.primaryRed),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add_rounded,
            onPressed: () => context
                .read<CartCubit>()
                .updateQuantity(item.id, item.quantity + 1),
            isEnabled: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isEnabled,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isEnabled
            ? const Color(MyColors.primaryRed)
            : const Color(MyColors.textSecondary).withOpacity(0.3),
        borderRadius: BorderRadius.circular(18),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: const Color(MyColors.primaryRed).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isEnabled ? Colors.white : Colors.grey.shade400,
          size: 18,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: isEnabled
            ? () {
                HapticFeedback.lightImpact();
                onPressed?.call();
              }
            : null,
      ),
    );
  }

  Widget _buildCheckoutSection(CartLoaded state) {
    final totalItems =
        state.items.fold<int>(0, (sum, item) => sum + item.quantity);
    final originalPrice = state.items
        .fold<double>(0, (sum, item) => sum + (item.price * item.quantity));
    final discountedPrice = originalPrice * 0.9; // 10% discount
    final savings = originalPrice - discountedPrice;

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(MyColors.textfieldBakground),
            const Color(MyColors.textfieldBakground).withOpacity(0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, -10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Order summary header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Summary',
                  style: TextStyle(
                    color: const Color(MyColors.textColor),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(MyColors.primaryRed).withOpacity(0.1),
                  ),
                  child: Text(
                    '$totalItems items',
                    style: TextStyle(
                      color: const Color(MyColors.primaryRed),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Price breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: TextStyle(
                    color: const Color(MyColors.textSecondary),
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  '\$${originalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: const Color(MyColors.textColor),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount (10%)',
                  style: TextStyle(
                    color: const Color(MyColors.success),
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  '-\$${savings.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: const Color(MyColors.success),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Divider(
              color: const Color(MyColors.textSecondary).withOpacity(0.3),
              thickness: 1,
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    color: const Color(MyColors.textColor),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${discountedPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: const Color(MyColors.primaryRed),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            // Checkout button
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: double.infinity,
                height: 7.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(MyColors.primaryRed),
                      const Color(MyColors.primaryRedLight),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(MyColors.primaryRed).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
