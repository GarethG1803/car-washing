import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:gap/gap.dart';

class PerformanceRing extends StatelessWidget {
  final double completionRate;

  const PerformanceRing({
    super.key,
    this.completionRate = 96.8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 10.0,
          percent: (completionRate / 100).clamp(0.0, 1.0),
          center: Text(
            '${completionRate.toStringAsFixed(1)}%',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          progressColor: AppColors.primary,
          backgroundColor: AppColors.primaryLight,
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 1200,
        ),
        const Gap(AppSpacing.sm),
        Text(
          'Completion Rate',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
