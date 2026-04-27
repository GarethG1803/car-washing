import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/users_provider.dart';
import 'package:gap/gap.dart';

class EmployeeListScreen extends ConsumerWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(usersProvider('employee'));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Team'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/admin/team/payroll'),
            icon: const Icon(Icons.payments, size: 18),
            label: const Text('Payroll'),
          ),
        ],
      ),
      body: employeesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.error),
              const Gap(12),
              Text('Could not load team',
                  style: AppTypography.titleMedium),
              const Gap(16),
              TextButton(
                onPressed: () =>
                    ref.invalidate(usersProvider('employee')),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (employees) {
          if (employees.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline,
                      size: 64, color: AppColors.textSecondary),
                  const Gap(16),
                  Text('No employees yet',
                      style: AppTypography.titleMedium),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: employees.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              final w = employees[index];
              final name = w['name']?.toString() ?? 'Employee';
              final email = w['email']?.toString() ?? '';
              final id = w['id']?.toString() ?? '';
              final initials = name
                  .split(' ')
                  .map((x) => x.isNotEmpty ? x[0] : '')
                  .take(2)
                  .join();

              return GestureDetector(
                onTap: () => context.push('/admin/team/$id'),
                child: Container(
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
                      radius: 28,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        initials,
                        style: AppTypography.titleMedium
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: AppTypography.titleMedium),
                          const Gap(2),
                          Text(
                            email,
                            style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}
