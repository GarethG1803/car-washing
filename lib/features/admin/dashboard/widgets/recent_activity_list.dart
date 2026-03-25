import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_analytics.dart';
import 'package:gap/gap.dart';

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  IconData _iconForType(String type) {
    switch (type) {
      case 'booking': return Icons.book_online;
      case 'payment': return Icons.payment;
      case 'review': return Icons.star;
      case 'washer': return Icons.person;
      case 'inventory': return Icons.inventory;
      case 'promotion': return Icons.local_offer;
      default: return Icons.info;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'booking': return AppColors.primary;
      case 'payment': return AppColors.success;
      case 'review': return Colors.amber;
      case 'washer': return const Color(0xFF8B5CF6);
      case 'inventory': return AppColors.warning;
      case 'promotion': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Column(
        children: MockAnalytics.recentActivity.take(6).map((activity) {
          final type = activity['type'] as String;
          final color = _colorForType(type);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(_iconForType(type), color: color, size: 20),
                ),
                const Gap(12),
                Expanded(
                  child: Text(activity['message'] as String, style: AppTypography.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                const Gap(8),
                Text(_timeAgo(activity['time'] as DateTime), style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
