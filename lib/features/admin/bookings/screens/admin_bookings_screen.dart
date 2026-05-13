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

/// Filter buckets the admin actually needs, in priority order.
enum _AdminFilter {
  needsAction, // pending (unassigned) + assigned (waiting for washer to accept)
  active,      // confirmed + on the way + in progress
  needsPayment,// done but unpaid
  done,        // done + paid
  cancelled,   // cancelled + no_show + failed
  all,
}

class AdminBookingsScreen extends ConsumerStatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  ConsumerState<AdminBookingsScreen> createState() =>
      _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends ConsumerState<AdminBookingsScreen> {
  /// Default to what admin needs to do right now.
  _AdminFilter _filter = _AdminFilter.needsAction;
  String _search = '';

  AppStatus _appStatus(Booking b) {
    if (b.needsPayment) return AppStatus.needsPayment;
    switch (b.status) {
      case BookingStatus.pending:
        return AppStatus.pending;
      case BookingStatus.assigned:
        return AppStatus.assigned;
      case BookingStatus.confirmed:
        return AppStatus.confirmed;
      case BookingStatus.washerEnRoute:
      case BookingStatus.inProgress:
        return AppStatus.inProgress;
      case BookingStatus.completed:
        return AppStatus.completed;
      case BookingStatus.cancelled:
        return AppStatus.cancelled;
      case BookingStatus.noShow:
        return AppStatus.noShow;
      case BookingStatus.failed:
        return AppStatus.failed;
    }
  }

  bool _matchesFilter(Booking b) {
    switch (_filter) {
      case _AdminFilter.needsAction:
        return b.status == BookingStatus.pending ||
            b.status == BookingStatus.assigned;
      case _AdminFilter.active:
        return b.status == BookingStatus.confirmed ||
            b.status == BookingStatus.washerEnRoute ||
            b.status == BookingStatus.inProgress;
      case _AdminFilter.needsPayment:
        return b.status == BookingStatus.completed &&
            b.paymentStatus != 'paid';
      case _AdminFilter.done:
        return b.status == BookingStatus.completed &&
            b.paymentStatus == 'paid';
      case _AdminFilter.cancelled:
        return b.status == BookingStatus.cancelled ||
            b.status == BookingStatus.noShow ||
            b.status == BookingStatus.failed;
      case _AdminFilter.all:
        return true;
    }
  }

  bool _matchesSearch(Booking b) {
    if (_search.isEmpty) return true;
    final q = _search.toLowerCase();
    return b.id.toLowerCase().contains(q) ||
        (b.customerName?.toLowerCase().contains(q) ?? false) ||
        (b.washerName?.toLowerCase().contains(q) ?? false) ||
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
          // Filter + search header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(children: [
              TextField(
                onChanged: (v) => setState(() => _search = v),
                decoration: InputDecoration(
                  hintText: 'Search order ID, customer, washer, plate…',
                  hintStyle: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.textSecondary),
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
              // Filter chips with live counts
              ordersAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (orders) => _FilterChips(
                  current: _filter,
                  counts: _countsByFilter(orders),
                  onChanged: (f) => setState(() => _filter = f),
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
                        onPressed: () =>
                            ref.invalidate(adminOrdersProvider),
                        child: const Text('Retry'),
                      ),
                    ]),
              ),
              data: (orders) {
                final filtered = orders
                    .where((b) => _matchesFilter(b) && _matchesSearch(b))
                    .toList()
                  // Newest first — when a customer just booked, they appear at
                  // the top of the queue so admin can assign them quickly.
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.inbox_outlined,
                              size: 48, color: AppColors.textSecondary),
                          const Gap(12),
                          Text('No bookings here',
                              style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary)),
                        ]),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Gap(12),
                  itemBuilder: (context, i) => _BookingTile(
                    booking: filtered[i],
                    statusBadge: _appStatus(filtered[i]),
                    onTap: () => context
                        .push('/admin/bookings/${filtered[i].id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Map<_AdminFilter, int> _countsByFilter(List<Booking> orders) {
    final counts = <_AdminFilter, int>{};
    for (final f in _AdminFilter.values) {
      counts[f] = orders.where((b) {
        switch (f) {
          case _AdminFilter.needsAction:
            return b.status == BookingStatus.pending ||
                b.status == BookingStatus.assigned;
          case _AdminFilter.active:
            return b.status == BookingStatus.confirmed ||
                b.status == BookingStatus.washerEnRoute ||
                b.status == BookingStatus.inProgress;
          case _AdminFilter.needsPayment:
            return b.status == BookingStatus.completed &&
                b.paymentStatus != 'paid';
          case _AdminFilter.done:
            return b.status == BookingStatus.completed &&
                b.paymentStatus == 'paid';
          case _AdminFilter.cancelled:
            return b.status == BookingStatus.cancelled ||
                b.status == BookingStatus.noShow ||
                b.status == BookingStatus.failed;
          case _AdminFilter.all:
            return true;
        }
      }).length;
    }
    return counts;
  }
}

class _FilterChips extends StatelessWidget {
  final _AdminFilter current;
  final Map<_AdminFilter, int> counts;
  final ValueChanged<_AdminFilter> onChanged;

  const _FilterChips({
    required this.current,
    required this.counts,
    required this.onChanged,
  });

  String _label(_AdminFilter f) {
    switch (f) {
      case _AdminFilter.needsAction:
        return 'Needs Action';
      case _AdminFilter.active:
        return 'Active';
      case _AdminFilter.needsPayment:
        return 'Needs Payment';
      case _AdminFilter.done:
        return 'Done';
      case _AdminFilter.cancelled:
        return 'Cancelled';
      case _AdminFilter.all:
        return 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _AdminFilter.values.length,
        separatorBuilder: (_, __) => const Gap(8),
        itemBuilder: (_, i) {
          final f = _AdminFilter.values[i];
          final count = counts[f] ?? 0;
          return AppChip(
            label: count > 0 ? '${_label(f)} ($count)' : _label(f),
            isSelected: current == f,
            onTap: () => onChanged(f),
          );
        },
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  final Booking booking;
  final AppStatus statusBadge;
  final VoidCallback onTap;

  const _BookingTile({
    required this.booking,
    required this.statusBadge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnassigned = booking.status == BookingStatus.pending;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 10,
                offset: Offset(0, 2))
          ],
          // Subtle yellow border for orders that need admin to assign.
          border: isUnassigned
              ? Border.all(color: AppColors.warning.withValues(alpha: 0.4))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text('#${booking.shortId}',
                  style: AppTypography.titleMedium
                      .copyWith(fontWeight: FontWeight.w700)),
              const Gap(8),
              if (booking.serviceName != null)
                Expanded(
                  child: Text(booking.serviceName!,
                      style: AppTypography.labelSmall
                          .copyWith(color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis),
                )
              else
                const Spacer(),
              AppStatusIndicator(status: statusBadge),
            ]),
            const Gap(10),
            // Customer + washer in two clear rows
            _row(Icons.person_outline,
                booking.customerName ?? 'Unknown customer',
                bold: true),
            const Gap(4),
            _row(
              Icons.engineering_outlined,
              booking.washerName ?? 'Not assigned yet',
              dim: booking.washerName == null,
            ),
            const Gap(10),
            const Divider(height: 1, color: AppColors.divider),
            const Gap(10),
            Row(children: [
              const Icon(Icons.directions_car_outlined,
                  size: 14, color: AppColors.textSecondary),
              const Gap(4),
              Text(booking.vehicleId.toUpperCase(),
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
              const Gap(12),
              const Icon(Icons.calendar_today,
                  size: 14, color: AppColors.textSecondary),
              const Gap(4),
              Text(
                DateFormat('MMM dd, HH:mm').format(booking.scheduledDate),
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
              const Spacer(),
              Text(
                'Rp ${NumberFormat('#,###').format(booking.totalAmount.toInt())}',
                style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String text, {bool bold = false, bool dim = false}) {
    return Row(children: [
      Icon(icon, size: 15,
          color: dim ? AppColors.warning : AppColors.textSecondary),
      const Gap(6),
      Expanded(
        child: Text(
          text,
          style: AppTypography.bodyMedium.copyWith(
            color: dim ? AppColors.warning : AppColors.textPrimary,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            fontStyle: dim ? FontStyle.italic : FontStyle.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }
}
