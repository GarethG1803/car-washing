import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_vehicles.dart';
import 'package:clean_ride/features/customer/profile/widgets/vehicle_card.dart';
import 'package:gap/gap.dart';

class VehicleManagementScreen extends StatelessWidget {
  const VehicleManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Vehicles'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          ...MockVehicles.vehicles.map((v) => Padding(padding: const EdgeInsets.only(bottom: 12), child: VehicleCard(vehicle: v))),
          const Gap(16),
          OutlinedButton.icon(
            onPressed: () => context.push('/customer/profile/vehicles/add'),
            icon: const Icon(Icons.add),
            label: const Text('Add Vehicle'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd))),
          ),
        ],
      ),
    );
  }
}
