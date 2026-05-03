import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/stats_provider.dart';
import 'package:clean_ride/data/providers/admin_finance_provider.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

class FinanceOverviewScreen extends ConsumerWidget {
  const FinanceOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(orderStatsProvider);
    final financeAsync = ref.watch(adminFinanceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Finance'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () => context.push('/admin/finance/invoices'),
            child: const Text('Invoices'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Order stats row (unchanged)
          statsAsync.when(
            loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
            error: (_, __) => const SizedBox.shrink(),
            data: (stats) {
              final total = stats['totalOrders'] as int? ?? 0;
              final completed = stats['completedOrders'] as int? ?? 0;
              final pending = stats['pendingOrders'] as int? ?? 0;
              final active = stats['activeOrders'] as int? ?? 0;
              return Column(children: [
                Row(children: [
                  _summaryCard('Total Orders', '$total', Icons.book_online, AppColors.primary),
                  const Gap(12),
                  _summaryCard('Completed', '$completed', Icons.check_circle_outline, AppColors.success),
                ]),
                const Gap(12),
                Row(children: [
                  _summaryCard('Active', '$active', Icons.local_car_wash, AppColors.warning),
                  const Gap(12),
                  _summaryCard('Pending', '$pending', Icons.hourglass_empty, AppColors.textSecondary),
                ]),
              ]);
            },
          ),
          const Gap(32),

          // Platform revenue section
          Text('Platform Revenue', style: AppTypography.titleMedium),
          const Gap(16),
          financeAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(
              child: Text('Could not load revenue data',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ),
            data: (data) {
              final today = (data['today'] as num?)?.toDouble() ?? 0.0;
              final week = (data['week'] as num?)?.toDouble() ?? 0.0;
              final month = (data['month'] as num?)?.toDouble() ?? 0.0;
              final allTime = (data['all_time'] as num?)?.toDouble() ?? 0.0;
              final fmt = NumberFormat('#,###');

              return Column(children: [
                Row(children: [
                  _summaryCard('Today', 'Rp ${fmt.format(today.toInt())}', Icons.today, AppColors.primary),
                  const Gap(12),
                  _summaryCard('This Week', 'Rp ${fmt.format(week.toInt())}', Icons.calendar_view_week, AppColors.success),
                ]),
                const Gap(12),
                Row(children: [
                  _summaryCard('This Month', 'Rp ${fmt.format(month.toInt())}', Icons.calendar_month, AppColors.warning),
                  const Gap(12),
                  _summaryCard('All Time', 'Rp ${fmt.format(allTime.toInt())}', Icons.account_balance, AppColors.textSecondary),
                ]),
              ]);
            },
          ),
        ]),
      ),
    );
  }

  Widget _summaryCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))],
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const Gap(12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
            Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
          ]),
        ]),
      ),
    );
  }
}