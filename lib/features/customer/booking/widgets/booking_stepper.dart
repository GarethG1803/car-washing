import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';

class BookingStepper extends StatelessWidget {
  final List<String> steps;
  final int currentStep;

  const BookingStepper({super.key, required this.steps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stepIndex = index ~/ 2;
          return Expanded(
            child: Container(
              height: 2,
              color: stepIndex < currentStep ? AppColors.primary : AppColors.divider,
            ),
          );
        }
        final stepIndex = index ~/ 2;
        final isActive = stepIndex <= currentStep;
        final isCurrent = stepIndex == currentStep;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.primary : AppColors.divider,
                border: isCurrent
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
              ),
              child: Center(
                child: stepIndex < currentStep
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Text(
                        '${stepIndex + 1}',
                        style: AppTypography.labelSmall.copyWith(
                          color: isActive ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              steps[stepIndex],
              style: AppTypography.labelSmall.copyWith(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontSize: 9,
              ),
            ),
          ],
        );
      }),
    );
  }
}
