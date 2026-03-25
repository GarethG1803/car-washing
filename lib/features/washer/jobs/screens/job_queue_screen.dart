import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/features/washer/jobs/widgets/job_card.dart';
import 'package:gap/gap.dart';

class JobQueueScreen extends StatefulWidget {
  const JobQueueScreen({super.key});

  @override
  State<JobQueueScreen> createState() => _JobQueueScreenState();
}

class _JobQueueScreenState extends State<JobQueueScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Jobs',
          style: AppTypography.titleLarge,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: AppTypography.labelLarge,
          unselectedLabelStyle: AppTypography.bodyMedium,
          tabs: [
            Tab(child: _buildTabLabel('Incoming', 2)),
            Tab(child: _buildTabLabel('Active', 1)),
            Tab(child: _buildTabLabel('Completed', 4)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildIncomingTab(),
          _buildActiveTab(),
          _buildCompletedTab(),
        ],
      ),
    );
  }

  Widget _buildTabLabel(String label, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const Gap(6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomingTab() {
    final incomingJobs = [
      JobCardData(
        id: 'b1',
        bookingId: 'BK-1001',
        serviceName: 'Standard Wash',
        customerName: 'Alex Johnson',
        vehicleInfo: 'Tesla Model 3 - White',
        timeSlot: '10:00 AM - 11:00 AM',
        address: '123 Oak Street, Apt 4B',
        price: 70.98,
        status: 'pending',
        rating: null,
      ),
      JobCardData(
        id: 'b2',
        bookingId: 'BK-1002',
        serviceName: 'Quick Wash',
        customerName: 'Emily Davis',
        vehicleInfo: 'Honda Civic - Silver',
        timeSlot: '2:00 PM - 2:30 PM',
        address: '456 Maple Avenue, Suite 12',
        price: 29.99,
        status: 'pending',
        rating: null,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: incomingJobs.length,
      separatorBuilder: (_, __) => const Gap(AppSpacing.md),
      itemBuilder: (context, index) {
        final job = incomingJobs[index];
        return JobCard(
          data: job,
          onTap: () => context.push('/washer/jobs/${job.id}'),
          trailing: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  child: const Text('Decline'),
                ),
              ),
              const Gap(AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActiveTab() {
    final activeJobs = [
      JobCardData(
        id: 'b6',
        bookingId: 'BK-1006',
        serviceName: 'Full Detail Package',
        customerName: 'Alex Johnson',
        vehicleInfo: 'Tesla Model 3 - White',
        timeSlot: '9:00 AM - 12:00 PM',
        address: '123 Oak Street, Apt 4B',
        price: 199.99,
        status: 'inProgress',
        rating: null,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: activeJobs.length,
      separatorBuilder: (_, __) => const Gap(AppSpacing.md),
      itemBuilder: (context, index) {
        final job = activeJobs[index];
        return JobCard(
          data: job,
          onTap: () => context.push('/washer/jobs/${job.id}'),
        );
      },
    );
  }

  Widget _buildCompletedTab() {
    final completedJobs = [
      JobCardData(
        id: 'b8',
        bookingId: 'BK-1008',
        serviceName: 'Standard Wash',
        customerName: 'Alex Johnson',
        vehicleInfo: 'Tesla Model 3 - White',
        timeSlot: '2:00 PM - 3:00 PM',
        address: '123 Oak Street, Apt 4B',
        price: 49.99,
        status: 'completed',
        rating: 5.0,
      ),
      JobCardData(
        id: 'b9',
        bookingId: 'BK-1009',
        serviceName: 'Premium Detail',
        customerName: 'Sarah Chen',
        vehicleInfo: 'BMW X5 - Black',
        timeSlot: '11:00 AM - 1:00 PM',
        address: '234 Cedar Street, Penthouse',
        price: 114.98,
        status: 'completed',
        rating: 4.5,
      ),
      JobCardData(
        id: 'b10',
        bookingId: 'BK-1010',
        serviceName: 'Quick Wash',
        customerName: 'David Park',
        vehicleInfo: 'Toyota Camry - Blue',
        timeSlot: '9:00 AM - 9:30 AM',
        address: '678 Spruce Way, Building C',
        price: 29.99,
        status: 'completed',
        rating: 5.0,
      ),
      JobCardData(
        id: 'b11',
        bookingId: 'BK-1011',
        serviceName: 'Standard Wash',
        customerName: 'Lisa Nguyen',
        vehicleInfo: 'Audi A4 - Gray',
        timeSlot: '4:00 PM - 5:00 PM',
        address: '912 Aspen Circle, Apt 10',
        price: 62.98,
        status: 'completed',
        rating: 4.0,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: completedJobs.length,
      separatorBuilder: (_, __) => const Gap(AppSpacing.md),
      itemBuilder: (context, index) {
        final job = completedJobs[index];
        return JobCard(
          data: job,
          onTap: () => context.push('/washer/jobs/${job.id}'),
        );
      },
    );
  }
}
