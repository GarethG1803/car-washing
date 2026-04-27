import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/users_provider.dart';
import 'package:gap/gap.dart';

class PayrollScreen extends ConsumerWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(usersProvider('employee'));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payroll'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: employeesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text('Could not load payroll data',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        ),
        data: (employees) {
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
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Team Members',
                            style: AppTypography.bodyMedium
                                .copyWith(color: Colors.white70),
                          ),
                          const Gap(4),
                          Text(
                            '${employees.length}',
                            style: AppTypography.headlineLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            'Active employees',
                            style: AppTypography.labelSmall
                                .copyWith(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                const Gap(24),
                Text('Team Members', style: AppTypography.titleMedium),
                const Gap(12),
                if (employees.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No employees found',
                        style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  ...employees.map((w) {
                    final name = w['name']?.toString() ?? 'Employee';
                    final initials = name
                        .split(' ')
                        .map((x) => x.isNotEmpty ? x[0] : '')
                        .take(2)
                        .join();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            initials,
                            style: AppTypography.labelLarge
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: AppTypography.titleMedium),
                              Text(
                                w['email']?.toString() ?? '',
                                style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Active',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.success,
                              fontSize: 10,
                            ),
                          ),
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
