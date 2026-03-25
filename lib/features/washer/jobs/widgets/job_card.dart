import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:gap/gap.dart';

class JobCardData {
  final String id;
  final String bookingId;
  final String serviceName;
  final String customerName;
  final String vehicleInfo;
  final String timeSlot;
  final String address;
  final double price;
  final String status;
  final double? rating;

  const JobCardData({
    required this.id,
    required this.bookingId,
    required this.serviceName,
    required this.customerName,
    required this.vehicleInfo,
    required this.timeSlot,
    required this.address,
    required this.price,
    required this.status,
    this.rating,
  });
}

class JobCard extends StatelessWidget {
  final JobCardData data;
  final VoidCallback? onTap;
  final Widget? trailing;

  const JobCard({
    super.key,
    required this.data,
    this.onTap,
    this.trailing,
  });

  AppStatus get _appStatus {
    switch (data.status) {
      case 'pending':
        return AppStatus.pending;
      case 'confirmed':
        return AppStatus.confirmed;
      case 'inProgress':
      case 'washerEnRoute':
        return AppStatus.inProgress;
      case 'completed':
        return AppStatus.completed;
      case 'cancelled':
        return AppStatus.cancelled;
      default:
        return AppStatus.pending;
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
            // Top row: Booking ID + Status
            Row(
              children: [
                Text(
                  data.bookingId,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                AppStatusIndicator(status: _appStatus),
              ],
            ),
            const Gap(AppSpacing.md),

            // Service name
            Text(
              data.serviceName,
              style: AppTypography.titleMedium,
            ),
            const Gap(AppSpacing.sm),

            // Customer name
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const Gap(AppSpacing.sm),
                Text(
                  data.customerName,
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
            const Gap(AppSpacing.xs),

            // Vehicle info
            Row(
              children: [
                const Icon(
                  Icons.directions_car_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const Gap(AppSpacing.sm),
                Text(
                  data.vehicleInfo,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.xs),

            // Time slot + Address
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const Gap(AppSpacing.sm),
                Text(
                  data.timeSlot,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.xs),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    data.address,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.md),

            // Bottom row: Price + Rating (if completed)
            Row(
              children: [
                Text(
                  'Rp ${NumberFormat('#,###').format(data.price.toInt())}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (data.rating != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const Gap(2),
                      Text(
                        data.rating!.toStringAsFixed(1),
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            // Optional trailing widget (e.g., action buttons)
            if (trailing != null) ...[
              const Gap(AppSpacing.lg),
              const Divider(color: AppColors.divider, height: 1),
              const Gap(AppSpacing.lg),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
