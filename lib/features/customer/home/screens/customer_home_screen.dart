import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_section_header.dart';
import 'package:clean_ride/core/widgets/app_badge.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:clean_ride/data/mock/mock_services.dart';
import 'package:clean_ride/data/mock/mock_bookings.dart';
import 'package:clean_ride/features/customer/home/widgets/promo_carousel.dart';
import 'package:clean_ride/features/customer/home/widgets/quick_book_card.dart';
import 'package:clean_ride/features/customer/home/widgets/service_grid.dart';
import 'package:gap/gap.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

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
            title: Row(
              children: [
                Icon(Icons.local_car_wash, color: AppColors.primary, size: 28),
                const Gap(8),
                Text(
                  'CleanRide',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            actions: [
              AppBadge(
                count: 3,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(AppSpacing.lg),
                  Text(
                    'Good morning, Alex 👋',
                    style: AppTypography.headlineMedium,
                  ),
                  const Gap(4),
                  Text(
                    'Your car deserves the best',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Gap(AppSpacing.xl)),
          const SliverToBoxAdapter(child: PromoCarousel()),
          const SliverToBoxAdapter(child: Gap(AppSpacing.xl)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: const QuickBookCard(),
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
              child: ServiceGrid(
                services: MockServices.packages.take(4).toList(),
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
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: MockBookings.bookings.take(3).length,
                separatorBuilder: (_, __) => const Gap(AppSpacing.md),
                itemBuilder: (context, index) {
                  final booking = MockBookings.bookings[index];
                  return GestureDetector(
                    onTap: () => context.push('/customer/bookings/${booking.id}'),
                    child: Container(
                      width: 220,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Premium Detail',
                            style: AppTypography.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(4),
                          Text(
                            booking.timeSlot,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                'Tesla Model 3',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const Spacer(),
                              AppStatusIndicator(
                                status: _mapStatus(booking.status.name),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

  AppStatus _mapStatus(String status) {
    switch (status) {
      case 'pending':
        return AppStatus.pending;
      case 'confirmed':
        return AppStatus.confirmed;
      case 'inProgress':
      case 'washerEnRoute':
        return AppStatus.inProgress;
      case 'completed':
        return AppStatus.completed;
      case 'cancelled':
        return AppStatus.cancelled;
      default:
        return AppStatus.pending;
    }
  }
}
