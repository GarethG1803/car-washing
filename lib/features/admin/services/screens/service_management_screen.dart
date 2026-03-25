import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_services.dart';
import 'package:gap/gap.dart';

class ServiceManagementScreen extends StatelessWidget {
  const ServiceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Services & Pricing'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        Text('Wash Packages', style: AppTypography.titleMedium),
        const Gap(12),
        ...MockServices.packages.map((s) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
          child: Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.local_car_wash, color: AppColors.primary)),
            const Gap(12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(s.name, style: AppTypography.titleMedium),
                if (s.isPopular) ...[const Gap(8), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)), child: Text('Popular', style: AppTypography.labelSmall.copyWith(color: Colors.white, fontSize: 9)))],
              ]),
              Text('${s.duration} min • ${s.category.name}', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ])),
            Text('Rp ${NumberFormat('#,###').format(s.price.toInt())}', style: AppTypography.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            const Gap(8),
            PopupMenuButton(icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20), itemBuilder: (_) => [const PopupMenuItem(value: 'edit', child: Text('Edit')), const PopupMenuItem(value: 'disable', child: Text('Disable'))]),
          ]),
        )),
        const Gap(16),
        Text('Add-ons', style: AppTypography.titleMedium),
        const Gap(12),
        ...MockServices.addons.map((a) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
          child: Row(children: [Expanded(child: Text(a.name, style: AppTypography.bodyLarge)), Text('Rp ${NumberFormat('#,###').format(a.price.toInt())}', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary)), const Gap(8), const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary)]),
        )),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: () {}, backgroundColor: AppColors.primary, child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}
