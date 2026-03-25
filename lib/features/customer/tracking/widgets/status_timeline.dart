import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:gap/gap.dart';

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'Booking Confirmed', 'subtitle': '10:30 AM', 'done': true},
      {'title': 'Washer Assigned', 'subtitle': '10:32 AM', 'done': true},
      {'title': 'Washer En Route', 'subtitle': '10:45 AM', 'done': true},
      {'title': 'Wash In Progress', 'subtitle': 'Arriving soon...', 'done': false},
      {'title': 'Completed', 'subtitle': '', 'done': false},
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isDone = step['done'] as bool;
        final isLast = index == steps.length - 1;
        final isCurrent = isDone && index < steps.length - 1 && !(steps[index + 1]['done'] as bool);

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
                        color: isDone ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                    if ((step['subtitle'] as String).isNotEmpty)
                      Text(
                        step['subtitle'] as String,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
