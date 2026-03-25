import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/models/vehicle.dart';
import 'package:gap/gap.dart';

class VehicleSelector extends StatelessWidget {
  final Vehicle vehicle;
  final bool isSelected;
  final VoidCallback? onTap;

  const VehicleSelector({
    super.key,
    required this.vehicle,
    this.isSelected = false,
    this.onTap,
  });

  IconData _vehicleIcon() {
    switch (vehicle.type) {
      case VehicleType.sedan:
      case VehicleType.coupe:
        return Icons.directions_car;
      case VehicleType.suv:
        return Icons.directions_car_filled;
      case VehicleType.truck:
        return Icons.local_shipping;
      case VehicleType.van:
        return Icons.airport_shuttle;
      case VehicleType.hatchback:
        return Icons.directions_car_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _vehicleIcon(),
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.year} ${vehicle.make} ${vehicle.model}',
                    style: AppTypography.titleMedium,
                  ),
                  const Gap(2),
                  Text(
                    '${vehicle.color} • ${vehicle.licensePlate}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (vehicle.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Default',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.check_circle, color: AppColors.primary),
              ),
          ],
        ),
      ),
    );
  }
}
