import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:clean_ride/data/providers/orders_provider.dart';
import 'package:gap/gap.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String bookingId;
  const OrderDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(orderDetailProvider(bookingId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Order #${bookingId.length > 8 ? bookingId.substring(0, 8) : bookingId}'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
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
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textSecondary),
                const Gap(12),
                Text('Order not found', style: AppTypography.titleMedium),
              ]),
            );
          }
          final order = data['order'] as Map<String, dynamic>;
          final history = data['history'] as List? ?? [];
          final status = order['status']?.toString() ?? 'pending';
          final scheduledAt = order['scheduled_at'] != null
              ? DateTime.parse(order['scheduled_at'].toString())
              : null;
          final appStatus = _mapStatus(status);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _card([
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                    child: Text(
                      'Order #${(order['id']?.toString() ?? '').substring(0, 8)}',
                      style: AppTypography.titleLarge,
                    ),
                  ),
                  AppStatusIndicator(status: appStatus),
                ]),
                const Gap(12),
                if (scheduledAt != null)
                  _row(Icons.calendar_today,
                      DateFormat('MMM dd, yyyy • HH:mm').format(scheduledAt)),
                const Gap(8),
                _row(Icons.location_on_outlined,
                    order['location_address']?.toString() ?? 'No address'),
                const Gap(8),
                _row(Icons.directions_car,
                    '${order['vehicle_type']?.toString().toUpperCase() ?? ''} • ${order['vehicle_plate'] ?? ''}'),
              ]),
              const Gap(16),
              if (order['assigned_employee_id'] != null) ...[
                _card([
                  Text('Assigned Washer', style: AppTypography.titleMedium),
                  const Gap(8),
                  Row(children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(Icons.person, color: AppColors.primary),
                    ),
                    const Gap(12),
                    Text('Washer assigned', style: AppTypography.bodyMedium),
                  ]),
                ]),
                const Gap(16),
              ],
              if (history.isNotEmpty) ...[
                _card([
                  Text('Status History', style: AppTypography.titleMedium),
                  const Gap(12),
                  ...history.map((h) {
                    final hMap = h as Map<String, dynamic>;
                    final changedAt = hMap['changed_at'] != null
                        ? DateTime.parse(hMap['changed_at'].toString())
                        : null;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              hMap['status']?.toString().replaceAll('_', ' ').toUpperCase() ?? '',
                              style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                            if (changedAt != null)
                              Text(DateFormat('MMM dd, HH:mm').format(changedAt),
                                  style: AppTypography.labelSmall
                                      .copyWith(color: AppColors.textSecondary)),
                          ]),
                        ),
                      ]),
                    );
                  }),
                ]),
                const Gap(16),
              ],
              if (status != 'done' && status != 'cancelled')
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push('/customer/tracking/$bookingId'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                    ),
                    child: const Text('Track Order'),
                  ),
                ),
            ]),
          );
        },
      ),
    );
  }

  AppStatus _mapStatus(String s) {
    switch (s) {
      case 'confirmed': return AppStatus.confirmed;
      case 'on_the_way':
      case 'in_progress': return AppStatus.inProgress;
      case 'done': return AppStatus.completed;
      case 'cancelled': return AppStatus.cancelled;
      default: return AppStatus.pending;
    }
  }

  Widget _card(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 16, color: AppColors.textSecondary),
      const Gap(8),
      Expanded(child: Text(text, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary))),
    ]);
  }
}
