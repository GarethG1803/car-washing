import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Loyalty Program'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Points balance card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF0047B3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              children: [
                const Icon(Icons.stars_rounded, color: Colors.white70, size: 40),
                const Gap(12),
                Text(
                  '320 Points',
                  style: AppTypography.headlineLarge.copyWith(color: Colors.white),
                ),
                const Gap(8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Silver Member',
                    style: AppTypography.labelLarge.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          // Progress to next tier
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Progress to Gold', style: AppTypography.titleMedium),
                    Text(
                      '320 / 500',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const Gap(12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: 0.64,
                    minHeight: 10,
                    backgroundColor: AppColors.primaryLight,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const Gap(8),
                Text(
                  '180 more points to reach Gold tier',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          // How to earn section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to Earn', style: AppTypography.titleMedium),
                const Gap(12),
                _earnTile(Icons.local_car_wash, 'Book a wash', '+10 pts', AppColors.primary),
                const Divider(color: AppColors.divider, height: 1),
                _earnTile(Icons.rate_review_outlined, 'Leave a review', '+5 pts', AppColors.warning),
                const Divider(color: AppColors.divider, height: 1),
                _earnTile(Icons.person_add_outlined, 'Refer a friend', '+50 pts', AppColors.success),
              ],
            ),
          ),
          const Gap(20),
          // Rewards section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rewards', style: AppTypography.titleMedium),
                const Gap(12),
                _rewardTile(
                  'Free Quick Wash',
                  '200 pts',
                  true,
                ),
                const Gap(12),
                _rewardTile(
                  'Rp 150.000 Off Any Service',
                  '100 pts',
                  true,
                ),
                const Gap(12),
                _rewardTile(
                  'Free Premium Detail',
                  '500 pts',
                  false,
                ),
                const Gap(12),
                _rewardTile(
                  'Free Interior Clean',
                  '350 pts',
                  false,
                ),
              ],
            ),
          ),
          const Gap(24),
        ],
      ),
    );
  }

  Widget _earnTile(IconData icon, String title, String points, Color iconColor) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: AppTypography.bodyLarge),
      trailing: Text(
        points,
        style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _rewardTile(String title, String cost, bool redeemable) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: redeemable ? AppColors.primaryLight : AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: redeemable ? AppColors.primary.withOpacity(0.3) : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.card_giftcard,
            color: redeemable ? AppColors.primary : AppColors.textSecondary,
            size: 24,
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                const Gap(2),
                Text(
                  cost,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (redeemable)
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
              child: const Text('Redeem'),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                'Locked',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
