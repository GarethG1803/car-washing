import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';

enum AppStatus { pending, confirmed, inProgress, completed, cancelled }

class AppStatusIndicator extends StatelessWidget {
  final AppStatus status;

  const AppStatusIndicator({
    super.key,
    required this.status,
  });

  String get _label {
    switch (status) {
      case AppStatus.pending:
        return 'Pending';
      case AppStatus.confirmed:
        return 'Confirmed';
      case AppStatus.inProgress:
        return 'In Progress';
      case AppStatus.completed:
        return 'Completed';
      case AppStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case AppStatus.pending:
        return AppColors.warning.withOpacity(0.1);
      case AppStatus.confirmed:
        return AppColors.primary.withOpacity(0.1);
      case AppStatus.inProgress:
        return AppColors.primary;
      case AppStatus.completed:
        return AppColors.success.withOpacity(0.1);
      case AppStatus.cancelled:
        return AppColors.error.withOpacity(0.1);
    }
  }

  Color get _textColor {
    switch (status) {
      case AppStatus.pending:
        return AppColors.warning;
      case AppStatus.confirmed:
        return AppColors.primary;
      case AppStatus.inProgress:
        return Colors.white;
      case AppStatus.completed:
        return AppColors.success;
      case AppStatus.cancelled:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: AppTypography.labelSmall.copyWith(
          color: _textColor,
        ),
      ),
    );
  }
}
