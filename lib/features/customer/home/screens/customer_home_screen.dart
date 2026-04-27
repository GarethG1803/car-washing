import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_section_header.dart';
import 'package:clean_ride/core/widgets/app_badge.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:clean_ride/data/providers/services_provider.dart';
import 'package:clean_ride/data/providers/orders_provider.dart';
import 'package:clean_ride/features/auth/providers/auth_provider.dart';
import 'package:clean_ride/features/customer/home/widgets/service_grid.dart';
import 'package:gap/gap.dart';

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final servicesAsync = ref.watch(servicesProvider);
    final ordersAsync = ref.watch(customerOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Row(
              children: [
                const Icon(Icons.local_car_wash, color: AppColors.primary, size: 28),
                const Gap(8),
                Text('CleanRide',
                    style: AppTypography.headlineMedium.copyWith(color: AppColors.primary)),
              ],
            ),
            actions: [
              AppBadge(
                count: 0,
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  color: AppColors.textPrimary,
                  onPressed: () => context.push('/customer/notifications'),
                ),
              ),
              const Gap(8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Gap(AppSpacing.lg),
                Text('Hello, ${user?.name ?? 'there'}', style: AppTypography.headlineMedium),
                const Gap(4),
                Text('Your car deserves the best',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: Gap(AppSpacing.xl)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: GestureDetector(
                onTap: () => context.push('/customer/booking/flow'),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF0047B3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Book a Wash',
                              style: AppTypography.titleLarge
                                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                          const Gap(4),
                          Text('Schedule at your convenience',
                              style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
                          const Gap(12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            ),
                            child: Text('Book Now',
                                style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
                          ),
                        ]),
                      ),
                      const Icon(Icons.local_car_wash, size: 72, color: Colors.white24),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Gap(AppSpacing.xl)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppSectionHeader(
                title: 'Popular Services',
                actionLabel: 'See all',
                onAction: () => context.go('/customer/services'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: servicesAsync.when(
                loading: () => const SizedBox(
                    height: 160, child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const SizedBox(
                    height: 60,
                    child: Center(child: Text('Could not load services'))),
                data: (services) =>
                    ServiceGrid(services: services.take(4).toList()),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Gap(AppSpacing.xl)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppSectionHeader(
                title: 'Recent Bookings',
                actionLabel: 'See all',
                onAction: () => context.go('/customer/bookings'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 140,
              child: ordersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(child: Text('Could not load bookings')),
                data: (orders) {
                  if (orders.isEmpty) {
                    return Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.receipt_long_outlined,
                            size: 36, color: AppColors.textSecondary),
                        const Gap(8),
                        Text('No bookings yet',
                            style: AppTypography.bodyMedium
                                .copyWith(color: AppColors.textSecondary)),
                      ]),
                    );
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    itemCount: orders.take(5).length,
                    separatorBuilder: (_, __) => const Gap(AppSpacing.md),
                    itemBuilder: (context, index) {
                      final booking = orders[index];
                      return _BookingCard(
                        booking: booking,
                        onTap: () => context.push('/customer/bookings/${booking.id}'),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Gap(AppSpacing.xxxl)),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onTap;
  const _BookingCard({required this.booking, required this.onTap});

  AppStatus _map(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending: return AppStatus.pending;
      case BookingStatus.confirmed: return AppStatus.confirmed;
      case BookingStatus.washerEnRoute:
      case BookingStatus.inProgress: return AppStatus.inProgress;
      case BookingStatus.completed: return AppStatus.completed;
      case BookingStatus.cancelled: return AppStatus.cancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Order #${booking.id.length > 8 ? booking.id.substring(0, 8) : booking.id}',
            style: AppTypography.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(4),
          Text(
            DateFormat('MMM dd, HH:mm').format(booking.scheduledDate),
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const Spacer(),
          Row(children: [
            Expanded(
              child: Text(
                booking.vehicleId.isNotEmpty ? booking.vehicleId : 'No plate',
                style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Gap(8),
            AppStatusIndicator(status: _map(booking.status)),
          ]),
        ]),
      ),
    );
  }
}
