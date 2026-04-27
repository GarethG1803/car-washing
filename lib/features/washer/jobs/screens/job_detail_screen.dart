import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:clean_ride/data/providers/washer_jobs_provider.dart';
import 'package:gap/gap.dart';

class JobDetailScreen extends ConsumerWidget {
  final String jobId;
  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(washerJobsProvider);

    return jobsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Job Detail')),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const Gap(12),
            Text('Could not load job', style: AppTypography.titleMedium),
            const Gap(16),
            TextButton(
              onPressed: () => ref.invalidate(washerJobsProvider),
              child: const Text('Retry'),
            ),
          ]),
        ),
      ),
      data: (jobs) {
        Booking? job;
        try {
          job = jobs.firstWhere((j) => j.id == jobId);
        } catch (_) {
          job = null;
        }

        if (job == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Job Detail'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Job not found')),
          );
        }

        return _JobDetailView(job: job);
      },
    );
  }
}

class _JobDetailView extends ConsumerStatefulWidget {
  final Booking job;
  const _JobDetailView({required this.job});

  @override
  ConsumerState<_JobDetailView> createState() => _JobDetailViewState();
}

class _JobDetailViewState extends ConsumerState<_JobDetailView> {
  bool _isUpdating = false;

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isUpdating = true);
    final error = await ref
        .read(washerJobActionsProvider)
        .updateStatus(widget.job.id, newStatus);
    if (!mounted) return;
    setState(() => _isUpdating = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status updated'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Color get _statusColor {
    switch (widget.job.status) {
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
    switch (widget.job.status) {
      case BookingStatus.confirmed:
        return 'Confirmed — Ready to go';
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

  IconData get _statusIcon {
    switch (widget.job.status) {
      case BookingStatus.confirmed:
        return Icons.check_circle_outline;
      case BookingStatus.washerEnRoute:
        return Icons.directions_car;
      case BookingStatus.inProgress:
        return Icons.local_car_wash;
      case BookingStatus.completed:
        return Icons.check_circle;
      case BookingStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final shortId =
        job.id.length > 8 ? job.id.substring(0, 8).toUpperCase() : job.id.toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Job #$shortId', style: AppTypography.titleLarge),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Status banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md, horizontal: AppSpacing.lg),
            color: _statusColor,
            child: Row(
              children: [
                Icon(_statusIcon, color: Colors.white, size: 18),
                const Gap(AppSpacing.sm),
                Text(
                  _statusLabel,
                  style: AppTypography.labelLarge.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _card('Vehicle', [
                    _row(Icons.directions_car_outlined, 'Plate',
                        job.vehicleId.toUpperCase()),
                    const Gap(AppSpacing.md),
                    _row(Icons.badge_outlined, 'Service ID', job.servicePackageId),
                  ]),
                  const Gap(AppSpacing.lg),
                  _card('Schedule', [
                    _row(Icons.calendar_today, 'Date',
                        DateFormat('EEE, MMM dd yyyy').format(job.scheduledDate)),
                    const Gap(AppSpacing.md),
                    _row(Icons.access_time, 'Time',
                        DateFormat('HH:mm').format(job.scheduledDate)),
                  ]),
                  const Gap(AppSpacing.lg),
                  _card('Location', [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on,
                            color: AppColors.primary, size: 20),
                        const Gap(AppSpacing.sm),
                        Expanded(
                            child: Text(job.address, style: AppTypography.bodyMedium)),
                      ],
                    ),
                  ]),
                  if (job.notes != null && job.notes!.isNotEmpty) ...[
                    const Gap(AppSpacing.lg),
                    _card('Special Instructions', [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline,
                              color: AppColors.warning, size: 20),
                          const Gap(AppSpacing.sm),
                          Expanded(
                              child: Text(job.notes!, style: AppTypography.bodyMedium)),
                        ],
                      ),
                    ]),
                  ],
                  const Gap(AppSpacing.xl),
                ],
              ),
            ),
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    if (_isUpdating) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        color: Colors.white,
        child: const SafeArea(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    Widget? content;
    switch (widget.job.status) {
      case BookingStatus.confirmed:
        content = SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => _updateStatus('on_the_way'),
            icon: const Icon(Icons.directions_car),
            label: const Text('Start Driving'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            ),
          ),
        );
        break;
      case BookingStatus.washerEnRoute:
        content = SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => _updateStatus('in_progress'),
            icon: const Icon(Icons.local_car_wash),
            label: const Text('Start Wash'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            ),
          ),
        );
        break;
      case BookingStatus.inProgress:
        content = SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => _updateStatus('done'),
            icon: const Icon(Icons.check_circle),
            label: const Text('Mark Complete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            ),
          ),
        );
        break;
      default:
        content = null;
    }

    if (content == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(child: content),
    );
  }

  Widget _card(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
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
          Text(title,
              style:
                  AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
          const Gap(AppSpacing.md),
          ...children,
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const Gap(AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.textSecondary)),
              Text(value, style: AppTypography.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
