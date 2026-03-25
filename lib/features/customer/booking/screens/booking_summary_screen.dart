import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking Summary', style: AppTypography.titleLarge),
          const Gap(4),
          Text(
            'Review your booking details',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const Gap(24),
          _buildSection('Vehicle', [
            _buildRow('Car', '2021 Tesla Model 3'),
            _buildRow('Color', 'White'),
            _buildRow('Plate', 'ABC 1234'),
          ]),
          const Gap(16),
          _buildSection('Service', [
            _buildRow('Package', 'Standard Wash'),
            _buildRow('Duration', '60 min'),
            _buildRow('Add-ons', 'Pet Hair Removal'),
          ]),
          const Gap(16),
          _buildSection('Schedule', [
            _buildRow('Date', 'Tomorrow, Feb 12'),
            _buildRow('Time', '10:00 AM'),
          ]),
          const Gap(16),
          _buildSection('Location', [
            _buildRow('Address', '123 Oak Street, Apt 4B'),
            _buildRow('City', 'Austin, TX 78701'),
          ]),
          const Gap(24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                _buildPriceRow('Standard Wash', 'Rp 150.000'),
                const Gap(8),
                _buildPriceRow('Pet Hair Removal', 'Rp 50.000'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.divider),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: AppTypography.titleMedium),
                    Text(
                      'Rp 200.000',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer, color: AppColors.primary, size: 20),
                const Gap(8),
                Expanded(
                  child: Text(
                    'Have a promo code?',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
                  ),
                ),
                Text(
                  'Apply',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> rows) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleMedium),
          const Gap(12),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        Text(price, style: AppTypography.bodyMedium),
      ],
    );
  }
}
