import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class CustomerCrmDetail extends StatelessWidget {
  final String customerId;
  const CustomerCrmDetail({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 180, pinned: true, backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, Color(0xFF0047B3)])),
              child: SafeArea(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Gap(20),
                const CircleAvatar(radius: 36, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&fit=crop')),
                const Gap(8),
                Text('Alex Johnson', style: AppTypography.titleLarge.copyWith(color: Colors.white)),
                Text('alex@email.com', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
              ])),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              _stat('Total Spent', 'Rp 2.100.000'),
              const Gap(12),
              _stat('Bookings', '12'),
              const Gap(12),
              _stat('Since', 'Jan 2025'),
            ]),
            const Gap(24),
            _section('Contact Info', [
              _infoRow(Icons.email_outlined, 'alex@email.com'),
              _infoRow(Icons.phone_outlined, '+1 555-0101'),
              _infoRow(Icons.location_on_outlined, '123 Oak Street, Austin, TX'),
            ]),
            const Gap(16),
            _section('Vehicles', [
              _vehicleRow('2021 Tesla Model 3', 'White • ABC 1234'),
              _vehicleRow('2023 BMW X5', 'Black • XYZ 5678'),
            ]),
            const Gap(16),
            _section('Recent Bookings', [
              _bookingRow('#1247', 'Standard Wash', 'Feb 10', 'Rp 150.000', 'Completed'),
              _bookingRow('#1230', 'Premium Detail', 'Feb 3', 'Rp 500.000', 'Completed'),
              _bookingRow('#1215', 'Quick Wash', 'Jan 28', 'Rp 75.000', 'Completed'),
            ]),
            const Gap(16),
            _section('Notes', [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                child: Text('VIP customer. Prefers morning slots. Tesla owner.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ),
            ]),
            const Gap(32),
          ])),
        ),
      ]),
    );
  }

  Widget _stat(String label, String value) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
      child: Column(children: [
        Text(value, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
        const Gap(4),
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
      ]),
    ));
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: AppTypography.titleMedium), const Gap(12), ...children]),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Icon(icon, size: 18, color: AppColors.textSecondary), const Gap(12), Text(text, style: AppTypography.bodyMedium)]));
  }

  Widget _vehicleRow(String name, String detail) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [const Icon(Icons.directions_car, size: 18, color: AppColors.textSecondary), const Gap(12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: AppTypography.bodyMedium), Text(detail, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary))])]));
  }

  Widget _bookingRow(String id, String service, String date, String amount, String status) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
      Text(id, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
      const Gap(8), Expanded(child: Text(service, style: AppTypography.bodyMedium)),
      Text(date, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
      const Gap(8), Text(amount, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
    ]));
  }
}
