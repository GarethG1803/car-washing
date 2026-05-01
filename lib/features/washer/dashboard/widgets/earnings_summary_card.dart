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

  const EarningsSummaryCard({
    super.key,
    required this.todayEarnings,
    required this.weekEarnings,
    required this.monthEarnings,
    // trendPercentage is removed entirely
  });

  String _weekRange() {
    final now = DateTime.now();
    // Find Monday of this week (Monday = 1)
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday
    final monday = now.subtract(Duration(days: weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    final fmt = DateFormat('MMM d');
    return '${fmt.format(monday)} - ${fmt.format(sunday)}';
  }

  String _monthLabel() {
    return DateFormat('MMMM yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,###');

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
            'Rp ${currencyFormat.format(todayEarnings.toInt())}',
            style: AppTypography.headlineLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(AppSpacing.lg),
          // Period details with explicit labels
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This Week',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      _weekRange(),
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white60,
                        fontSize: 10,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      'Rp ${currencyFormat.format(weekEarnings.toInt())}',
                      style: AppTypography.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Vertical divider (optional) – you can add if you like
              // const SizedBox(
              //   height: 40,
              //   child: VerticalDivider(color: Colors.white24),
              // ),
              const Gap(AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This Month',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      _monthLabel(),
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white60,
                        fontSize: 10,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      'Rp ${currencyFormat.format(monthEarnings.toInt())}',
                      style: AppTypography.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Trend line removed entirely
        ],
      ),
    );
  }
}