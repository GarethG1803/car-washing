import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const AppShimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  /// Creates a rounded rectangle shimmer placeholder.
  factory AppShimmer.card({
    Key? key,
    double? width,
    double? height,
  }) {
    return AppShimmer(
      key: key,
      child: Container(
        width: width,
        height: height ?? 120,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }

  /// Creates a column of shimmer rectangle placeholders.
  factory AppShimmer.list({
    Key? key,
    int itemCount = 3,
    double itemHeight = 72,
  }) {
    return AppShimmer(
      key: key,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index < itemCount - 1 ? AppSpacing.md : 0,
            ),
            child: Container(
              width: double.infinity,
              height: itemHeight,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Creates a circular shimmer placeholder.
  factory AppShimmer.circle({
    Key? key,
    double size = 48,
  }) {
    return AppShimmer(
      key: key,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.shimmerBase,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: child,
    );
  }
}
