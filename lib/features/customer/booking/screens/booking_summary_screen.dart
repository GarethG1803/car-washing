import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/booking_state_provider.dart';
import 'package:clean_ride/data/providers/services_provider.dart';
import 'package:gap/gap.dart';

class BookingSummaryScreen extends ConsumerWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingStateProvider);
    final servicesAsync = ref.watch(servicesProvider);

    final serviceName = servicesAsync.maybeWhen(
      data: (services) {
        try {
          return services.firstWhere((s) => s.id == booking.serviceId).name;
        } catch (_) {
          return booking.serviceId ?? '—';
        }
      },
      orElse: () => booking.serviceId ?? '—',
    );

    final servicePrice = servicesAsync.maybeWhen(
      data: (services) {
        try {
          return services.firstWhere((s) => s.id == booking.serviceId).price;
        } catch (_) {
          return null;
        }
      },
      orElse: () => null,
    );

    final scheduledAt = booking.scheduledAt;
    final dateStr = scheduledAt != null
        ? DateFormat('EEE, MMM dd yyyy').format(scheduledAt)
        : '—';
    final timeStr =
        scheduledAt != null ? DateFormat('HH:mm').format(scheduledAt) : '—';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking Summary', style: AppTypography.titleLarge),
          const Gap(4),
          Text(
            'Review your booking details',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const Gap(24),
          _buildSection('Vehicle', [
            _buildRow('Plate', booking.vehiclePlate.isNotEmpty ? booking.vehiclePlate : '—'),
            _buildRow('Type', booking.vehicleType.toUpperCase()),
          ]),
          const Gap(16),
          _buildSection('Service', [
            _buildRow('Package', serviceName),
            if (servicePrice != null)
              _buildRow('Price', 'Rp ${NumberFormat('#,###').format(servicePrice.toInt())}'),
          ]),
          const Gap(16),
          _buildSection('Schedule', [
            _buildRow('Date', dateStr),
            _buildRow('Time', timeStr),
          ]),
          const Gap(16),
          _buildSection('Location', [
            _buildRow(
                'Address',
                booking.locationAddress.isNotEmpty ? booking.locationAddress : '—'),
            if (booking.notes != null && booking.notes!.isNotEmpty)
              _buildRow('Notes', booking.notes!),
          ]),
          if (servicePrice != null) ...[
            const Gap(24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  _buildPriceRow(serviceName,
                      'Rp ${NumberFormat('#,###').format(servicePrice.toInt())}'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: AppColors.divider),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTypography.titleMedium),
                      Text(
                        'Rp ${NumberFormat('#,###').format(servicePrice.toInt())}',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> rows) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Text(title, style: AppTypography.titleMedium),
          const Gap(12),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          Flexible(
            child: Text(value,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        Text(price, style: AppTypography.bodyMedium),
      ],
    );
  }
}
