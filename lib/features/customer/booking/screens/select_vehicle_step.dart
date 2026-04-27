import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/booking_state_provider.dart';
import 'package:gap/gap.dart';

class SelectVehicleStep extends ConsumerStatefulWidget {
  const SelectVehicleStep({super.key});

  @override
  ConsumerState<SelectVehicleStep> createState() => _SelectVehicleStepState();
}

class _SelectVehicleStepState extends ConsumerState<SelectVehicleStep> {
  final _plateController = TextEditingController();
  String _vehicleType = 'sedan';

  static const _vehicleTypes = [
    ('sedan', Icons.directions_car, 'Sedan'),
    ('suv', Icons.directions_car_filled, 'SUV'),
    ('truck', Icons.local_shipping, 'Truck'),
    ('motorcycle', Icons.two_wheeler, 'Motorcycle'),
  ];

  @override
  void initState() {
    super.initState();
    final current = ref.read(bookingStateProvider);
    _plateController.text = current.vehiclePlate;
    _vehicleType = current.vehicleType;
    _plateController.addListener(_sync);
  }

  void _sync() {
    ref.read(bookingStateProvider.notifier).setVehicle(
          _plateController.text.trim(),
          _vehicleType,
        );
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Vehicle', style: AppTypography.titleLarge),
          const Gap(4),
          Text(
            'Enter your vehicle details',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const Gap(28),
          Text('Vehicle Plate', style: AppTypography.titleMedium),
          const Gap(10),
          TextField(
            controller: _plateController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'e.g., B 1234 ABC',
              hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              prefixIcon: const Icon(Icons.pin, color: AppColors.textSecondary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const Gap(28),
          Text('Vehicle Type', style: AppTypography.titleMedium),
          const Gap(12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: _vehicleTypes.map(((String key, IconData icon, String label) rec) {
              final isSelected = _vehicleType == rec.$1;
              return GestureDetector(
                onTap: () {
                  setState(() => _vehicleType = rec.$1);
                  _sync();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(rec.$2,
                          size: 22,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary),
                      const Gap(8),
                      Text(
                        rec.$3,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
