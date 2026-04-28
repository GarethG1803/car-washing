import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/stats_provider.dart';
import 'package:gap/gap.dart';

class FinanceOverviewScreen extends ConsumerWidget {
  const FinanceOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(orderStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Finance'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [TextButton(onPressed: () => context.push('/admin/finance/invoices'), child: const Text('Invoices'))],
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const Gap(12),
              Text('Could not load data', style: AppTypography.titleMedium),
              const Gap(16),
              TextButton(
                onPressed: () => ref.invalidate(orderStatsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (stats) {
          final total = stats['totalOrders'] as int? ?? 0;
          final completed = stats['completedOrders'] as int? ?? 0;
          final pending = stats['pendingOrders'] as int? ?? 0;
          final active = stats['activeOrders'] as int? ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              const Gap(32),
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.payments_outlined, size: 48, color: AppColors.textSecondary),
                    const Gap(12),
                    Text('Financial Reports', style: AppTypography.titleMedium),
                    const Gap(8),
                    Text(
                      'Revenue and expense tracking\nwill be available in a future update.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Gap(32),
            ]),
          );
        },
      ),
    );
  }

  Widget _summaryCard(String label, String value, IconData icon, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color)),
        const Gap(12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)), Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary))]),
      ]),
    ));
  }
}
