import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:clean_ride/data/providers/admin_orders_provider.dart';
import 'package:gap/gap.dart';

class KpiRow extends ConsumerWidget {
  const KpiRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(adminOrdersProvider);

    return ordersAsync.when(
      loading: () => const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (orders) {
        final total = orders.length;
        final pending = orders
            .where((o) =>
                o.status == BookingStatus.pending ||
                o.status == BookingStatus.confirmed)
            .length;
        final active = orders
            .where((o) =>
                o.status == BookingStatus.washerEnRoute ||
                o.status == BookingStatus.inProgress)
            .length;
        final done =
            orders.where((o) => o.status == BookingStatus.completed).length;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    title: 'Total Orders',
                    value: '$total',
                    icon: Icons.book_online,
                    color: AppColors.primary,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _KpiCard(
                    title: 'Pending',
                    value: '$pending',
                    icon: Icons.pending_outlined,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    title: 'Active',
                    value: '$active',
                    icon: Icons.local_car_wash,
                    color: AppColors.success,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _KpiCard(
                    title: 'Completed',
                    value: '$done',
                    icon: Icons.check_circle_outline,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Gap(12),
          Text(
            value,
            style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const Gap(2),
          Text(
            title,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
