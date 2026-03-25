import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class SelectAddressStep extends StatefulWidget {
  const SelectAddressStep({super.key});

  @override
  State<SelectAddressStep> createState() => _SelectAddressStepState();
}

class _SelectAddressStepState extends State<SelectAddressStep> {
  int _selectedAddress = 0;
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  final _savedAddresses = const [
    {'label': 'Home', 'address': '123 Oak Street, Apt 4B, Austin, TX 78701', 'icon': Icons.home},
    {'label': 'Office', 'address': '456 Tech Drive, Suite 200, Austin, TX 78702', 'icon': Icons.business},
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service Address', style: AppTypography.titleLarge),
          const Gap(4),
          Text(
            'Where should we come?',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const Gap(24),
          Text('Saved Addresses', style: AppTypography.titleMedium),
          const Gap(12),
          ...List.generate(_savedAddresses.length, (index) {
            final addr = _savedAddresses[index];
            final isSelected = _selectedAddress == index;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selectedAddress = index),
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
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryLight : AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          addr['icon'] as IconData,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              addr['label'] as String,
                              style: AppTypography.titleMedium,
                            ),
                            const Gap(2),
                            Text(
                              addr['address'] as String,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Gap(16),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 48, color: AppColors.primary.withOpacity(0.5)),
                  const Gap(8),
                  Text(
                    'Map Preview',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          const Gap(24),
          Text('Special Instructions', style: AppTypography.titleMedium),
          const Gap(8),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'e.g., Park in the driveway, ring the doorbell...',
              hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
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
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
