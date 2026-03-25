import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/models/notification_item.dart';
import 'package:clean_ride/data/mock/mock_notifications.dart';
import 'package:gap/gap.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate(MockNotifications.notifications);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all read',
              style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final group = grouped[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const Gap(20),
              Text(
                group.label,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Gap(12),
              ...group.items.map(
                (notification) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _NotificationTile(notification: notification),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<_NotificationGroup> _groupByDate(List<NotificationItem> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayItems = <NotificationItem>[];
    final yesterdayItems = <NotificationItem>[];
    final earlierItems = <NotificationItem>[];

    for (final n in notifications) {
      final nDate = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      if (nDate == today) {
        todayItems.add(n);
      } else if (nDate == yesterday) {
        yesterdayItems.add(n);
      } else {
        earlierItems.add(n);
      }
    }

    final groups = <_NotificationGroup>[];
    if (todayItems.isNotEmpty) {
      groups.add(_NotificationGroup(label: 'Today', items: todayItems));
    }
    if (yesterdayItems.isNotEmpty) {
      groups.add(_NotificationGroup(label: 'Yesterday', items: yesterdayItems));
    }
    if (earlierItems.isNotEmpty) {
      groups.add(_NotificationGroup(label: 'Earlier', items: earlierItems));
    }
    return groups;
  }
}

class _NotificationGroup {
  final String label;
  final List<NotificationItem> items;

  const _NotificationGroup({required this.label, required this.items});
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: notification.isRead
            ? null
            : const Border(
                left: BorderSide(color: AppColors.primaryLight, width: 4),
              ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _iconColor(notification.type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icon(notification.type),
                color: _iconColor(notification.type),
                size: 20,
              ),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.w700,
                          ),
                        ),
                      ),
                      const Gap(8),
                      Text(
                        _formatTime(notification.createdAt),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Text(
                    notification.body,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (!notification.isRead) ...[
                    const Gap(4),
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
          ],
        ),
      ),
    );
  }

  IconData _icon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Icons.calendar_today;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.promotion:
        return Icons.local_offer_outlined;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  Color _iconColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return AppColors.primary;
      case NotificationType.payment:
        return AppColors.success;
      case NotificationType.promotion:
        return AppColors.warning;
      case NotificationType.system:
        return AppColors.textSecondary;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
