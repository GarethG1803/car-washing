import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/admin_finance_provider.dart';
import 'package:gap/gap.dart';

class InvoiceScreen extends ConsumerWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(adminTransactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transaction Log'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const Gap(12),
            Text('Could not load transactions', style: AppTypography.bodyMedium),
            const Gap(16),
            TextButton(
              onPressed: () => ref.invalidate(adminTransactionsProvider),
              child: const Text('Retry'),
            ),
          ]),
        ),
        data: (transactions) {
          if (transactions.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textSecondary),
                const Gap(16),
                Text('No completed orders yet', style: AppTypography.titleMedium),
                const Gap(8),
                Text(
                  'Completed orders will appear here\nwith full revenue breakdown.',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ]),
            );
          }

          // Calculate totals
          double totalRevenue = 0;
          double totalWasherPayout = 0;
          double totalPlatform = 0;
          for (final t in transactions) {
            totalRevenue += (t['total_amount'] as num?)?.toDouble() ?? 0;
            totalWasherPayout += (t['washer_payout'] as num?)?.toDouble() ?? 0;
            totalPlatform += (t['platform_revenue'] as num?)?.toDouble() ?? 0;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary header
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF0047B3)],
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _summaryItem('Total Revenue',
                            'Rp ${NumberFormat('#,###').format(totalRevenue.toInt())}'),
                      ),
                      Expanded(
                        child: _summaryItem('Washer Payout',
                            'Rp ${NumberFormat('#,###').format(totalWasherPayout.toInt())}'),
                      ),
                      Expanded(
                        child: _summaryItem('Platform',
                            'Rp ${NumberFormat('#,###').format(totalPlatform.toInt())}'),
                      ),
                    ],
                  ),
                ),
                const Gap(24),
                Text('${transactions.length} completed orders',
                    style: AppTypography.titleMedium),
                const Gap(12),

                // Transaction list
                ...transactions.map((t) {
                  final orderId = t['id']?.toString() ?? '';
                  final shortId = orderId.length > 8
                      ? orderId.substring(0, 8).toUpperCase()
                      : orderId.toUpperCase();
                  final customer = t['customer_name']?.toString() ?? '—';
                  final washer = t['washer_name']?.toString() ?? '—';
                  final plate = t['vehicle_plate']?.toString() ?? '—';
                  final total = (t['total_amount'] as num?)?.toDouble() ?? 0;
                  final payout = (t['washer_payout'] as num?)?.toDouble() ?? 0;
                  final platform = (t['platform_revenue'] as num?)?.toDouble() ?? 0;
                  final completed = t['completed_at'] != null
                      ? DateTime.tryParse(t['completed_at'].toString())
                      : null;

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                        // Order ID + date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('#$shortId', style: AppTypography.titleMedium),
                            if (completed != null)
                              Text(
                                DateFormat('dd MMM yyyy').format(completed),
                                style: AppTypography.labelSmall
                                    .copyWith(color: AppColors.textSecondary),
                              ),
                          ],
                        ),
                        const Gap(8),
                        // Customer, Washer, Plate
                        _info(Icons.person_outline, customer),
                        _info(Icons.person, washer),
                        _info(Icons.directions_car_outlined, plate.toUpperCase()),
                        const Divider(height: 24),
                        // Revenue breakdown
                        Row(
                          children: [
                            Expanded(
                              child: _amountItem('Service', total, AppColors.primary),
                            ),
                            Expanded(
                              child: _amountItem('Washer', payout, AppColors.success),
                            ),
                            Expanded(
                              child: _amountItem('Platform', platform, AppColors.warning),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const Gap(24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: AppTypography.labelLarge.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
        const Gap(4),
        Text(label,
            style: AppTypography.labelSmall.copyWith(color: Colors.white70),
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _info(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const Gap(8),
          Expanded(
            child: Text(text,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _amountItem(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
        const Gap(2),
        Text(
          'Rp ${NumberFormat('#,###').format(amount.toInt())}',
          style: AppTypography.labelLarge.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}