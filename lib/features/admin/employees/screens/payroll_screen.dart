import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/admin_payroll_provider.dart';
import 'package:gap/gap.dart';

class PayrollScreen extends ConsumerWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payrollAsync = ref.watch(adminPayrollProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payroll'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: payrollAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text('Could not load payroll data',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ),
        data: (employees) {
          if (employees.isEmpty) {
            return Center(
              child: Text('No employees found',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF0047B3)],
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Team Members',
                              style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
                          const Gap(4),
                          Text('${employees.length}',
                              style: AppTypography.headlineLarge.copyWith(
                                  color: Colors.white, fontWeight: FontWeight.bold)),
                          const Gap(4),
                          Text('Active employees',
                              style: AppTypography.labelSmall.copyWith(color: Colors.white54)),
                        ],
                      ),
                    ),
                  ]),
                ),
                const Gap(24),
                Text('Team Members', style: AppTypography.titleMedium),
                const Gap(12),
                ...employees.map((emp) {
                  final name = emp['name']?.toString() ?? 'Employee';
                  final initials = name
                      .split(' ')
                      .map((x) => x.isNotEmpty ? x[0] : '')
                      .take(2)
                      .join();
                  final completed = emp['completed_jobs'] as int? ?? 0;
                  final payout = (emp['total_payout'] as num?)?.toDouble() ?? 0.0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))
                      ],
                    ),
                    child: Row(children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(initials,
                            style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: AppTypography.titleMedium),
                            Text(
                              emp['email']?.toString() ?? '',
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('$completed jobs',
                              style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                          const Gap(4),
                          Text(
                            'Rp ${NumberFormat('#,###').format(payout.toInt())}',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}