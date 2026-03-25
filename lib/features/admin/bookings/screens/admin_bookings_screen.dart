import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_chip.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:clean_ride/data/mock/mock_bookings.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  int _selectedFilter = 0;
  final _filters = ['All', 'Pending', 'Active', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bookings'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search bookings...',
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  filled: true, fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd), borderSide: BorderSide.none),
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
                  itemBuilder: (_, i) => AppChip(label: _filters[i], isSelected: _selectedFilter == i, onTap: () => setState(() => _selectedFilter = i)),
                ),
              ),
            ]),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: MockBookings.bookings.length,
              separatorBuilder: (_, __) => const Gap(12),
              itemBuilder: (context, index) {
                final booking = MockBookings.bookings[index];
                return GestureDetector(
                  onTap: () => context.push('/admin/bookings/${booking.id}'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('#${booking.id}', style: AppTypography.titleMedium),
                        const Spacer(),
                        AppStatusIndicator(status: _mapStatus(booking.status.name)),
                      ]),
                      const Gap(8),
                      Row(children: [
                        Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary),
                        const Gap(4),
                        Text('Customer ${booking.customerId}', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                        const Gap(16),
                        Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                        const Gap(4),
                        Text(DateFormat('MMM dd').format(booking.scheduledDate), style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      ]),
                      const Gap(4),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(booking.address, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('Rp ${NumberFormat('#,###').format(booking.totalAmount.toInt())}', style: AppTypography.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ]),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppStatus _mapStatus(String s) {
    switch (s) {
      case 'pending': return AppStatus.pending;
      case 'confirmed': return AppStatus.confirmed;
      case 'inProgress': case 'washerEnRoute': return AppStatus.inProgress;
      case 'completed': return AppStatus.completed;
      case 'cancelled': return AppStatus.cancelled;
      default: return AppStatus.pending;
    }
  }
}
