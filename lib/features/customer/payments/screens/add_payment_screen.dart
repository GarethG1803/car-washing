import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class AddPaymentScreen extends StatelessWidget {
  const AddPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Add Card'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF1A1D26), Color(0xFF374151)]), borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Credit Card', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)), const Icon(Icons.credit_card, color: Colors.white70)]),
              Text('•••• •••• •••• ••••', style: AppTypography.headlineMedium.copyWith(color: Colors.white, letterSpacing: 4)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('CARD HOLDER', style: AppTypography.labelSmall.copyWith(color: Colors.white54)), Text('EXPIRES', style: AppTypography.labelSmall.copyWith(color: Colors.white54))]),
            ]),
          ),
          const Gap(32),
          _field('Card Number', 'XXXX XXXX XXXX XXXX', Icons.credit_card),
          const Gap(16),
          _field('Card Holder Name', 'Full name on card', Icons.person_outline),
          const Gap(16),
          Row(children: [Expanded(child: _field('Expiry Date', 'MM/YY', Icons.calendar_today)), const Gap(16), Expanded(child: _field('CVV', '•••', Icons.lock_outline))]),
          const Gap(32),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd))),
            child: const Text('Add Card'),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, String hint, IconData icon) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.labelLarge),
      const Gap(8),
      TextField(decoration: InputDecoration(hintText: hint, hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary), prefixIcon: Icon(icon, color: AppColors.textSecondary), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd), borderSide: const BorderSide(color: AppColors.divider)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd), borderSide: const BorderSide(color: AppColors.divider)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd), borderSide: const BorderSide(color: AppColors.primary)))),
    ]);
  }
}
