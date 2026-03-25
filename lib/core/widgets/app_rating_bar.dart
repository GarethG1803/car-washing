import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';

class AppRatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final Function(double)? onRatingChanged;
  final bool isReadOnly;

  const AppRatingBar({
    super.key,
    required this.rating,
    this.size = 20,
    this.onRatingChanged,
    this.isReadOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final starPosition = index + 1;
          return GestureDetector(
            onTap: isReadOnly
                ? null
                : () => onRatingChanged?.call(starPosition.toDouble()),
            child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: _buildStar(starPosition),
            ),
          );
        }),
        if (isReadOnly) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            rating.toStringAsFixed(1),
            style: AppTypography.bodyMedium,
          ),
        ],
      ],
    );
  }

  Widget _buildStar(int starPosition) {
    if (rating >= starPosition) {
      // Full star
      return Icon(
        Icons.star_rounded,
        size: size,
        color: Colors.amber,
      );
    } else if (rating >= starPosition - 0.5) {
      // Half star
      return Icon(
        Icons.star_half_rounded,
        size: size,
        color: Colors.amber,
      );
    } else {
      // Empty star
      return Icon(
        Icons.star_outline_rounded,
        size: size,
        color: AppColors.textSecondary,
      );
    }
  }
}
