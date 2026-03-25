import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  int _selectedPeriodIndex = 2; // "This Month" selected by default

  final List<String> _periods = ['Today', 'This Week', 'This Month', 'Custom'];

  final List<String> _earningsForPeriod = [
    'Rp 2.780.000',
    'Rp 11.130.000',
    'Rp 42.600.000',
    'Rp 42.600.000',
  ];

  // Mock daily earnings for the week bar chart
  final List<_DailyEarning> _weeklyEarnings = [
    _DailyEarning('Mon', 1425000),
    _DailyEarning('Tue', 1800000),
    _DailyEarning('Wed', 1200000),
    _DailyEarning('Thu', 2175000),
    _DailyEarning('Fri', 2400000),
    _DailyEarning('Sat', 2780000),
    _DailyEarning('Sun', 0),
  ];

  // Mock payout history
  final List<_PayoutItem> _payoutHistory = [
    _PayoutItem(
      date: 'Feb 14, 2026',
      amount: 11130000,
      status: 'paid',
      bankLast4: '4821',
    ),
    _PayoutItem(
      date: 'Feb 7, 2026',
      amount: 10283000,
      status: 'paid',
      bankLast4: '4821',
    ),
    _PayoutItem(
      date: 'Jan 31, 2026',
      amount: 13680000,
      status: 'paid',
      bankLast4: '4821',
    ),
    _PayoutItem(
      date: 'Jan 24, 2026',
      amount: 8674000,
      status: 'paid',
      bankLast4: '4821',
    ),
    _PayoutItem(
      date: 'Jan 17, 2026',
      amount: 9510000,
      status: 'paid',
      bankLast4: '4821',
    ),
    _PayoutItem(
      date: 'Feb 21, 2026',
      amount: 11783000,
      status: 'pending',
      bankLast4: '4821',
    ),
  ];

  double get _maxEarning {
    final max = _weeklyEarnings
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b);
    return max > 0 ? max : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Earnings',
          style: AppTypography.titleLarge,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period selector chips
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _periods.length,
                  separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedPeriodIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPeriodIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.divider,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _periods[index],
                            style: AppTypography.labelSmall.copyWith(
                              color:
                                  isSelected ? Colors.white : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Gap(AppSpacing.xxl),

              // Large earnings amount
              Center(
                child: Column(
                  children: [
                    Text(
                      _earningsForPeriod[_selectedPeriodIndex],
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      'Total ${_periods[_selectedPeriodIndex]}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(AppSpacing.xxl),

              // Bar chart placeholder
              Text(
                'Weekly Breakdown',
                style: AppTypography.titleMedium,
              ),
              const Gap(AppSpacing.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _weeklyEarnings.map((earning) {
                      final barHeight =
                          (earning.amount / _maxEarning) * 140;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (earning.amount > 0)
                                Text(
                                  'Rp ${NumberFormat('#,###').format(earning.amount.toInt())}',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 9,
                                  ),
                                ),
                              const Gap(4),
                              Container(
                                height: barHeight.clamp(4.0, 140.0),
                                decoration: BoxDecoration(
                                  color: earning.amount > 0
                                      ? AppColors.primary
                                      : AppColors.divider,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const Gap(AppSpacing.sm),
                              Text(
                                earning.day,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Gap(AppSpacing.xxl),

              // Payout History
              Text(
                'Payout History',
                style: AppTypography.titleMedium,
              ),
              const Gap(AppSpacing.lg),
              ...List.generate(_payoutHistory.length, (index) {
                final payout = _payoutHistory[index];
                final isPending = payout.status == 'pending';
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isPending
                              ? AppColors.warning.withOpacity(0.1)
                              : AppColors.success.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPending
                              ? Icons.schedule
                              : Icons.check_circle_outline,
                          color: isPending
                              ? AppColors.warning
                              : AppColors.success,
                          size: 20,
                        ),
                      ),
                      const Gap(AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              payout.date,
                              style: AppTypography.bodyMedium,
                            ),
                            const Gap(2),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isPending
                                        ? AppColors.warning.withOpacity(0.1)
                                        : AppColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    isPending ? 'Pending' : 'Paid',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: isPending
                                          ? AppColors.warning
                                          : AppColors.success,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const Gap(AppSpacing.sm),
                                Text(
                                  'Bank ****${payout.bankLast4}',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Rp ${NumberFormat('#,###').format(payout.amount.toInt())}',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Gap(AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyEarning {
  final String day;
  final double amount;

  const _DailyEarning(this.day, this.amount);
}

class _PayoutItem {
  final String date;
  final double amount;
  final String status;
  final String bankLast4;

  const _PayoutItem({
    required this.date,
    required this.amount,
    required this.status,
    required this.bankLast4,
  });
}
