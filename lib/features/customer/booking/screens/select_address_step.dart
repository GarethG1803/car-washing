import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/booking_state_provider.dart';
import 'package:gap/gap.dart';

class SelectAddressStep extends ConsumerStatefulWidget {
  const SelectAddressStep({super.key});

  @override
  ConsumerState<SelectAddressStep> createState() => _SelectAddressStepState();
}

class _SelectAddressStepState extends ConsumerState<SelectAddressStep> {
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final current = ref.read(bookingStateProvider);
    _addressController.text = current.locationAddress;
    _notesController.text = current.notes ?? '';
    _addressController.addListener(_sync);
    _notesController.addListener(_sync);
  }

  void _sync() {
    ref.read(bookingStateProvider.notifier).setAddress(
          _addressController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint, {Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
      prefixIcon: prefix,
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
    );
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
          const Gap(28),
          Text('Address', style: AppTypography.titleMedium),
          const Gap(10),
          TextField(
            controller: _addressController,
            maxLines: 2,
            decoration: _inputDecoration(
              'Enter full address (street, city)',
              prefix: const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Icon(Icons.location_on_outlined, color: AppColors.textSecondary),
              ),
            ),
          ),
          const Gap(24),
          Text('Special Instructions', style: AppTypography.titleMedium),
          const Gap(10),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: _inputDecoration(
              'e.g., Park in the driveway, ring the doorbell...',
            ),
          ),
          const Gap(20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                const Gap(10),
                Expanded(
                  child: Text(
                    'Our washer will come to your location. Make sure the address is accessible.',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
