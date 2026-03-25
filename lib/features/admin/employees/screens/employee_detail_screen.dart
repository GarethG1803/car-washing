import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_washers.dart';
import 'package:gap/gap.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final String employeeId;
  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    final washer = MockWashers.profiles.firstWhere((w) => w.id == employeeId, orElse: () => MockWashers.profiles.first);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 200, pinned: true, backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(background: Container(
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, Color(0xFF0047B3)])),
            child: SafeArea(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Gap(20),
              CircleAvatar(radius: 36, backgroundImage: washer.avatarUrl != null ? NetworkImage(washer.avatarUrl!) : null, backgroundColor: Colors.white24, child: washer.avatarUrl == null ? Text(washer.name.split(' ').map((x) => x[0]).take(2).join(), style: AppTypography.headlineMedium.copyWith(color: Colors.white)) : null),
              const Gap(8),
              Text(washer.name, style: AppTypography.titleLarge.copyWith(color: Colors.white)),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const Gap(4),
                Text('${washer.rating} rating', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
              ]),
            ])),
          )),
        ),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Column(children: [
          Row(children: [
            _stat('Total Jobs', '${washer.totalJobs}'),
            const Gap(12),
            _stat('Completed', '${washer.completedJobs}'),
            const Gap(12),
            _stat('Earnings', 'Rp ${NumberFormat('#,###').format(washer.earnings.toInt())}'),
          ]),
          const Gap(16),
          _card('Contact', [
            _infoRow(Icons.phone, washer.phone),
            _infoRow(Icons.email, 'marcus@email.com'),
          ]),
          const Gap(16),
          _card('Specialties', [
            Wrap(spacing: 8, runSpacing: 8, children: washer.specialties.map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
              child: Text(s, style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
            )).toList()),
          ]),
          const Gap(16),
          _card('Documents', [
            _docRow('ID Verification', true),
            _docRow('Driver\'s License', true),
            _docRow('Background Check', true),
            _docRow('Insurance', washer.documentsVerified),
          ]),
          const Gap(16),
          _card('Performance', [
            _perfRow('Completion Rate', '${(washer.completedJobs / washer.totalJobs * 100).toStringAsFixed(1)}%'),
            _perfRow('Avg Rating', '${washer.rating}'),
            _perfRow('On-time Rate', '95.2%'),
            _perfRow('Customer Satisfaction', '98%'),
          ]),
          const Gap(24),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd))), child: const Text('Deactivate'))),
            const Gap(12),
            Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd))), child: const Text('Edit Profile'))),
          ]),
          const Gap(32),
        ]))),
      ]),
    );
  }

  Widget _stat(String label, String value) => Expanded(child: Container(
    padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
    child: Column(children: [Text(value, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)), const Gap(4), Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary))]),
  ));

  Widget _card(String title, List<Widget> children) => Container(
    width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: AppTypography.titleMedium), const Gap(12), ...children]),
  );

  Widget _infoRow(IconData icon, String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Icon(icon, size: 18, color: AppColors.textSecondary), const Gap(12), Text(text, style: AppTypography.bodyMedium)]));

  Widget _docRow(String name, bool verified) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
    Icon(verified ? Icons.check_circle : Icons.pending, size: 18, color: verified ? AppColors.success : AppColors.warning), const Gap(12), Expanded(child: Text(name, style: AppTypography.bodyMedium)),
    Text(verified ? 'Verified' : 'Pending', style: AppTypography.labelSmall.copyWith(color: verified ? AppColors.success : AppColors.warning)),
  ]));

  Widget _perfRow(String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)), Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600))]));
}
