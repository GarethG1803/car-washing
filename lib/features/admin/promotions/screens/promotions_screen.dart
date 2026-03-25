import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_promotions.dart';
import 'package:gap/gap.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Promotions'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF0047B3)]),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Active Campaigns', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
                const Gap(4),
                Text('${MockPromotions.promotions.where((p) => p.isActive).length}', style: AppTypography.headlineLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Column(children: [
                  Text('Total Uses', style: AppTypography.labelSmall.copyWith(color: Colors.white70)),
                  Text('2,135', style: AppTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                ]),
              ),
            ]),
          ),
          const Gap(24),
          Text('All Promotions', style: AppTypography.titleMedium),
          const Gap(12),
          ...MockPromotions.promotions.map((promo) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: promo.discountType.name == 'percentage' ? AppColors.primary.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    promo.discountType.name == 'percentage' ? Icons.percent : Icons.attach_money,
                    color: promo.discountType.name == 'percentage' ? AppColors.primary : AppColors.success,
                  ),
                ),
                const Gap(12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(promo.title, style: AppTypography.titleMedium),
                  Text(promo.description, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ])),
                Switch(value: promo.isActive, onChanged: (_) {}, activeColor: AppColors.primary),
              ]),
              const Gap(12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  const Icon(Icons.code, size: 16, color: AppColors.textSecondary),
                  const Gap(8),
                  Text(promo.code, style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const Spacer(),
                  Text('${promo.currentUses}/${promo.maxUses} uses', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                ]),
              ),
              const Gap(8),
              Row(children: [
                Text(
                  promo.discountType.name == 'percentage' ? '${promo.discountValue.toStringAsFixed(0)}% off' : 'Rp ${NumberFormat('#,###').format(promo.discountValue.toInt())} off',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                ),
                const Spacer(),
                Text('Ends ${promo.endDate.month}/${promo.endDate.day}/${promo.endDate.year}', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
              ]),
            ]),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, backgroundColor: AppColors.primary, child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}
