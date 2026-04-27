import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';

enum AppButtonType { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 52,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (type) {
      case AppButtonType.primary:
        return _PrimaryButton(
          label: label,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
        );
      case AppButtonType.secondary:
        return _SecondaryButton(
          label: label,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
        );
      case AppButtonType.outline:
        return _OutlineButton(
          label: label,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
        );
      case AppButtonType.text:
        return _TextButtonVariant(
          label: label,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
        );
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const _PrimaryButton({
    required this.label,
    this.onPressed,
    required this.isLoading,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        elevation: 0,
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        icon: icon,
        textColor: Colors.white,
        loadingColor: Colors.white,
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const _SecondaryButton({
    required this.label,
    this.onPressed,
    required this.isLoading,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.primaryLight.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        elevation: 0,
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        icon: icon,
        textColor: AppColors.primary,
        loadingColor: AppColors.primary,
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const _OutlineButton({
    required this.label,
    this.onPressed,
    required this.isLoading,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        icon: icon,
        textColor: AppColors.primary,
        loadingColor: AppColors.primary,
      ),
    );
  }
}

class _TextButtonVariant extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const _TextButtonVariant({
    required this.label,
    this.onPressed,
    required this.isLoading,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        icon: icon,
        textColor: AppColors.primary,
        loadingColor: AppColors.primary,
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final bool isLoading;
  final IconData? icon;
  final Color textColor;
  final Color loadingColor;

  const _ButtonContent({
    required this.label,
    required this.isLoading,
    this.icon,
    required this.textColor,
    required this.loadingColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTypography.labelLarge.copyWith(color: textColor),
          ),
        ],
      );
    }

    return Text(
      label,
      style: AppTypography.labelLarge.copyWith(color: textColor),
    );
  }
}
