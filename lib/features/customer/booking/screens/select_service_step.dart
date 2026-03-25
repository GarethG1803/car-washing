import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_services.dart';
import 'package:gap/gap.dart';

class SelectServiceStep extends StatefulWidget {
  const SelectServiceStep({super.key});

  @override
  State<SelectServiceStep> createState() => _SelectServiceStepState();
}

class _SelectServiceStepState extends State<SelectServiceStep> {
  String _selectedServiceId = MockServices.packages.first.id;
  final Set<String> _selectedAddons = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Service', style: AppTypography.titleLarge),
          const Gap(4),
          Text(
            'Choose your wash package',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const Gap(20),
          ...MockServices.packages.map((service) {
            final isSelected = service.id == _selectedServiceId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selectedServiceId = service.id),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.divider,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : null,
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(service.name, style: AppTypography.titleMedium),
                                if (service.isPopular) ...[
                                  const Gap(8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Popular',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: Colors.white,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const Gap(4),
                            Text(
                              '${service.duration} min • ${service.features.length} services included',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Rp ${NumberFormat('#,###').format(service.price.toInt())}',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Gap(24),
          Text('Add-ons (Optional)', style: AppTypography.titleMedium),
          const Gap(12),
          ...MockServices.addons.map((addon) {
            final isSelected = _selectedAddons.contains(addon.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedAddons.remove(addon.id);
                    } else {
                      _selectedAddons.add(addon.id);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        size: 22,
                      ),
                      const Gap(12),
                      Expanded(
                        child: Text(addon.name, style: AppTypography.bodyLarge),
                      ),
                      Text(
                        '+Rp ${NumberFormat('#,###').format(addon.price.toInt())}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
