import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:clean_ride/data/providers/orders_provider.dart';
import 'package:clean_ride/features/customer/tracking/widgets/washer_info_card.dart';
import 'package:clean_ride/features/customer/tracking/widgets/status_timeline.dart';
import 'package:gap/gap.dart';

class TrackingScreen extends ConsumerWidget {
  final String bookingId;
  const TrackingScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(orderDetailProvider(bookingId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Track Order #${bookingId.length > 8 ? bookingId.substring(0, 8) : bookingId}'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => ref.invalidate(orderDetailProvider(bookingId)),
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const Gap(12),
            Text('Could not load order', style: AppTypography.titleMedium),
            const Gap(16),
            TextButton(
              onPressed: () => ref.invalidate(orderDetailProvider(bookingId)),
              child: const Text('Retry'),
            ),
          ]),
        ),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('Order not found'));
          }
          final order = data['order'] as Map<String, dynamic>;
          final status = order['status']?.toString() ?? 'pending';
          final assignedId = order['assigned_employee_id']?.toString();

          return Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  color: AppColors.primaryLight,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined,
                            size: 64,
                            color: AppColors.primary.withValues(alpha: 0.4)),
                        const Gap(8),
                        Text(
                          'Live Map View',
                          style: AppTypography.bodyMedium
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        const Gap(4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _statusLabel(status),
                            style: AppTypography.labelSmall
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.divider,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const Gap(20),
                        WasherInfoCard(assignedEmployeeId: assignedId),
                        const Gap(24),
                        Text('Status', style: AppTypography.titleMedium),
                        const Gap(16),
                        StatusTimeline(currentStatus: status),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'confirmed': return 'Confirmed';
      case 'on_the_way': return 'Washer En Route';
      case 'in_progress': return 'Wash In Progress';
      case 'done': return 'Completed';
      case 'cancelled': return 'Cancelled';
      default: return 'Pending';
    }
  }
}
