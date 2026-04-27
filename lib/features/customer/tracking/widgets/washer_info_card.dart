import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class WasherInfoCard extends ConsumerWidget {
  final String? assignedEmployeeId;
  const WasherInfoCard({super.key, this.assignedEmployeeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primaryLight,
            child: Icon(Icons.person, color: AppColors.primary, size: 28),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Assigned Washer', style: AppTypography.titleMedium),
                const Gap(2),
                Text(
                  assignedEmployeeId != null
                      ? 'ID: ${assignedEmployeeId!.length > 8 ? assignedEmployeeId!.substring(0, 8) : assignedEmployeeId}'
                      : 'Washer will be assigned soon',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
