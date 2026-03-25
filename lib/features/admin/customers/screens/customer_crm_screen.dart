import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_users.dart';
import 'package:gap/gap.dart';

class CustomerCrmScreen extends StatelessWidget {
  const CustomerCrmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Customers'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search customers...',
              hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              filled: true, fillColor: AppColors.background,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(children: [
            _segmentChip('All (${MockUsers.customers.length})', true),
            const Gap(8),
            _segmentChip('Active', false),
            const Gap(8),
            _segmentChip('VIP', false),
            const Gap(8),
            _segmentChip('New', false),
          ]),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: MockUsers.customers.length,
            separatorBuilder: (_, __) => const Gap(8),
            itemBuilder: (context, index) {
              final customer = MockUsers.customers[index];
              return GestureDetector(
                onTap: () => context.push('/admin/customers/${customer.id}'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
                  child: Row(children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage: customer.avatarUrl != null ? NetworkImage(customer.avatarUrl!) : null,
                      child: customer.avatarUrl == null ? Text(customer.name.split(' ').map((w) => w[0]).take(2).join(), style: AppTypography.labelLarge.copyWith(color: AppColors.primary)) : null,
                    ),
                    const Gap(12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(customer.name, style: AppTypography.titleMedium),
                      Text(customer.email, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ])),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('5 bookings', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                      const Gap(4),
                      Text('Rp 850.000', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ]),
                    const Gap(8),
                    const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget _segmentChip(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryLight : AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
      ),
      child: Text(label, style: AppTypography.labelSmall.copyWith(color: selected ? AppColors.primary : AppColors.textSecondary)),
    );
  }
}
