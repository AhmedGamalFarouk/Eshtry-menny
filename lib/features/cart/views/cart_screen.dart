import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/mycolors.dart';
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
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            physics: const BouncingScrollPhysics(),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
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
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: const Color(MyColors.error).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
              SizedBox(width: 6),
              Text(
                'Remove',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(MyColors.cardBackground),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(MyColors.borderSubtle),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Product Image Squircle
              Hero(
                tag: 'cart_item_${item.id}',
                child: Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: item.image,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Color(MyColors.primaryRed),
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Title, Unit Price & Stepper
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(MyColors.textColor),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(MyColors.primaryRed),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        _buildQuantityControls(item),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls(item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(MyColors.textfieldBakground),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(MyColors.borderSubtle)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: item.quantity > 1
                ? Icons.remove_rounded
                : Icons.delete_outline_rounded,
            onPressed: item.quantity > 1
                ? () {
                    HapticFeedback.lightImpact();
                    context
                        .read<CartCubit>()
                        .updateQuantity(item.id, item.quantity - 1);
                  }
                : () {
                    HapticFeedback.mediumImpact();
                    context.read<CartCubit>().removeFromCart(item.id);
                  },
            isEnabled: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(
                color: Color(MyColors.textColor),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add_rounded,
            onPressed: () {
              HapticFeedback.lightImpact();
              context
                  .read<CartCubit>()
                  .updateQuantity(item.id, item.quantity + 1);
            },
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: isEnabled ? onPressed : null,
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isEnabled
                ? const Color(MyColors.textColor)
                : const Color(MyColors.secondaryGrey),
            size: 15,
          ),
        ),
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: Color(MyColors.surface),
        border: Border(
          top: BorderSide(color: Color(MyColors.borderSubtle), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal ($totalItems items)',
                  style: const TextStyle(
                    color: Color(MyColors.textSecondary),
                    fontSize: 13,
                  ),
                ),
                Text(
                  '\$${originalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(MyColors.textColor),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Discount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Store Discount',
                      style: TextStyle(
                        color: Color(MyColors.textSecondary),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(MyColors.success)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '10% OFF',
                        style: TextStyle(
                          color: Color(MyColors.success),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '-\$${savings.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(MyColors.success),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Color(MyColors.borderSubtle)),
            const SizedBox(height: 10),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    color: Color(MyColors.textColor),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  '\$${discountedPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(MyColors.primaryRed),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Checkout button
            ElevatedButton(
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
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
