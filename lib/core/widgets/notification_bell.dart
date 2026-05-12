import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/data/providers/notifications_provider.dart';

/// Bell icon with a red unread badge. Tap to open a bottom sheet of recent
/// notifications. Used in customer/washer/admin AppBars.
class NotificationBell extends ConsumerWidget {
  final Color iconColor;
  final String? customerRouteBase;
  final String? washerRouteBase;

  const NotificationBell({
    super.key,
    this.iconColor = AppColors.textPrimary,
    this.customerRouteBase,
    this.washerRouteBase,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationCountProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: iconColor),
          tooltip: 'Notifications',
          onPressed: () => _openSheet(context, ref),
        ),
        if (unread > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: unread > 9 ? 4 : 5,
                vertical: 2,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Text(
                unread > 9 ? '9+' : '$unread',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openSheet(BuildContext context, WidgetRef ref) async {
    await ref.read(notificationActionsProvider).markAllRead();
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _NotificationSheet(
        customerRouteBase: customerRouteBase,
        washerRouteBase: washerRouteBase,
      ),
    );
  }
}

class _NotificationSheet extends ConsumerWidget {
  final String? customerRouteBase;
  final String? washerRouteBase;
  const _NotificationSheet({this.customerRouteBase, this.washerRouteBase});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const Gap(10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Text('Notifications',
                      style: AppTypography.titleLarge),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        ref.read(notificationActionsProvider).markAllRead(),
                    child: const Text('Mark all read'),
                  ),
                ]),
              ),
              const Gap(8),
              const Divider(color: AppColors.divider, height: 1),
              Expanded(
                child: async.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Could not load: $e',
                          style: AppTypography.bodyMedium),
                    ),
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_off_outlined,
                                size: 64,
                                color:
                                    AppColors.textSecondary.withValues(alpha: 0.4)),
                            const Gap(12),
                            Text("You're all caught up",
                                style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: items.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: AppColors.divider, height: 1),
                      itemBuilder: (_, i) => _NotificationTile(
                        n: items[i],
                        onTap: () {
                          ref.read(notificationActionsProvider).markRead(items[i].id);
                          final orderId = items[i].orderId;
                          if (orderId != null) {
                            Navigator.of(context).pop();
                            // Different role bases — caller decides the prefix
                            final base = washerRouteBase ?? customerRouteBase;
                            if (base != null) {
                              context.push('$base/$orderId');
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification n;
  final VoidCallback onTap;
  const _NotificationTile({required this.n, required this.onTap});

  ({IconData icon, Color color}) _iconForType() {
    switch (n.type) {
      case 'order_assigned':
        return (icon: Icons.assignment_ind_rounded, color: AppColors.primary);
      case 'order_confirmed':
        return (icon: Icons.check_circle_rounded, color: AppColors.success);
      case 'order_on_the_way':
        return (icon: Icons.directions_car_rounded, color: AppColors.warning);
      case 'order_in_progress':
        return (icon: Icons.local_car_wash_rounded, color: AppColors.primary);
      case 'order_done':
        return (icon: Icons.task_alt_rounded, color: AppColors.success);
      case 'order_cancelled':
      case 'order_auto_cancelled':
        return (icon: Icons.cancel_rounded, color: AppColors.error);
      case 'order_no_show':
        return (icon: Icons.person_off_rounded, color: AppColors.error);
      case 'payout_reversed':
        return (icon: Icons.money_off_rounded, color: AppColors.error);
      default:
        return (icon: Icons.notifications_rounded, color: AppColors.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconSpec = _iconForType();
    return InkWell(
      onTap: onTap,
      child: Container(
        color: n.isRead ? Colors.transparent : AppColors.primaryLight.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconSpec.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconSpec.icon, color: iconSpec.color, size: 20),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: n.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(_timeAgo(n.createdAt),
                          style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary)),
                    ],
                  ),
                  if (n.body != null && n.body!.isNotEmpty) ...[
                    const Gap(4),
                    Text(n.body!,
                        style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ],
              ),
            ),
            if (!n.isRead) ...[
              const Gap(8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dt);
  }
}
