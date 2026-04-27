import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_chip.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:clean_ride/data/providers/admin_orders_provider.dart';
import 'package:gap/gap.dart';

class AdminBookingsScreen extends ConsumerStatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  ConsumerState<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends ConsumerState<AdminBookingsScreen> {
  int _selectedFilter = 0;
  String _search = '';
  final _filters = ['All', 'Pending', 'Active', 'Completed', 'Cancelled'];

  AppStatus _appStatus(BookingStatus s) {
    switch (s) {
      case BookingStatus.confirmed:
        return AppStatus.confirmed;
      case BookingStatus.washerEnRoute:
      case BookingStatus.inProgress:
        return AppStatus.inProgress;
      case BookingStatus.completed:
        return AppStatus.completed;
      case BookingStatus.cancelled:
        return AppStatus.cancelled;
      default:
        return AppStatus.pending;
    }
  }

  bool _matchesFilter(Booking b) {
    switch (_selectedFilter) {
      case 1:
        return b.status == BookingStatus.pending ||
            b.status == BookingStatus.confirmed;
      case 2:
        return b.status == BookingStatus.washerEnRoute ||
            b.status == BookingStatus.inProgress;
      case 3:
        return b.status == BookingStatus.completed;
      case 4:
        return b.status == BookingStatus.cancelled;
      default:
        return true;
    }
  }

  bool _matchesSearch(Booking b) {
    if (_search.isEmpty) return true;
    final q = _search.toLowerCase();
    return b.id.toLowerCase().contains(q) ||
        b.vehicleId.toLowerCase().contains(q) ||
        b.address.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(adminOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bookings'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => ref.invalidate(adminOrdersProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(children: [
              TextField(
                onChanged: (v) => setState(() => _search = v),
                decoration: InputDecoration(
                  hintText: 'Search by order ID, plate, address...',
                  hintStyle: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const Gap(12),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const Gap(8),
                  itemBuilder: (_, i) => AppChip(
                    label: _filters[i],
                    isSelected: _selectedFilter == i,
                    onTap: () => setState(() => _selectedFilter = i),
                  ),
                ),
              ),
            ]),
          ),
          Expanded(
            child: ordersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.error),
                      const Gap(12),
                      Text('Could not load bookings',
                          style: AppTypography.titleMedium),
                      const Gap(16),
                      TextButton(
                        onPressed: () => ref.invalidate(adminOrdersProvider),
                        child: const Text('Retry'),
                      ),
                    ]),
              ),
              data: (orders) {
                final filtered = orders
                    .where((b) => _matchesFilter(b) && _matchesSearch(b))
                    .toList()
                  ..sort(
                      (a, b) => b.scheduledDate.compareTo(a.scheduledDate));

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.inbox_outlined,
                              size: 48, color: AppColors.textSecondary),
                          const Gap(12),
                          Text('No bookings found',
                              style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary)),
                        ]),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Gap(12),
                  itemBuilder: (context, index) {
                    final booking = filtered[index];
                    final shortId = booking.id.length > 8
                        ? booking.id.substring(0, 8).toUpperCase()
                        : booking.id.toUpperCase();
                    return GestureDetector(
                      onTap: () =>
                          context.push('/admin/bookings/${booking.id}'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 10,
                                offset: Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text('#$shortId',
                                  style: AppTypography.titleMedium),
                              const Spacer(),
                              AppStatusIndicator(
                                  status: _appStatus(booking.status)),
                            ]),
                            const Gap(8),
                            Row(children: [
                              const Icon(Icons.directions_car_outlined,
                                  size: 16, color: AppColors.textSecondary),
                              const Gap(4),
                              Text(
                                booking.vehicleId.toUpperCase(),
                                style: AppTypography.bodyMedium
                                    .copyWith(color: AppColors.textSecondary),
                              ),
                              const Gap(16),
                              const Icon(Icons.calendar_today,
                                  size: 14, color: AppColors.textSecondary),
                              const Gap(4),
                              Text(
                                DateFormat('MMM dd, HH:mm')
                                    .format(booking.scheduledDate),
                                style: AppTypography.bodyMedium
                                    .copyWith(color: AppColors.textSecondary),
                              ),
                            ]),
                            const Gap(4),
                            Text(
                              booking.address,
                              style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
