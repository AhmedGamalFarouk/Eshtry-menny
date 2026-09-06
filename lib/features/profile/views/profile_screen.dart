import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        backgroundColor: const Color(MyColors.cardSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(MyColors.borderSubtle)),
        ),
        title: const Text(
          'Sign Out',
          style: TextStyle(
            color: Color(MyColors.textColor),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Are you sure you want to sign out of your account?',
          style: TextStyle(
            color: Color(MyColors.textSecondary),
            fontSize: 14,
          ),
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
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            onPressed: () async {
              HapticFeedback.mediumImpact();
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
                strokeWidth: 2.5,
              ),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 56,
                      color: Color(MyColors.primaryRed),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(MyColors.textSecondary),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(MyColors.primaryRed),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () =>
                          context.read<ProfileCubit>().loadProfile(),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Retry'),
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
              backgroundColor: const Color(MyColors.cardSurface),
              onRefresh: () => context.read<ProfileCubit>().refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Member Header Card
                    _buildUserHeader(context, profile),
                    const SizedBox(height: 24),

                    // Shipping Address Card
                    _buildSectionHeader('SHIPPING ADDRESS', Icons.location_on_outlined),
                    const SizedBox(height: 10),
                    _buildAddressCard(context, profile.address),
                    const SizedBox(height: 24),

                    // Order History Section
                    _buildSectionHeader(
                      'ORDER HISTORY',
                      Icons.history_rounded,
                      badge: '${orders.length}',
                    ),
                    const SizedBox(height: 10),
                    _buildOrdersSection(context, orders),
                    const SizedBox(height: 24),

                    // Account Settings & Actions
                    _buildSectionHeader('ACCOUNT & PREFERENCES', Icons.tune_rounded),
                    const SizedBox(height: 10),
                    _buildAccountActions(context),
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

  Widget _buildSectionHeader(String title, IconData icon, {String? badge}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(MyColors.primaryRed).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: Color(MyColors.primaryRed),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserHeader(BuildContext context, UserProfileModel profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(MyColors.cardSurface),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(MyColors.borderSubtle),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Squircle avatar
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(MyColors.primaryRed),
                  Color(MyColors.primaryRedLight),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(MyColors.primaryRed).withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                profile.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.fullName.isNotEmpty ? profile.fullName : profile.username,
                        style: const TextStyle(
                          color: Color(MyColors.textColor),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified_rounded,
                      color: Color(0xFF10B981),
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '@${profile.username}',
                  style: const TextStyle(
                    color: Color(MyColors.primaryRed),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 13,
                      color: Color(MyColors.textTertiary),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        profile.email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(MyColors.textSecondary),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(MyColors.cardSurface),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(MyColors.borderSubtle),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(MyColors.primaryRed).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.home_outlined,
              color: Color(MyColors.primaryRed),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Primary Shipping Location',
                  style: TextStyle(
                    color: Color(MyColors.textColor),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address.formattedAddress.isNotEmpty
                      ? address.formattedAddress
                      : 'No delivery address specified.',
                  style: const TextStyle(
                    color: Color(MyColors.textSecondary),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersSection(BuildContext context, List<UserOrderModel> orders) {
    if (orders.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(MyColors.cardSurface),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(MyColors.borderSubtle),
          ),
        ),
        child: const Center(
          child: Text(
            'No past orders yet.',
            style: TextStyle(
              color: Color(MyColors.textSecondary),
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(MyColors.cardSurface),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(MyColors.borderSubtle),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #ESH-${order.id.toString().padLeft(4, '0')}',
                      style: const TextStyle(
                        color: Color(MyColors.textColor),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${order.formattedDate} • ${order.totalItemCount} item${order.totalItemCount > 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: Color(MyColors.textSecondary),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Delivered',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(MyColors.cardSurface),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(MyColors.borderSubtle),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.shield_outlined,
            title: 'Privacy Policy & Terms',
            onTap: () {},
          ),
          const Divider(
            height: 1,
            color: Color(MyColors.borderSubtle),
          ),
          _buildActionTile(
            icon: Icons.support_agent_rounded,
            title: 'Customer Support',
            onTap: () {},
          ),
          const Divider(
            height: 1,
            color: Color(MyColors.borderSubtle),
          ),
          _buildActionTile(
            icon: Icons.logout_rounded,
            title: 'Sign Out',
            isDestructive: true,
            onTap: () => _showSignOutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? const Color(MyColors.primaryRed)
        : const Color(MyColors.textColor);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isDestructive
                    ? const Color(MyColors.primaryRed)
                    : const Color(MyColors.textSecondary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: isDestructive
                    ? const Color(MyColors.primaryRed).withValues(alpha: 0.6)
                    : const Color(MyColors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

