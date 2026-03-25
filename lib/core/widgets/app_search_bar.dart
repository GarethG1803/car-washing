import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';

class AppSearchBar extends StatelessWidget {
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const AppSearchBar({
    super.key,
    this.hint,
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: hint ?? 'Search...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          if (onFilterTap != null) ...[
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: onFilterTap,
              child: const Icon(
                Icons.tune,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
