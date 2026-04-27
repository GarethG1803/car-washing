import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/booking_state_provider.dart';
import 'package:gap/gap.dart';

class BookingConfirmedScreen extends ConsumerWidget {
  const BookingConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(lastCreatedOrderProvider);

    final orderId = order?['id']?.toString() ?? '';
    final shortId = orderId.length > 8 ? orderId.substring(0, 8) : orderId;
    final scheduledRaw = order?['scheduled_at']?.toString();
    final scheduledAt =
        scheduledRaw != null ? DateTime.tryParse(scheduledRaw) : null;
    final dateStr = scheduledAt != null
        ? DateFormat('EEE, MMM dd • HH:mm').format(scheduledAt)
        : '—';
    final plate = order?['vehicle_plate']?.toString() ?? '—';
    final vehicleType =
        order?['vehicle_type']?.toString().toUpperCase() ?? '—';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 64,
                  color: AppColors.success,
                ),
              ),
              const Gap(32),
              Text(
                'Booking Confirmed!',
                style: AppTypography.headlineMedium
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(12),
              Text(
                'Your car wash has been scheduled successfully.',
                style: AppTypography.bodyLarge
                    .copyWith(color: AppColors.textSecondary, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const Gap(32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Column(
                  children: [
                    _row('Booking ID', shortId.isNotEmpty ? '#${shortId.toUpperCase()}' : '—'),
                    const Gap(12),
                    _row('Vehicle', '$plate • $vehicleType'),
                    const Gap(12),
                    _row('Scheduled', dateStr),
                    const Gap(12),
                    _row('Status', 'Pending Confirmation'),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/customer/bookings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                  ),
                  child: const Text('View My Bookings'),
                ),
              ),
              const Gap(12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => context.go('/customer/home'),
                  child: Text(
                    'Back to Home',
                    style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        Text(value,
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
