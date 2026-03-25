import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class JobActionButtons extends StatelessWidget {
  final String status;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onNavigate;
  final VoidCallback? onStartWash;
  final VoidCallback? onMarkComplete;
  final VoidCallback? onViewDetails;
  final VoidCallback? onViewReview;

  const JobActionButtons({
    super.key,
    required this.status,
    this.onAccept,
    this.onDecline,
    this.onNavigate,
    this.onStartWash,
    this.onMarkComplete,
    this.onViewDetails,
    this.onViewReview,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 'pending':
        return _buildPendingButtons();
      case 'confirmed':
      case 'washerEnRoute':
        return _buildEnRouteButtons();
      case 'inProgress':
        return _buildInProgressButtons();
      case 'completed':
        return _buildCompletedButtons();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPendingButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: onDecline,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              child: Text(
                'Decline',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ),
        const Gap(AppSpacing.md),
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              child: Text(
                'Accept',
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnRouteButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: onNavigate,
              icon: const Icon(Icons.navigation_outlined, size: 20),
              label: Text(
                'Navigate',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
          ),
        ),
        const Gap(AppSpacing.md),
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: onStartWash,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              child: Text(
                'Start Wash',
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInProgressButtons() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onMarkComplete,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: Text(
          'Mark Complete',
          style: AppTypography.labelLarge.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedButtons() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onViewReview ?? onViewDetails,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: Text(
          'View Review',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
