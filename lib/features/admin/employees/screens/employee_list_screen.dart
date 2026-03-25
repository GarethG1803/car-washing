import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_washers.dart';
import 'package:gap/gap.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final washers = MockWashers.profiles;
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
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: washers.length,
        separatorBuilder: (_, __) => const Gap(12),
        itemBuilder: (context, index) {
          final w = washers[index];
          return GestureDetector(
            onTap: () => context.push('/admin/team/${w.id}'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
              child: Row(children: [
                Stack(children: [
                  CircleAvatar(radius: 28, backgroundColor: AppColors.primaryLight, backgroundImage: w.avatarUrl != null ? NetworkImage(w.avatarUrl!) : null, child: w.avatarUrl == null ? Text(w.name.split(' ').map((x) => x[0]).take(2).join(), style: AppTypography.titleMedium.copyWith(color: AppColors.primary)) : null),
                  Positioned(right: 0, bottom: 0, child: Container(width: 14, height: 14, decoration: BoxDecoration(shape: BoxShape.circle, color: w.isOnline ? AppColors.success : AppColors.textSecondary, border: Border.all(color: Colors.white, width: 2)))),
                ]),
                const Gap(16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(w.name, style: AppTypography.titleMedium),
                  const Gap(2),
                  Row(children: [const Icon(Icons.star, size: 14, color: Colors.amber), const Gap(4), Text('${w.rating} • ${w.completedJobs} jobs', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary))]),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: w.isAvailable ? AppColors.success.withOpacity(0.1) : AppColors.textSecondary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(w.isAvailable ? 'Available' : 'Busy', style: AppTypography.labelSmall.copyWith(color: w.isAvailable ? AppColors.success : AppColors.textSecondary)),
                  ),
                  const Gap(4),
                  Text('Rp ${NumberFormat('#,###').format(w.earnings.toInt())}', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ]),
              ]),
            ),
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
