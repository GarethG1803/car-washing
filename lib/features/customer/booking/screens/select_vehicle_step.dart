import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_vehicles.dart';
import 'package:clean_ride/features/customer/booking/widgets/vehicle_selector.dart';
import 'package:gap/gap.dart';

class SelectVehicleStep extends StatefulWidget {
  const SelectVehicleStep({super.key});

  @override
  State<SelectVehicleStep> createState() => _SelectVehicleStepState();
}

class _SelectVehicleStepState extends State<SelectVehicleStep> {
  String _selectedVehicleId = MockVehicles.vehicles.first.id;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Your Vehicle', style: AppTypography.titleLarge),
          const Gap(4),
          Text(
            'Choose the vehicle you want washed',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const Gap(24),
          ...MockVehicles.vehicles.map(
            (vehicle) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: VehicleSelector(
                vehicle: vehicle,
                isSelected: vehicle.id == _selectedVehicleId,
                onTap: () => setState(() => _selectedVehicleId = vehicle.id),
              ),
            ),
          ),
          const Gap(16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add New Vehicle'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
