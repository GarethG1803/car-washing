import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:gap/gap.dart';

class StatusTimeline extends StatelessWidget {
  final String currentStatus;
  const StatusTimeline({super.key, required this.currentStatus});

  static const _steps = [
    ('pending', 'Booking Received'),
    ('confirmed', 'Booking Confirmed'),
    ('on_the_way', 'Washer En Route'),
    ('in_progress', 'Wash In Progress'),
    ('done', 'Completed'),
  ];

  int get _currentIndex {
    for (var i = 0; i < _steps.length; i++) {
      if (_steps[i].$1 == currentStatus) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentIndex;
    return Column(
      children: List.generate(_steps.length, (index) {
        final isDone = index <= current;
        final isCurrent = index == current;
        final isLast = index == _steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? (isCurrent ? AppColors.primary : AppColors.success)
                        : AppColors.divider,
                  ),
                  child: isDone
                      ? Icon(
                          isCurrent ? Icons.near_me : Icons.check,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isDone ? AppColors.success : AppColors.divider,
                  ),
              ],
            ),
            const Gap(16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  _steps[index].$2,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight:
                        isDone ? FontWeight.w600 : FontWeight.w400,
                    color: isDone
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
