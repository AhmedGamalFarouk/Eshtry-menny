import 'package:flutter/material.dart';
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

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPaymentMethod = 'card';
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
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary Section
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Color(MyColors.primaryRed),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Order Summary',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Color(MyColors.textColor),
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(MyColors.textfieldBakground),
                      borderRadius: BorderRadius.circular(12),
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
                                              color: Color(MyColors.textColor)),
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                  Text(
                                    '\$ ${item.price}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                            color: Color(MyColors.textColor)),
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
                                  ?.copyWith(color: Color(MyColors.textColor)),
                            ),
                            Text(
                              '\$ ${state.items.fold(0.0, (sum, item) => sum + ((item.price) as num)).toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: Color(MyColors.primaryRedLight)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Shipping Information Section
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Color(MyColors.primaryRed),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Shipping Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Color(MyColors.textColor),
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(MyColors.textfieldBakground),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle:
                                TextStyle(color: Color(MyColors.textSecondary)),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(MyColors.secondaryGrey)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(MyColors.primaryRed)),
                            ),
                          ),
                          style: TextStyle(color: Color(MyColors.textColor)),
                        ),
                        SizedBox(height: 2.h),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Address',
                            labelStyle:
                                TextStyle(color: Color(MyColors.textSecondary)),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(MyColors.secondaryGrey)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(MyColors.primaryRed)),
                            ),
                          ),
                          style: TextStyle(color: Color(MyColors.textColor)),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'City',
                                  labelStyle: TextStyle(
                                      color: Color(MyColors.textSecondary)),
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(MyColors.secondaryGrey)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(MyColors.primaryRed)),
                                  ),
                                ),
                                style:
                                    TextStyle(color: Color(MyColors.textColor)),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Postal Code',
                                  labelStyle: TextStyle(
                                      color: Color(MyColors.textSecondary)),
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(MyColors.secondaryGrey)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(MyColors.primaryRed)),
                                  ),
                                ),
                                style:
                                    TextStyle(color: Color(MyColors.textColor)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Payment Method Section
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Color(MyColors.primaryRed),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Payment Method',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Color(MyColors.textColor),
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(MyColors.textfieldBakground),
                      borderRadius: BorderRadius.circular(12),
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
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Color(MyColors.primaryRed);
                                }
                                return Color(MyColors.textSecondary);
                              },
                            ),
                          ),
                          title: Text('Credit/Debit Card',
                              style:
                                  TextStyle(color: Color(MyColors.textColor))),
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
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Color(MyColors.primaryRed);
                                }
                                return Color(MyColors.textSecondary);
                              },
                            ),
                          ),
                          title: Text('PayPal',
                              style:
                                  TextStyle(color: Color(MyColors.textColor))),
                          trailing: Icon(Icons.paypal,
                              color: Color(MyColors.textSecondary)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Place Order Button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to success screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderSuccessScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(MyColors.primaryRed),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Place Order',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
