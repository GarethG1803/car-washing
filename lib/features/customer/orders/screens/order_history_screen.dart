import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:clean_ride/data/mock/mock_bookings.dart';
import 'package:clean_ride/features/customer/orders/widgets/order_card.dart';
import 'package:gap/gap.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('My Bookings'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Active'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(MockBookings.bookings.where((b) =>
            b.status.name == 'pending' || b.status.name == 'confirmed').toList()),
          _buildList(MockBookings.bookings.where((b) =>
            b.status.name == 'inProgress' || b.status.name == 'washerEnRoute').toList()),
          _buildList(MockBookings.bookings.where((b) =>
            b.status.name == 'completed' || b.status.name == 'cancelled').toList()),
        ],
      ),
    );
  }

  Widget _buildList(List bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textSecondary.withOpacity(0.3)),
            const Gap(16),
            Text('No bookings yet', style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const Gap(12),
      itemBuilder: (context, index) {
        return OrderCard(
          booking: bookings[index],
          onTap: () => context.push('/customer/bookings/${bookings[index].id}'),
        );
      },
    );
  }
}
