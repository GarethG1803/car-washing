import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Refer a Friend'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Gap(8),
          // Illustration area
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const Gap(16),
                Text(
                  'Refer & Earn',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Earn 50 points for every friend who signs up and completes their first wash!',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(24),
          // Referral code
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
                Text('Your Referral Code', style: AppTypography.titleMedium),
                const Gap(12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    color: AppColors.primaryLight,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'ALEX2026',
                            style: AppTypography.headlineMedium.copyWith(
                              color: AppColors.primary,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(const ClipboardData(text: 'ALEX2026'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Referral code copied!'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: const Icon(
                            Icons.copy,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(24),
          // Share buttons
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
                Text('Share via', style: AppTypography.titleMedium),
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _shareButton(Icons.chat, 'WhatsApp', const Color(0xFF25D366)),
                    _shareButton(Icons.sms, 'SMS', AppColors.primary),
                    _shareButton(Icons.email_outlined, 'Email', const Color(0xFFEA4335)),
                    _shareButton(Icons.more_horiz, 'More', AppColors.textSecondary),
                  ],
                ),
              ],
            ),
          ),
          const Gap(24),
          // Your Referrals
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
                Text('Your Referrals', style: AppTypography.titleMedium),
                const Gap(16),
                _referralItem('Emily Chen', 'Completed', '+50 pts', AppColors.success),
                const Divider(color: AppColors.divider, height: 24),
                _referralItem('Jordan Williams', 'Pending', 'Awaiting first wash', AppColors.warning),
                const Divider(color: AppColors.divider, height: 24),
                _referralItem('Sam Taylor', 'Completed', '+50 pts', AppColors.success),
              ],
            ),
          ),
          const Gap(24),
        ],
      ),
    );
  }

  Widget _shareButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const Gap(8),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _referralItem(String name, String status, String reward, Color statusColor) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primaryLight,
          child: Text(
            name.split(' ').map((n) => n[0]).join(),
            style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
          ),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTypography.titleMedium),
              const Gap(2),
              Text(
                reward,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: AppTypography.labelSmall.copyWith(color: statusColor),
          ),
        ),
      ],
    );
  }
}
