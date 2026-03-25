import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, Color(0xFF0047B3)])),
                child: SafeArea(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Gap(20),
                    const CircleAvatar(radius: 40, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&fit=crop')),
                    const Gap(12),
                    Text('Alex Johnson', style: AppTypography.titleLarge.copyWith(color: Colors.white)),
                    Text('alex@email.com', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
                  ]),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(children: [
                _menuSection('Account', [
                  _menuItem(Icons.person_outline, 'Edit Profile', () => context.push('/customer/profile/edit')),
                  _menuItem(Icons.directions_car, 'My Vehicles', () => context.push('/customer/profile/vehicles')),
                  _menuItem(Icons.payment, 'Payment Methods', () => context.push('/customer/payments')),
                  _menuItem(Icons.location_on_outlined, 'Saved Addresses', () {}),
                ]),
                const Gap(16),
                _menuSection('Rewards', [
                  _menuItem(Icons.stars, 'Loyalty Program', () => context.push('/customer/loyalty')),
                  _menuItem(Icons.card_giftcard, 'Refer a Friend', () => context.push('/customer/loyalty/referral')),
                  _menuItem(Icons.local_offer_outlined, 'Promotions', () {}),
                ]),
                const Gap(16),
                _menuSection('Support', [
                  _menuItem(Icons.help_outline, 'Help Center', () {}),
                  _menuItem(Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
                  _menuItem(Icons.description_outlined, 'Terms of Service', () {}),
                ]),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd))),
                    child: const Text('Sign Out'),
                  ),
                ),
                const Gap(12),
                TextButton(onPressed: () => context.go('/role-select'), child: Text('Switch Role', style: AppTypography.labelLarge.copyWith(color: AppColors.primary))),
                const Gap(32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuSection(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), child: Text(title, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary))),
        ...items,
      ]),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary, size: 22),
      title: Text(label, style: AppTypography.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
      onTap: onTap,
    );
  }
}
