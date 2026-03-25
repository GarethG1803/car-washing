import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/features/customer/payments/widgets/payment_card_tile.dart';
import 'package:gap/gap.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Payment Methods'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const PaymentCardTile(brand: 'Visa', last4: '4242', isDefault: true),
          const Gap(12),
          const PaymentCardTile(brand: 'Mastercard', last4: '8888'),
          const Gap(24),
          GestureDetector(
            onTap: () => context.push('/customer/payments/wallet'),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
              child: Row(
                children: [
                  Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.account_balance_wallet, color: AppColors.primary)),
                  const Gap(16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('CleanRide Wallet', style: AppTypography.titleMedium), Text('Balance: Rp 375.000', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary))])),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          const Gap(24),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Payment Method'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd))),
          ),
        ],
      ),
    );
  }
}
