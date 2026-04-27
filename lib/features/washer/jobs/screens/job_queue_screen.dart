import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:clean_ride/data/providers/washer_jobs_provider.dart';
import 'package:gap/gap.dart';

class JobQueueScreen extends ConsumerStatefulWidget {
  const JobQueueScreen({super.key});

  @override
  ConsumerState<JobQueueScreen> createState() => _JobQueueScreenState();
}

class _JobQueueScreenState extends ConsumerState<JobQueueScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(washerJobsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Jobs', style: AppTypography.titleLarge),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => ref.invalidate(washerJobsProvider),
          ),
        ],
        bottom: jobsAsync.maybeWhen(
          data: (jobs) {
            final incoming = jobs
                .where((j) =>
                    j.status == BookingStatus.pending ||
                    j.status == BookingStatus.confirmed)
                .length;
            final active = jobs
                .where((j) =>
                    j.status == BookingStatus.washerEnRoute ||
                    j.status == BookingStatus.inProgress)
                .length;
            final done =
                jobs.where((j) => j.status == BookingStatus.completed).length;
            return TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: AppTypography.labelLarge,
              unselectedLabelStyle: AppTypography.bodyMedium,
              tabs: [
                Tab(child: _tabLabel('Upcoming', incoming)),
                Tab(child: _tabLabel('Active', active)),
                Tab(child: _tabLabel('Done', done)),
              ],
            );
          },
          orElse: () => TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Active'),
              Tab(text: 'Done'),
            ],
          ),
        ),
      ),
      body: jobsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const Gap(12),
            Text('Could not load jobs', style: AppTypography.titleMedium),
            const Gap(16),
            TextButton(
              onPressed: () => ref.invalidate(washerJobsProvider),
              child: const Text('Retry'),
            ),
          ]),
        ),
        data: (jobs) {
          final upcoming = jobs
              .where((j) =>
                  j.status == BookingStatus.pending ||
                  j.status == BookingStatus.confirmed)
              .toList()
            ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
          final active = jobs
              .where((j) =>
                  j.status == BookingStatus.washerEnRoute ||
                  j.status == BookingStatus.inProgress)
              .toList()
            ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
          final done = jobs
              .where((j) => j.status == BookingStatus.completed)
              .toList()
            ..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));

          return TabBarView(
            controller: _tabController,
            children: [
              _JobList(jobs: upcoming),
              _JobList(jobs: active),
              _JobList(jobs: done),
            ],
          );
        },
      ),
    );
  }

  Widget _tabLabel(String label, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const Gap(6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style:
                AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 10),
          ),
        ),
      ],
    );
  }
}

class _JobList extends StatelessWidget {
  final List<Booking> jobs;
  const _JobList({required this.jobs});

  AppStatus _appStatus(BookingStatus s) {
    switch (s) {
      case BookingStatus.confirmed:
        return AppStatus.confirmed;
      case BookingStatus.washerEnRoute:
      case BookingStatus.inProgress:
        return AppStatus.inProgress;
      case BookingStatus.completed:
        return AppStatus.completed;
      case BookingStatus.cancelled:
        return AppStatus.cancelled;
      default:
        return AppStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.inbox_outlined, size: 48, color: AppColors.textSecondary),
          const Gap(12),
          Text('No jobs here', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ]),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: jobs.length,
      separatorBuilder: (_, __) => const Gap(AppSpacing.md),
      itemBuilder: (context, i) {
        final job = jobs[i];
        return GestureDetector(
          onTap: () => context.push('/washer/jobs/${job.id}'),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Order #${job.id.length > 8 ? job.id.substring(0, 8).toUpperCase() : job.id.toUpperCase()}',
                      style: AppTypography.labelSmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const Spacer(),
                    AppStatusIndicator(status: _appStatus(job.status)),
                  ],
                ),
                const Gap(AppSpacing.md),
                Row(children: [
                  const Icon(Icons.directions_car_outlined,
                      size: 16, color: AppColors.textSecondary),
                  const Gap(6),
                  Text(
                    '${job.vehicleId.toUpperCase()} • ${job.servicePackageId}',
                    style: AppTypography.bodyMedium,
                  ),
                ]),
                const Gap(AppSpacing.xs),
                Row(children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: AppColors.textSecondary),
                  const Gap(6),
                  Text(
                    DateFormat('EEE, MMM dd • HH:mm').format(job.scheduledDate),
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ]),
                const Gap(AppSpacing.xs),
                Row(children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: AppColors.textSecondary),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      job.address,
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }
}
