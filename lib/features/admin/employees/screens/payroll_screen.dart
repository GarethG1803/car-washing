import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_washers.dart';
import 'package:gap/gap.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Payroll'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF0047B3)]), borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Total Payroll', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
                const Gap(4),
                Text('Rp 187.200.000', style: AppTypography.headlineLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                const Gap(4),
                Text('This Month', style: AppTypography.labelSmall.copyWith(color: Colors.white54)),
              ])),
              Column(children: [
                _miniStat('Paid', 'Rp 123.600.000'),
                const Gap(8),
                _miniStat('Pending', 'Rp 63.600.000'),
              ]),
            ]),
          ),
          const Gap(24),
          Text('Team Payouts', style: AppTypography.titleMedium),
          const Gap(12),
          ...MockWashers.profiles.map((w) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
            child: Row(children: [
              CircleAvatar(radius: 22, backgroundColor: AppColors.primaryLight, child: Text(w.name.split(' ').map((x) => x[0]).take(2).join(), style: AppTypography.labelLarge.copyWith(color: AppColors.primary))),
              const Gap(12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(w.name, style: AppTypography.titleMedium),
                Text('${w.completedJobs} jobs completed', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('Rp ${NumberFormat('#,###').format(w.earnings.toInt())}', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                const Gap(2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('Paid', style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontSize: 10)),
                ),
              ]),
            ]),
          )),
        ]),
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
      child: Column(children: [Text(value, style: AppTypography.labelLarge.copyWith(color: Colors.white)), Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white70, fontSize: 10))]),
    );
  }
}
