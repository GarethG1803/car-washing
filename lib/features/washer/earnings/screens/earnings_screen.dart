import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/washer_earnings_provider.dart';
import 'package:clean_ride/features/washer/dashboard/widgets/earnings_summary_card.dart';
import 'package:gap/gap.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    // today's summary
    final summaryAsync = ref.watch(washerEarningsProvider(null));
    // selected day detail
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final dayAsync = ref.watch(washerEarningsProvider(dateStr));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Earnings', style: AppTypography.titleLarge),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Summary card (always today's overview) ---
            summaryAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Could not load summary'),
              data: (data) {
                final today = (data['today_earnings'] as num?)?.toDouble() ?? 0.0;
                final week = (data['week_earnings'] as num?)?.toDouble() ?? 0.0;
                final month = (data['month_earnings'] as num?)?.toDouble() ?? 0.0;
                return EarningsSummaryCard(
                  todayEarnings: today,
                  weekEarnings: week,
                  monthEarnings: month,
                );
              },
            ),
            const Gap(AppSpacing.xl),

            // --- Date picker bar ---
            Text('Select Day', style: AppTypography.titleMedium),
            const Gap(AppSpacing.sm),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.primary),
                    const Gap(AppSpacing.md),
                    Text(
                      DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.primary),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                  ],
                ),
              ),
            ),
            const Gap(AppSpacing.xl),

            // --- Selected day earnings ---
            Text(
              'Earnings for ${DateFormat('MMM d').format(_selectedDate)}',
              style: AppTypography.titleMedium,
            ),
            const Gap(AppSpacing.md),
            dayAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Could not load day earnings'),
              data: (dayData) {
                final dayEarnings =
                    (dayData['earnings'] as num?)?.toDouble() ?? 0.0;
                final dayCount =
                    (dayData['completed_count'] as num?)?.toInt() ?? 0;

                return Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        icon: Icons.check_circle_outline,
                        label: 'Completed',
                        value: '$dayCount',
                        color: AppColors.success,
                      ),
                    ),
                    const Gap(AppSpacing.md),
                    Expanded(
                      child: _statCard(
                        icon: Icons.attach_money,
                        label: 'Earnings',
                        value: 'Rp ${NumberFormat('#,###').format(dayEarnings.toInt())}',
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                );
              },
            ),
            const Gap(AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
        children: [
          Icon(icon, color: color, size: 24),
          const Gap(AppSpacing.sm),
          Text(value,
              style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold)),
          const Gap(2),
          Text(label,
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}