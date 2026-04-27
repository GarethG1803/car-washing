import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:clean_ride/data/providers/orders_provider.dart';
import 'package:clean_ride/features/customer/orders/widgets/order_card.dart';
import 'package:gap/gap.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen>
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
    final ordersAsync = ref.watch(customerOrdersProvider);

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
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.error),
              const Gap(12),
              Text('Failed to load bookings',
                  style: AppTypography.titleMedium),
              const Gap(16),
              TextButton(
                onPressed: () => ref.invalidate(customerOrdersProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (orders) => TabBarView(
          controller: _tabController,
          children: [
            _buildList(
              orders
                  .where((b) =>
                      b.status == BookingStatus.pending ||
                      b.status == BookingStatus.confirmed)
                  .toList(),
            ),
            _buildList(
              orders
                  .where((b) =>
                      b.status == BookingStatus.inProgress ||
                      b.status == BookingStatus.washerEnRoute)
                  .toList(),
            ),
            _buildList(
              orders
                  .where((b) =>
                      b.status == BookingStatus.completed ||
                      b.status == BookingStatus.cancelled)
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 64,
                color: AppColors.textSecondary.withValues(alpha: 0.3)),
            const Gap(16),
            Text('No bookings yet',
                style: AppTypography.titleMedium
                    .copyWith(color: AppColors.textSecondary)),
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
