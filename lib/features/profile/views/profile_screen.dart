import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/mycolors.dart';
import '../../../core/navigation_cubit.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../data/models/user_order_model.dart';
import '../data/models/user_profile_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(MyColors.textfieldBakground),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Sign Out',
          style: TextStyle(color: Color(MyColors.textColor)),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Color(MyColors.textSecondary)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(MyColors.textSecondary)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(MyColors.primaryRed),
              minimumSize: const Size(80, 36),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<AuthCubit>().signOut();
              if (context.mounted) {
                context.read<NavigationCubit>().showSignIn();
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.background),
      appBar: const CustomAppBar(title: 'My Profile'),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(MyColors.primaryRed),
              ),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Color(MyColors.error),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(MyColors.textSecondary),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(MyColors.primaryRed),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          context.read<ProfileCubit>().loadProfile(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            final orders = state.orders;

            return RefreshIndicator(
              color: const Color(MyColors.primaryRed),
              backgroundColor: const Color(MyColors.textfieldBakground),
              onRefresh: () => context.read<ProfileCubit>().refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Header Card
                    _buildUserHeader(context, profile),
                    SizedBox(height: 2.5.h),

                    // Shipping Address Card
                    _buildAddressCard(context, profile.address),
                    SizedBox(height: 2.5.h),

                    // Order History Section
                    _buildOrdersSection(context, orders),
                    SizedBox(height: 2.5.h),

                    // Account Actions & Sign Out
                    _buildAccountActions(context),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, UserProfileModel profile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(MyColors.textfieldBakground),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(MyColors.primaryRed),
            child: Text(
              profile.initials,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName.isNotEmpty ? profile.fullName : profile.username,
                  style: TextStyle(
                    color: const Color(MyColors.textColor),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(MyColors.primaryRed).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '@${profile.username}',
                    style: const TextStyle(
                      color: Color(MyColors.primaryRed),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 0.8.h),
                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 14,
                      color: Color(MyColors.textSecondary),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        profile.email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(MyColors.textSecondary),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                if (profile.phone.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 14,
                        color: Color(MyColors.textSecondary),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        profile.phone,
                        style: const TextStyle(
                          color: Color(MyColors.textSecondary),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, UserAddress address) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(MyColors.textfieldBakground),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(MyColors.primaryRed).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Color(MyColors.primaryRed),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Default Shipping Address',
                style: TextStyle(
                  color: const Color(MyColors.textColor),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text(
            address.formattedAddress.isNotEmpty
                ? address.formattedAddress
                : 'No delivery address specified.',
            style: TextStyle(
              color: const Color(MyColors.textSecondary),
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersSection(BuildContext context, List<UserOrderModel> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Past Orders',
              style: TextStyle(
                color: const Color(MyColors.textColor),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(MyColors.primaryRed).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${orders.length} Orders',
                style: const TextStyle(
                  color: Color(MyColors.primaryRed),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        if (orders.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: const Color(MyColors.textfieldBakground),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'No past orders yet.',
                style: TextStyle(color: Color(MyColors.textSecondary)),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (_, __) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                padding: EdgeInsets.all(3.5.w),
                decoration: BoxDecoration(
                  color: const Color(MyColors.textfieldBakground),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.green,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #ORD-${order.id}',
                            style: const TextStyle(
                              color: Color(MyColors.textColor),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${order.formattedDate} • ${order.totalItemCount} Items',
                            style: const TextStyle(
                              color: Color(MyColors.textSecondary),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(MyColors.textfieldBakground),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.privacy_tip_outlined,
              color: Color(MyColors.textSecondary),
            ),
            title: const Text(
              'Privacy & Terms',
              style: TextStyle(color: Color(MyColors.textColor)),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Color(MyColors.textSecondary),
            ),
            onTap: () {},
          ),
          const Divider(
            height: 1,
            color: Color(MyColors.background),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: Color(MyColors.primaryRed),
            ),
            title: const Text(
              'Sign Out',
              style: TextStyle(
                color: Color(MyColors.primaryRed),
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Color(MyColors.primaryRed),
            ),
            onTap: () => _showSignOutDialog(context),
          ),
        ],
      ),
    );
  }
}
