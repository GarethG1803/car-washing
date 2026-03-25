import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_section_header.dart';
import 'package:clean_ride/features/washer/dashboard/widgets/earnings_summary_card.dart';
import 'package:clean_ride/features/washer/dashboard/widgets/today_jobs_list.dart';
import 'package:gap/gap.dart';

class WasherDashboardScreen extends StatefulWidget {
  const WasherDashboardScreen({super.key});

  @override
  State<WasherDashboardScreen> createState() => _WasherDashboardScreenState();
}

class _WasherDashboardScreenState extends State<WasherDashboardScreen> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Dashboard',
              style: AppTypography.titleLarge,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.textPrimary,
                onPressed: () {},
              ),
              const Gap(8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(AppSpacing.lg),
                  // Greeting + Status Toggle
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Marcus',
                              style: AppTypography.headlineMedium,
                            ),
                            const Gap(4),
                            Text(
                              _isOnline
                                  ? 'You are currently online'
                                  : 'You are currently offline',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusToggle(),
                    ],
                  ),
                  const Gap(AppSpacing.xl),
                  // Earnings Summary Card
                  const EarningsSummaryCard(
                    todayEarnings: 185.50,
                    weekEarnings: 742.00,
                    monthEarnings: 2840.00,
                    trendPercentage: 12,
                  ),
                  const Gap(AppSpacing.xl),
                  // Today's Stats
                  Text(
                    "Today's Stats",
                    style: AppTypography.titleMedium,
                  ),
                  const Gap(AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMiniStatCard(
                          icon: Icons.work_outline,
                          label: 'Jobs',
                          value: '5',
                          color: AppColors.primary,
                        ),
                      ),
                      const Gap(AppSpacing.md),
                      Expanded(
                        child: _buildMiniStatCard(
                          icon: Icons.access_time,
                          label: 'Hours',
                          value: '6.5',
                          color: AppColors.warning,
                        ),
                      ),
                      const Gap(AppSpacing.md),
                      Expanded(
                        child: _buildMiniStatCard(
                          icon: Icons.star_rounded,
                          label: 'Rating',
                          value: '4.9',
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.xl),
                  // Today's Jobs
                  AppSectionHeader(
                    title: "Today's Jobs",
                    actionLabel: 'See all',
                    onAction: () {},
                  ),
                  TodayJobsList(
                    jobs: _mockTodayJobs,
                    onJobTap: (jobId) {
                      context.push('/washer/jobs/$jobId');
                    },
                  ),
                  const Gap(AppSpacing.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: _isOnline
            ? AppColors.success.withOpacity(0.1)
            : AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isOnline ? 'Online' : 'Offline',
            style: AppTypography.labelSmall.copyWith(
              color: _isOnline ? AppColors.success : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(4),
          SizedBox(
            height: 24,
            child: Switch(
              value: _isOnline,
              onChanged: (value) {
                setState(() {
                  _isOnline = value;
                });
              },
              activeColor: AppColors.success,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const Gap(AppSpacing.sm),
          Text(
            value,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(2),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  List<TodayJobData> get _mockTodayJobs => [
        TodayJobData(
          id: 'b3',
          time: '10:00 AM',
          serviceName: 'Premium Detail',
          customerName: 'Sarah Chen',
          address: '789 Elm Boulevard, Unit 7',
          status: 'confirmed',
        ),
        TodayJobData(
          id: 'b6',
          time: '1:00 PM',
          serviceName: 'Full Detail Package',
          customerName: 'Alex Johnson',
          address: '123 Oak Street, Apt 4B',
          status: 'inProgress',
        ),
        TodayJobData(
          id: 'b4',
          time: '3:00 PM',
          serviceName: 'Standard Wash',
          customerName: 'Mike Williams',
          address: '321 Pine Lane',
          status: 'pending',
        ),
      ];
}
