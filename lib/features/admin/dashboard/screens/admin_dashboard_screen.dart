import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_stat_card.dart';
import 'package:clean_ride/data/mock/mock_analytics.dart';
import 'package:clean_ride/features/admin/dashboard/widgets/kpi_row.dart';
import 'package:clean_ride/features/admin/dashboard/widgets/revenue_chart.dart';
import 'package:clean_ride/features/admin/dashboard/widgets/bookings_chart.dart';
import 'package:clean_ride/features/admin/dashboard/widgets/recent_activity_list.dart';
import 'package:clean_ride/core/widgets/app_section_header.dart';
import 'package:gap/gap.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: Row(
              children: [
                Icon(Icons.local_car_wash, color: AppColors.primary, size: 28),
                const Gap(8),
                Text('CleanRide', style: AppTypography.headlineMedium.copyWith(color: AppColors.primary)),
              ],
            ),
            actions: [
              IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
              const Gap(8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dashboard', style: AppTypography.headlineMedium),
                  const Gap(4),
                  Text('Business overview', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  const Gap(24),
                  const KpiRow(),
                  const Gap(24),
                  const AppSectionHeader(title: 'Revenue'),
                  const RevenueChart(),
                  const Gap(24),
                  const AppSectionHeader(title: 'Weekly Bookings'),
                  const BookingsChart(),
                  const Gap(24),
                  const AppSectionHeader(title: 'Recent Activity'),
                  const RecentActivityList(),
                  const Gap(32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
