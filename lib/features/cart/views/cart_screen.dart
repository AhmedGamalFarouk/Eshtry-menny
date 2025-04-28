import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../cubit/cart_cubit.dart';
import 'checkout_screen.dart';
import 'empty_cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.background),
      bottomNavigationBar: const BottomNavBar(),
      appBar: CustomAppBar(
        title: 'Shopping Cart',
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            context.read<CartCubit>().loadCart();
            return const Center(child: EmptyCart());
          }
          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return const EmptyCart();
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(2.5.h),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Card(
                        color: Colors.white,
                        margin: EdgeInsets.only(bottom: 2.h),
                        child: Padding(
                          padding: EdgeInsets.all(1.5.h),
                          child: Row(
                            children: [
                              Image.network(
                                item.image,
                                width: 25.w,
                                height: 25.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Color(
                                                  MyColors.textfieldBakground),
                                              fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 1.h),
                                    Row(
                                      spacing: 3.w,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Color(MyColors.primaryRed),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.remove_rounded,
                                              color: Colors.white,
                                              size: 16.sp,
                                            ),
                                            padding: EdgeInsets.all(1.w),
                                            constraints: BoxConstraints(
                                              minWidth: 8.w,
                                              minHeight: 8.w,
                                            ),
                                            onPressed: () => context
                                                .read<CartCubit>()
                                                .updateQuantity(
                                                    item.id, item.quantity - 1),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.w),
                                          child: Text(
                                            '${item.quantity}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    color: Color(
                                                        MyColors.primaryRed),
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Color(MyColors.primaryRed),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.add_rounded,
                                              color: Colors.white,
                                              size: 16.sp,
                                            ),
                                            padding: EdgeInsets.all(1.w),
                                            constraints: BoxConstraints(
                                              minWidth: 8.w,
                                              minHeight: 8.w,
                                            ),
                                            onPressed: () => context
                                                .read<CartCubit>()
                                                .updateQuantity(
                                                    item.id, item.quantity + 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '\$ ${(item.price * item.quantity).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Color(MyColors.primaryRed),
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Color(MyColors.background)),
                          ),
                          Text(
                            '\$${state.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Color(MyColors.primaryRed),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(MyColors.primaryRed),
                          minimumSize: Size(40.w, 6.h),
                        ),
                        child: Text(
                          'Checkout',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
