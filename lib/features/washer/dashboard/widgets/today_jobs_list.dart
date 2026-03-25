import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class TodayJobData {
  final String id;
  final String time;
  final String serviceName;
  final String customerName;
  final String address;
  final String status;

  const TodayJobData({
    required this.id,
    required this.time,
    required this.serviceName,
    required this.customerName,
    required this.address,
    required this.status,
  });
}

class TodayJobsList extends StatelessWidget {
  final List<TodayJobData> jobs;
  final ValueChanged<String> onJobTap;

  const TodayJobsList({
    super.key,
    required this.jobs,
    required this.onJobTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: jobs
          .map((job) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _TodayJobCard(
                  job: job,
                  onTap: () => onJobTap(job.id),
                ),
              ))
          .toList(),
    );
  }
}

class _TodayJobCard extends StatelessWidget {
  final TodayJobData job;
  final VoidCallback onTap;

  const _TodayJobCard({
    required this.job,
    required this.onTap,
  });

  Color get _statusColor {
    switch (job.status) {
      case 'pending':
        return AppColors.warning;
      case 'confirmed':
        return AppColors.primary;
      case 'inProgress':
        return AppColors.success;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String get _statusLabel {
    switch (job.status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'inProgress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return job.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time badge + Status indicator
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    job.time,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel,
                    style: AppTypography.labelSmall.copyWith(
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.md),
            // Customer name
            Text(
              job.customerName,
              style: AppTypography.titleMedium,
            ),
            const Gap(4),
            // Service name
            Text(
              job.serviceName,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Gap(4),
            // Address
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const Gap(4),
                Expanded(
                  child: Text(
                    job.address,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
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
