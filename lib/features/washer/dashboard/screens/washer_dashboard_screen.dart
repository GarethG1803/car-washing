import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_section_header.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:clean_ride/data/providers/washer_jobs_provider.dart';
import 'package:clean_ride/features/auth/providers/auth_provider.dart';
import 'package:gap/gap.dart';

class WasherDashboardScreen extends ConsumerWidget {
  const WasherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final jobsAsync = ref.watch(washerJobsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Text('Dashboard', style: AppTypography.titleLarge),
            actions: [
              IconButton(
                icon: const Icon(Icons.inventory_2_outlined),
                color: AppColors.textPrimary,
                tooltip: 'My Supplies',
                onPressed: () => context.push('/washer/inventory'),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_outlined),
                color: AppColors.textPrimary,
                onPressed: () => ref.invalidate(washerJobsProvider),
              ),
              const Gap(8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(AppSpacing.lg),
                  Text(
                    'Hello, ${user?.name ?? 'Washer'}',
                    style: AppTypography.headlineMedium,
                  ),
                  const Gap(4),
                  Text(
                    'Here are your assigned jobs',
                    style:
                        AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const Gap(AppSpacing.xl),
                  jobsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Column(children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 40),
                        const Gap(8),
                        Text('Could not load jobs\n\n${e.toString()}',
                          style: AppTypography.bodyMedium
                              .copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                    ),
                    data: (jobs) {
                      final today = DateTime.now();
                      final todayJobs = jobs.where((j) {
                        return j.scheduledDate.year == today.year &&
                            j.scheduledDate.month == today.month &&
                            j.scheduledDate.day == today.day;
                      }).toList();

                      final activeCount = jobs
                          .where((j) =>
                              j.status == BookingStatus.washerEnRoute ||
                              j.status == BookingStatus.inProgress)
                          .length;
                      final doneCount = jobs
                          .where((j) => j.status == BookingStatus.completed)
                          .length;
                      final pendingCount = jobs
                          .where((j) =>
                              j.status == BookingStatus.pending ||
                              j.status == BookingStatus.confirmed)
                          .length;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Today's Stats", style: AppTypography.titleMedium),
                          const Gap(AppSpacing.md),
                          Row(
                            children: [
                              Expanded(
                                child: _statCard(
                                  icon: Icons.pending_outlined,
                                  label: 'Upcoming',
                                  value: '$pendingCount',
                                  color: AppColors.warning,
                                ),
                              ),
                              const Gap(AppSpacing.md),
                              Expanded(
                                child: _statCard(
                                  icon: Icons.local_car_wash,
                                  label: 'Active',
                                  value: '$activeCount',
                                  color: AppColors.primary,
                                ),
                              ),
                              const Gap(AppSpacing.md),
                              Expanded(
                                child: _statCard(
                                  icon: Icons.check_circle_outline,
                                  label: 'Done',
                                  value: '$doneCount',
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                          const Gap(AppSpacing.xl),
                          AppSectionHeader(
                            title: "Today's Jobs",
                            actionLabel: 'See all',
                            onAction: () => context.go('/washer/jobs'),
                          ),
                          const Gap(AppSpacing.sm),
                          if (todayJobs.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.xl),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                              child: Center(
                                child: Column(children: [
                                  const Icon(Icons.event_available,
                                      size: 40, color: AppColors.textSecondary),
                                  const Gap(8),
                                  Text('No jobs today',
                                      style: AppTypography.bodyMedium
                                          .copyWith(color: AppColors.textSecondary)),
                                ]),
                              ),
                            )
                          else
                            ...todayJobs.take(5).map((job) => Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                  child: _TodayJobCard(
                                    job: job,
                                    onTap: () =>
                                        context.push('/washer/jobs/${job.id}'),
                                  ),
                                )),
                        ],
                      );
                    },
                  ),
                  const Gap(AppSpacing.xxxl),
                ],
              ),
            ),
          ),
        ],
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
          BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const Gap(AppSpacing.sm),
          Text(value,
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
          const Gap(2),
          Text(label,
              style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _TodayJobCard extends StatelessWidget {
  final Booking job;
  final VoidCallback onTap;

  const _TodayJobCard({required this.job, required this.onTap});

  Color get _statusColor {
    switch (job.status) {
      case BookingStatus.confirmed:
        return AppColors.primary;
      case BookingStatus.washerEnRoute:
      case BookingStatus.inProgress:
        return AppColors.success;
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  String get _statusLabel {
    switch (job.status) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.washerEnRoute:
        return 'En Route';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    DateFormat('HH:mm').format(job.scheduledDate),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel,
                    style: AppTypography.labelSmall.copyWith(color: _statusColor),
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.md),
            Text(
              'Order #${job.id.length > 8 ? job.id.substring(0, 8) : job.id}',
              style: AppTypography.titleMedium,
            ),
            const Gap(4),
            Text(
              '${job.vehicleId} • ${job.servicePackageId}',
              style:
                  AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const Gap(4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.textSecondary),
                const Gap(4),
                Expanded(
                  child: Text(
                    job.address,
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
