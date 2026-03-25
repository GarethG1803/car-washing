import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class PaymentCardTile extends StatelessWidget {
  final String brand;
  final String last4;
  final bool isDefault;

  const PaymentCardTile({super.key, required this.brand, required this.last4, this.isDefault = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: brand == 'Visa' ? const Color(0xFF1A1F71) : const Color(0xFFEB001B), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(brand[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))),
          ),
          const Gap(16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$brand •••• $last4', style: AppTypography.titleMedium),
              Text('Expires 12/27', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ]),
          ),
          if (isDefault) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)), child: Text('Default', style: AppTypography.labelSmall.copyWith(color: AppColors.primary))),
        ],
      ),
    );
  }
}
