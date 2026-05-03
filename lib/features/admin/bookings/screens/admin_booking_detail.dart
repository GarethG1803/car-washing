import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:clean_ride/data/providers/admin_orders_provider.dart';
import 'package:clean_ride/data/providers/users_provider.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:gap/gap.dart';

class AdminBookingDetail extends ConsumerWidget {
  final String bookingId;
  const AdminBookingDetail({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(adminOrderDetailProvider(bookingId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Order #${bookingId.length > 8 ? bookingId.substring(0, 8).toUpperCase() : bookingId.toUpperCase()}',
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Only show delete option when order is completed or cancelled
          Builder(builder: (ctx) {
            final canDelete = detailAsync.maybeWhen(
              data: (data) {
                if (data == null) return false;
                final status = data['order']?['status']?.toString() ?? '';
                return status == 'done' || status == 'cancelled';
              },
              orElse: () => false,
            );
            if (!canDelete) return const SizedBox.shrink();
            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) async {
                if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Order'),
                      content: const Text(
                          'Are you sure you want to permanently delete this order? This cannot be undone.'),
                      actions: [
                        TextButton(
                            onPressed: () => ctx.pop(false),
                            child: const Text('Cancel')),
                        TextButton(
                          onPressed: () => ctx.pop(true),
                          child: const Text('Delete',
                              style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    final error = await ref
                        .read(adminOrderActionsProvider)
                        .deleteOrder(bookingId);
                    if (context.mounted) {
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(error),
                              backgroundColor: AppColors.error),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Order deleted'),
                              backgroundColor: AppColors.success),
                        );
                        context.pop();
                      }
                    }
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                      Gap(12),
                      Text('Delete Order', style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const Gap(12),
            Text('Could not load order', style: AppTypography.titleMedium),
            const Gap(16),
            TextButton(
              onPressed: () => ref.invalidate(adminOrderDetailProvider(bookingId)),
              child: const Text('Retry'),
            ),
          ]),
        ),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('Order not found'));
          }
          return _DetailBody(bookingId: bookingId, data: data);
        },
      ),
    );
  }
}

class _DetailBody extends ConsumerStatefulWidget {
  final String bookingId;
  final Map<String, dynamic> data;
  const _DetailBody({required this.bookingId, required this.data});

  @override
  ConsumerState<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends ConsumerState<_DetailBody> {
  bool _isActing = false;

  AppStatus _appStatus(String s) {
    switch (s) {
      case 'confirmed':
        return AppStatus.confirmed;
      case 'on_the_way':
      case 'in_progress':
        return AppStatus.inProgress;
      case 'done':
        return AppStatus.completed;
      case 'cancelled':
        return AppStatus.cancelled;
      default:
        return AppStatus.pending;
    }
  }

  Future<void> _cancelOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(onPressed: () => ctx.pop(false), child: const Text('No')),
          TextButton(
            onPressed: () => ctx.pop(true),
            child:
                const Text('Yes, Cancel', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() => _isActing = true);
    final error = await ref
        .read(adminOrderActionsProvider)
        .cancel(widget.bookingId);
    if (!mounted) return;
    setState(() => _isActing = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Order cancelled'), backgroundColor: AppColors.success),
      );
      ref.invalidate(adminOrderDetailProvider(widget.bookingId));
    }
  }

  Future<void> _assignWasher() async {
    // Fetch employees
    final usersAsync = ref.read(usersProvider('employee'));
    List<Map<String, dynamic>> employees = [];

    usersAsync.whenData((users) {
      employees = users;
    });

    // If still empty, try fetching directly from API
    if (employees.isEmpty) {
      try {
        final dio = ref.read(apiClientProvider);
        final response = await dio.get('/users', queryParameters: {'role': 'employee'});
        if (response.data['success'] == true) {
          employees = List<Map<String, dynamic>>.from(response.data['data']);
        }
      } catch (_) {}
    }

    if (!mounted) return;

    if (employees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No employees available')),
      );
      return;
    }

    final selectedEmployee = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Assign Washer'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: employees.length,
            itemBuilder: (_, index) {
              final emp = employees[index];
              final name = emp['name']?.toString() ?? 'Unknown';
              final id = emp['id']?.toString() ?? '';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                title: Text(name),
                subtitle: Text('ID: ${id.length > 8 ? id.substring(0, 8) : id}...',
                    style: const TextStyle(fontSize: 11)),
                onTap: () => ctx.pop(emp),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(null),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedEmployee == null || !mounted) return;

    final employeeId = selectedEmployee['id']?.toString() ?? '';
    if (employeeId.isEmpty) return;

    setState(() => _isActing = true);
    final error = await ref
        .read(adminOrderActionsProvider)
        .assign(widget.bookingId, employeeId);
    if (!mounted) return;
    setState(() => _isActing = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Washer assigned'), backgroundColor: AppColors.success),
      );
      ref.invalidate(adminOrderDetailProvider(widget.bookingId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.data['order'] as Map<String, dynamic>;
    final history = widget.data['history'] as List? ?? [];
    final status = order['status']?.toString() ?? 'pending';
    final appStatus = _appStatus(status);
    final scheduledAt = order['scheduled_at'] != null
        ? DateTime.tryParse(order['scheduled_at'].toString())
        : null;
    final plate = order['vehicle_plate']?.toString() ?? '—';
    final vehicleType = order['vehicle_type']?.toString().toUpperCase() ?? '—';
    final address = order['location_address']?.toString() ?? '—';
    final notes = order['notes']?.toString();
    final assignedId = order['assigned_employee_id']?.toString();
    final shortId = order['id']?.toString() ?? widget.bookingId;
    final displayId =
        shortId.length > 8 ? shortId.substring(0, 8).toUpperCase() : shortId.toUpperCase();

    final isCancellable = status != 'done' && status != 'cancelled';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _card([
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Order #$displayId', style: AppTypography.titleLarge),
              AppStatusIndicator(status: appStatus),
            ]),
            const Gap(12),
            if (scheduledAt != null)
              _info(Icons.calendar_today,
                  DateFormat('MMM dd, yyyy • HH:mm').format(scheduledAt)),
            const Gap(6),
            _info(Icons.location_on_outlined, address),
          ]),
          const Gap(16),
          _card([
            Text('Vehicle', style: AppTypography.titleMedium),
            const Gap(8),
            _labelValue('Plate', plate),
            _labelValue('Type', vehicleType),
          ]),
          const Gap(16),
          _card([
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Assigned Washer', style: AppTypography.titleMedium),
                if (status != 'done' && status != 'cancelled')
                  TextButton(
                    onPressed: _isActing ? null : _assignWasher,
                    child: Text(assignedId != null ? 'Reassign' : 'Assign'),
                  ),
              ],
            ),
            const Gap(4),
            if (assignedId != null)
              Row(children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.person, color: AppColors.primary, size: 20),
                ),
                const Gap(10),
                Text(assignedId, style: AppTypography.bodyMedium),
              ])
            else
              Text('Not assigned yet',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
          ]),
          if (notes != null && notes.isNotEmpty) ...[
            const Gap(16),
            _card([
              Text('Notes', style: AppTypography.titleMedium),
              const Gap(8),
              Text(notes, style: AppTypography.bodyMedium),
            ]),
          ],
          if (history.isNotEmpty) ...[
            const Gap(16),
            _card([
              Text('Status History', style: AppTypography.titleMedium),
              const Gap(12),
              ...history.map((h) {
                final hMap = h as Map<String, dynamic>;
                final changedAt = hMap['changed_at'] != null
                    ? DateTime.tryParse(hMap['changed_at'].toString())
                    : null;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hMap['status']
                                      ?.toString()
                                      .replaceAll('_', ' ')
                                      .toUpperCase() ??
                                  '',
                              style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                            if (changedAt != null)
                              Text(
                                DateFormat('MMM dd, HH:mm').format(changedAt),
                                style: AppTypography.labelSmall
                                    .copyWith(color: AppColors.textSecondary),
                              ),
                          ]),
                    ),
                  ]),
                );
              }),
            ]),
          ],
          const Gap(24),
          if (isCancellable)
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isActing ? null : _cancelOrder,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd)),
                  ),
                  child: _isActing
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.error))
                      : const Text('Cancel Order'),
                ),
              ),
              if (assignedId == null) ...[
                const Gap(12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isActing ? null : _assignWasher,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd)),
                    ),
                    child: const Text('Assign Washer'),
                  ),
                ),
              ],
            ]),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 16, color: AppColors.textSecondary),
      const Gap(8),
      Expanded(
          child: Text(text,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary))),
    ]);
  }

  Widget _labelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTypography.bodyMedium),
      ]),
    );
  }
}
