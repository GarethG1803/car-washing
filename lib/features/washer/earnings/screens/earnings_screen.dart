import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:clean_ride/data/providers/washer_jobs_provider.dart';
import 'package:gap/gap.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  int _selectedPeriodIndex = 2;
  final List<String> _periods = ['Today', 'This Week', 'This Month', 'All Time'];

  List<Booking> _filterByPeriod(List<Booking> jobs) {
    final now = DateTime.now();
    return jobs.where((j) {
      if (j.status != BookingStatus.completed) return false;
      switch (_selectedPeriodIndex) {
        case 0:
          return j.scheduledDate.year == now.year &&
              j.scheduledDate.month == now.month &&
              j.scheduledDate.day == now.day;
        case 1:
          final weekAgo = now.subtract(const Duration(days: 7));
          return j.scheduledDate.isAfter(weekAgo);
        case 2:
          return j.scheduledDate.year == now.year &&
              j.scheduledDate.month == now.month;
        default:
          return true;
      }
    }).toList();
  }

  Map<String, int> _weeklyJobCounts(List<Booking> jobs) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final counts = {for (var d in days) d: 0};
    for (final job in jobs) {
      if (job.status != BookingStatus.completed) continue;
      final diff = now.difference(job.scheduledDate).inDays;
      if (diff < 0 || diff >= 7) continue;
      final weekday = job.scheduledDate.weekday;
      final label = days[weekday - 1];
      counts[label] = (counts[label] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(washerJobsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Earnings', style: AppTypography.titleLarge),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: jobsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Could not load earnings data',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
        data: (jobs) {
          final filtered = _filterByPeriod(jobs);
          final jobCount = filtered.length;
          final weeklyCounts = _weeklyJobCounts(jobs);
          final maxCount =
              weeklyCounts.values.reduce((a, b) => a > b ? a : b);
          final effectiveMax = maxCount > 0 ? maxCount : 1;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _periods.length,
                      separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final isSelected = _selectedPeriodIndex == index;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedPeriodIndex = index),
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
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textSecondary,
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

                  Center(
                    child: Column(
                      children: [
                        Text(
                          '$jobCount',
                          style: AppTypography.headlineLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          'Jobs Completed — ${_periods[_selectedPeriodIndex]}',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(AppSpacing.xxl),

                  Text('Weekly Breakdown', style: AppTypography.titleMedium),
                  const Gap(AppSpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
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
                        children: weeklyCounts.entries.map((entry) {
                          final barHeight =
                              (entry.value / effectiveMax) * 140;
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (entry.value > 0)
                                    Text(
                                      '${entry.value}',
                                      style:
                                          AppTypography.labelSmall.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  const Gap(4),
                                  Container(
                                    height: barHeight.clamp(4.0, 140.0),
                                    decoration: BoxDecoration(
                                      color: entry.value > 0
                                          ? AppColors.primary
                                          : AppColors.divider,
                                      borderRadius:
                                          BorderRadius.circular(4),
                                    ),
                                  ),
                                  const Gap(AppSpacing.sm),
                                  Text(
                                    entry.key,
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

                  Text('Completed Jobs', style: AppTypography.titleMedium),
                  const Gap(AppSpacing.lg),
                  if (filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No completed jobs for this period',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    ...filtered.map((job) => Container(
                          margin:
                              const EdgeInsets.only(bottom: AppSpacing.sm),
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd),
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
                                  color: AppColors.success.withValues(
                                      alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle_outline,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                              ),
                              const Gap(AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      job.vehicleId,
                                      style: AppTypography.bodyMedium,
                                    ),
                                    const Gap(2),
                                    Text(
                                      DateFormat('MMM d, yyyy').format(
                                          job.scheduledDate),
                                      style:
                                          AppTypography.labelSmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '#${job.id.length > 8 ? job.id.substring(0, 8) : job.id}',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )),
                  const Gap(AppSpacing.xxxl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
