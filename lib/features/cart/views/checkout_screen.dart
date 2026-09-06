import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../cubit/cart_cubit.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'card';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.background),
      appBar: const CustomAppBar(
        title: 'Checkout',
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            final double totalAmount = state.items.fold(
              0.0,
              (sum, item) => sum + ((item.price) as num),
            );

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order Summary Section
                          _buildSectionLabel('ORDER SUMMARY', Icons.receipt_long_rounded),
                          const SizedBox(height: 10),
                          _buildOrderSummaryCard(state.items, totalAmount),

                          const SizedBox(height: 24),

                          // Shipping Information Section
                          _buildSectionLabel('SHIPPING DETAILS', Icons.local_shipping_outlined),
                          const SizedBox(height: 10),
                          _buildShippingCard(),

                          const SizedBox(height: 24),

                          // Payment Method Section
                          _buildSectionLabel('PAYMENT METHOD', Icons.payment_rounded),
                          const SizedBox(height: 10),
                          _buildPaymentMethodSection(),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Action Bar
                  _buildBottomBar(totalAmount),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Color(MyColors.primaryRed),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(MyColors.primaryRed),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(MyColors.textSecondary),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummaryCard(List items, double total) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(MyColors.cardSurface),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(MyColors.borderSubtle),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ...items.take(3).map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(MyColors.textColor),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '\$${item.price}',
                      style: const TextStyle(
                        color: Color(MyColors.textColor),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
          if (items.length > 3) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    '+ ${items.length - 3} more item(s)',
                    style: const TextStyle(
                      color: Color(MyColors.textTertiary),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Divider(
            color: Color(MyColors.borderSubtle),
            height: 20,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  color: Color(MyColors.textSecondary),
                  fontSize: 13,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(MyColors.textColor),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping',
                style: TextStyle(
                  color: Color(MyColors.textSecondary),
                  fontSize: 13,
                ),
              ),
              Text(
                'FREE',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  color: Color(MyColors.textColor),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(MyColors.primaryRed),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShippingCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(MyColors.cardSurface),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(MyColors.borderSubtle),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildField(
            label: 'Full Name',
            initialValue: 'John Doe',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),
          _buildField(
            label: 'Delivery Address',
            initialValue: '742 Evergreen Terrace',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  label: 'City',
                  initialValue: 'Springfield',
                  icon: Icons.location_city_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildField(
                  label: 'Postal Code',
                  initialValue: '97477',
                  icon: Icons.markunread_mailbox_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String initialValue,
    required IconData icon,
  }) {
    return TextFormField(
      initialValue: initialValue,
      style: const TextStyle(
        color: Color(MyColors.textColor),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(MyColors.textSecondary),
          fontSize: 12,
        ),
        prefixIcon: Icon(
          icon,
          size: 18,
          color: const Color(MyColors.textSecondary),
        ),
        filled: true,
        fillColor: const Color(MyColors.textfieldBakground),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(MyColors.borderSubtle)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(MyColors.borderSubtle)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(MyColors.primaryRed), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Row(
      children: [
        Expanded(
          child: _buildPaymentOption(
            id: 'card',
            label: 'Credit Card',
            icon: Icons.credit_card_rounded,
            subtitle: '**** 4242',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildPaymentOption(
            id: 'paypal',
            label: 'PayPal',
            icon: Icons.account_balance_wallet_outlined,
            subtitle: 'john@example.com',
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String label,
    required IconData icon,
    required String subtitle,
  }) {
    final isSelected = _selectedPaymentMethod == id;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedPaymentMethod = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(MyColors.primaryRed).withValues(alpha: 0.1)
              : const Color(MyColors.cardSurface),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(MyColors.primaryRed)
                : const Color(MyColors.borderSubtle),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? const Color(MyColors.primaryRed)
                      : const Color(MyColors.textSecondary),
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(MyColors.primaryRed)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(MyColors.primaryRed)
                          : const Color(MyColors.textTertiary),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(
                            Icons.check,
                            size: 10,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(MyColors.textColor)
                    : const Color(MyColors.textSecondary),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(MyColors.textTertiary),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(double totalAmount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: const Color(MyColors.cardSurface),
        border: const Border(
          top: BorderSide(
            color: Color(MyColors.borderSubtle),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Due',
                  style: TextStyle(
                    color: Color(MyColors.textTertiary),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(MyColors.textColor),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  context.read<CartCubit>().clearCart();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderSuccessScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(MyColors.primaryRed),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
