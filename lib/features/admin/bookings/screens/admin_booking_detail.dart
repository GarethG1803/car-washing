import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:gap/gap.dart';

class AdminBookingDetail extends StatelessWidget {
  final String bookingId;
  const AdminBookingDetail({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Booking #$bookingId'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _card([
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Booking #$bookingId', style: AppTypography.titleLarge),
              const AppStatusIndicator(status: AppStatus.confirmed),
            ]),
            const Gap(12),
            _info('Service', 'Standard Wash'),
            _info('Date', 'Feb 12, 2026 • 10:00 AM'),
            _info('Amount', 'Rp 150.000'),
          ]),
          const Gap(16),
          _card([
            Text('Customer', style: AppTypography.titleMedium),
            const Gap(12),
            Row(children: [
              const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&fit=crop')),
              const Gap(12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Alex Johnson', style: AppTypography.bodyLarge),
                Text('alex@email.com • +1 555-0101', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ]),
            ]),
          ]),
          const Gap(16),
          _card([
            Text('Washer', style: AppTypography.titleMedium),
            const Gap(12),
            Row(children: [
              const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&fit=crop')),
              const Gap(12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Marcus Rivera', style: AppTypography.bodyLarge),
                Row(children: [const Icon(Icons.star, size: 14, color: Colors.amber), const Gap(4), Text('4.9', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary))]),
              ]),
            ]),
          ]),
          const Gap(16),
          _card([
            Text('Vehicle', style: AppTypography.titleMedium),
            const Gap(8),
            _info('Car', '2021 Tesla Model 3'),
            _info('Color', 'White'),
            _info('Plate', 'ABC 1234'),
          ]),
          const Gap(16),
          _card([
            Text('Location', style: AppTypography.titleMedium),
            const Gap(8),
            Row(children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
              const Gap(8),
              Expanded(child: Text('123 Oak Street, Apt 4B, Austin, TX 78701', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary))),
            ]),
          ]),
          const Gap(24),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd))),
              child: const Text('Cancel Booking'),
            )),
            const Gap(12),
            Expanded(child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd))),
              child: const Text('Reassign Washer'),
            )),
          ]),
        ]),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTypography.bodyMedium),
      ]),
    );
  }
}
