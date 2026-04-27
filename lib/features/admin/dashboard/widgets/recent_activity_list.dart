import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:clean_ride/data/providers/admin_orders_provider.dart';
import 'package:gap/gap.dart';

class RecentActivityList extends ConsumerWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(adminOrdersProvider);

    return ordersAsync.when(
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (orders) {
        final recent = orders.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final display = recent.take(6).toList();

        if (display.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Center(
              child: Text(
                'No recent orders',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            children: display.map((order) {
              final shortId = order.id.length > 8
                  ? order.id.substring(0, 8).toUpperCase()
                  : order.id.toUpperCase();
              final appStatus = _appStatus(order.status);
              final timeStr = _timeAgo(order.createdAt);
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.book_online,
                          color: AppColors.primary, size: 20),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #$shortId',
                            style: AppTypography.bodyMedium,
                          ),
                          Text(
                            '${order.vehicleId.toUpperCase()} • ${DateFormat('MMM dd, HH:mm').format(order.scheduledDate)}',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Gap(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppStatusIndicator(status: appStatus),
                        const Gap(2),
                        Text(
                          timeStr,
                          style: AppTypography.labelSmall
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

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

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
