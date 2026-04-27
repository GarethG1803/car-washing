import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Invoices'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        Row(children: [
          _stat('Total', 'Rp 187.200.000', AppColors.primary),
          const Gap(12),
          _stat('Paid', 'Rp 147.600.000', AppColors.success),
          const Gap(12),
          _stat('Overdue', 'Rp 39.600.000', AppColors.error),
        ]),
        const Gap(24),
        ..._invoices().map((inv) => Container(
          margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(inv['id'] as String, style: AppTypography.titleMedium),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: (inv['statusColor'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(inv['status'] as String, style: AppTypography.labelSmall.copyWith(color: inv['statusColor'] as Color)),
              ),
            ]),
            const Gap(8),
            Text(inv['customer'] as String, style: AppTypography.bodyMedium),
            const Gap(4),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(inv['date'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
              Text(inv['amount'] as String, style: AppTypography.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ]),
          ]),
        )),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: () {}, backgroundColor: AppColors.primary, child: const Icon(Icons.add, color: Colors.white)),
    );
  }

  Widget _stat(String label, String value, Color color) => Expanded(child: Container(
    padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
    child: Column(children: [Text(value, style: AppTypography.titleMedium.copyWith(color: color, fontWeight: FontWeight.bold)), Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary))]),
  ));

  List<Map<String, dynamic>> _invoices() => [
    {'id': 'INV-001', 'customer': 'Alex Johnson', 'date': 'Feb 10, 2026', 'amount': 'Rp 150.000', 'status': 'Paid', 'statusColor': AppColors.success},
    {'id': 'INV-002', 'customer': 'Emily Davis', 'date': 'Feb 8, 2026', 'amount': 'Rp 500.000', 'status': 'Paid', 'statusColor': AppColors.success},
    {'id': 'INV-003', 'customer': 'Michael Brown', 'date': 'Feb 5, 2026', 'amount': 'Rp 2.500.000', 'status': 'Overdue', 'statusColor': AppColors.error},
    {'id': 'INV-004', 'customer': 'Sarah Miller', 'date': 'Feb 3, 2026', 'amount': 'Rp 200.000', 'status': 'Sent', 'statusColor': AppColors.warning},
    {'id': 'INV-005', 'customer': 'David Wilson', 'date': 'Feb 1, 2026', 'amount': 'Rp 75.000', 'status': 'Draft', 'statusColor': AppColors.textSecondary},
  ];
}
