import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_analytics.dart';
import 'package:gap/gap.dart';

class KpiRow extends StatelessWidget {
  const KpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    final kpi = MockAnalytics.kpiData;
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _KpiCard(title: 'Revenue', value: 'Rp ${NumberFormat('#,###').format((kpi['totalRevenue'] as double).toInt())}', icon: Icons.attach_money, color: AppColors.primary, trend: '+12.5%')),
            const Gap(12),
            Expanded(child: _KpiCard(title: 'Bookings', value: '${kpi['totalBookings']}', icon: Icons.book_online, color: AppColors.success, trend: '+8.3%')),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(child: _KpiCard(title: 'Customers', value: '${kpi['activeCustomers']}', icon: Icons.people, color: AppColors.warning, trend: '+15.2%')),
            const Gap(12),
            Expanded(child: _KpiCard(title: 'Rating', value: '${kpi['averageRating']}', icon: Icons.star, color: Colors.amber, trend: '+0.2')),
          ],
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;

  const _KpiCard({required this.title, required this.value, required this.icon, required this.color, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.trending_up, size: 12, color: AppColors.success),
                  const Gap(2),
                  Text(trend, style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontSize: 10)),
                ]),
              ),
            ],
          ),
          const Gap(12),
          Text(value, style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold)),
          const Gap(2),
          Text(title, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
