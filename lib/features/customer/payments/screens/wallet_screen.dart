import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {'title': 'Top Up', 'amount': '+Rp 500.000', 'date': 'Feb 10, 2026', 'isCredit': true},
      {'title': 'Standard Wash Payment', 'amount': '-Rp 150.000', 'date': 'Feb 8, 2026', 'isCredit': false},
      {'title': 'Referral Bonus', 'amount': '+Rp 25.000', 'date': 'Feb 5, 2026', 'isCredit': true},
      {'title': 'Quick Wash Payment', 'amount': '-Rp 75.000', 'date': 'Feb 2, 2026', 'isCredit': false},
      {'title': 'Refund - Cancelled', 'amount': '+Rp 75.000', 'date': 'Jan 28, 2026', 'isCredit': true},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Wallet'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF0047B3)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Available Balance', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
                const Gap(8),
                Text('Rp 375.000', style: AppTypography.headlineLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                const Gap(20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd))),
                    child: const Text('Top Up'),
                  ),
                ),
              ],
            ),
          ),
          const Gap(24),
          Text('Transaction History', style: AppTypography.titleMedium),
          const Gap(12),
          ...transactions.map((t) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: (t['isCredit'] as bool) ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon((t['isCredit'] as bool) ? Icons.arrow_downward : Icons.arrow_upward, color: (t['isCredit'] as bool) ? AppColors.success : AppColors.error, size: 20),
                ),
                const Gap(12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t['title'] as String, style: AppTypography.bodyLarge),
                  Text(t['date'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                ])),
                Text(t['amount'] as String, style: AppTypography.titleMedium.copyWith(color: (t['isCredit'] as bool) ? AppColors.success : AppColors.textPrimary)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
