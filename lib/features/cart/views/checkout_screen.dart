import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../cubit/cart_cubit.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with TickerProviderStateMixin {
  String selectedPaymentMethod = 'card';
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.background),
      appBar: CustomAppBar(
        title: 'Checkout',
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Summary Section
                      _buildSectionHeader(
                        context,
                        'Order Summary',
                        Icons.receipt_long_rounded,
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(MyColors.textfieldBakground),
                              Color(MyColors.textfieldBakground)
                                  .withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ...state.items.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                  color: Color(
                                                      MyColors.textColor)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '\$ ${item.price}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                color:
                                                    Color(MyColors.textColor)),
                                      ),
                                    ],
                                  ),
                                )),
                            Divider(color: Color(MyColors.secondaryGrey)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: Color(MyColors.textColor)),
                                ),
                                Text(
                                  '\$ ${state.items.fold(0.0, (sum, item) => sum + ((item.price) as num)).toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          color:
                                              Color(MyColors.primaryRedLight)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Shipping Information Section
                      _buildSectionHeader(
                        context,
                        'Shipping Information',
                        Icons.local_shipping_rounded,
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(MyColors.textfieldBakground),
                              Color(MyColors.textfieldBakground)
                                  .withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildModernTextField(
                              labelText: 'Full Name',
                              prefixIcon: Icons.person_rounded,
                            ),
                            SizedBox(height: 2.h),
                            _buildModernTextField(
                              labelText: 'Address',
                              prefixIcon: Icons.location_on_rounded,
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildModernTextField(
                                    labelText: 'City',
                                    prefixIcon: Icons.location_city_rounded,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: _buildModernTextField(
                                    labelText: 'Postal Code',
                                    prefixIcon:
                                        Icons.markunread_mailbox_rounded,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Payment Method Section
                      _buildSectionHeader(
                        context,
                        'Payment Method',
                        Icons.payment_rounded,
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(MyColors.textfieldBakground),
                              Color(MyColors.textfieldBakground)
                                  .withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Radio(
                                value: 'card',
                                groupValue: selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentMethod = value.toString();
                                  });
                                },
                                activeColor: Color(MyColors.primaryRed),
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Color(MyColors.primaryRed);
                                    }
                                    return Color(MyColors.textSecondary);
                                  },
                                ),
                              ),
                              title: Text('Credit/Debit Card',
                                  style: TextStyle(
                                      color: Color(MyColors.textColor))),
                              trailing: Icon(Icons.credit_card,
                                  color: Color(MyColors.textSecondary)),
                            ),
                            Divider(color: Color(MyColors.secondaryGrey)),
                            ListTile(
                              leading: Radio(
                                value: 'paypal',
                                groupValue: selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentMethod = value.toString();
                                  });
                                },
                                activeColor: Color(MyColors.primaryRed),
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Color(MyColors.primaryRed);
                                    }
                                    return Color(MyColors.textSecondary);
                                  },
                                ),
                              ),
                              title: Text('PayPal',
                                  style: TextStyle(
                                      color: Color(MyColors.textColor))),
                              trailing: Icon(Icons.paypal,
                                  color: Color(MyColors.textSecondary)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Place Order Button
                      Container(
                        width: double.infinity,
                        height: 7.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(MyColors.primaryRed),
                              Color(MyColors.primaryRedLight),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Color(MyColors.primaryRed).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const OrderSuccessScreen(),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
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
                                    'Place Order',
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
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(MyColors.primaryRed).withOpacity(0.1),
            Color(MyColors.primaryRedLight).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(MyColors.primaryRed).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(MyColors.primaryRed),
                  Color(MyColors.primaryRedLight),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(MyColors.primaryRed).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            title,
            style: TextStyle(
              color: Color(MyColors.textColor),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required String labelText,
    required IconData prefixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        style: TextStyle(
          color: Color(MyColors.textColor),
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Color(MyColors.textSecondary),
            fontSize: 12.sp,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(2.w),
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(MyColors.primaryRed).withOpacity(0.1),
                  Color(MyColors.primaryRedLight).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              prefixIcon,
              color: Color(MyColors.primaryRed),
              size: 18,
            ),
          ),
          filled: true,
          fillColor: Color(MyColors.textfieldBakground),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Color(MyColors.secondaryGrey).withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Color(MyColors.primaryRed),
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
        ),
      ),
    );
  }
}
