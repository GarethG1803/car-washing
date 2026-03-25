import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class EarningsSummaryCard extends StatelessWidget {
  final double todayEarnings;
  final double weekEarnings;
  final double monthEarnings;
  final int trendPercentage;

  const EarningsSummaryCard({
    super.key,
    required this.todayEarnings,
    required this.weekEarnings,
    required this.monthEarnings,
    required this.trendPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF0047B3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Earnings",
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white70,
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Rp ${NumberFormat('#,###').format(todayEarnings.toInt())}',
            style: AppTypography.headlineLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  'This Week: Rp ${NumberFormat('#,###').format(weekEarnings.toInt())}',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'This Month: Rp ${NumberFormat('#,###').format(monthEarnings.toInt())}',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white60,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.md),
          Row(
            children: [
              const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 14,
              ),
              const Gap(4),
              Text(
                '$trendPercentage% vs last week',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
