import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

class OrderCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;

  const OrderCard({super.key, required this.booking, this.onTap});

  AppStatus _mapStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppStatus.pending;
      case BookingStatus.confirmed:
        return AppStatus.confirmed;
      case BookingStatus.washerEnRoute:
      case BookingStatus.inProgress:
        return AppStatus.inProgress;
      case BookingStatus.completed:
        return AppStatus.completed;
      case BookingStatus.cancelled:
        return AppStatus.cancelled;
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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.local_car_wash, color: AppColors.primary, size: 22),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Standard Wash', style: AppTypography.titleMedium),
                      const Gap(2),
                      Text(
                        'Booking #${booking.id}',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                AppStatusIndicator(status: _mapStatus(booking.status)),
              ],
            ),
            const Gap(12),
            const Divider(color: AppColors.divider),
            const Gap(12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                const Gap(6),
                Text(
                  DateFormat('MMM dd, yyyy').format(booking.scheduledDate),
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const Gap(16),
                Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                const Gap(6),
                Text(
                  booking.timeSlot,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const Spacer(),
                Text(
                  'Rp ${NumberFormat('#,###').format(booking.totalAmount.toInt())}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
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
