import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          _chatItem(
            context,
            chatId: 'c1',
            initials: 'MR',
            name: 'Marcus Rivera',
            lastMessage: 'I\'m about 10 minutes away. See you soon!',
            time: '2:34 PM',
            unread: 2,
            imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&fit=crop',
          ),
          _chatItem(
            context,
            chatId: 'c2',
            initials: 'JW',
            name: 'James Wilson',
            lastMessage: 'Your car is all done! Looks great.',
            time: '11:20 AM',
            unread: 0,
            imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&fit=crop',
          ),
          _chatItem(
            context,
            chatId: 'c3',
            initials: 'SK',
            name: 'Sarah Kim',
            lastMessage: 'Sure, I can do the interior detailing as well.',
            time: 'Yesterday',
            unread: 1,
            imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&fit=crop',
          ),
          _chatItem(
            context,
            chatId: 'c4',
            initials: 'CS',
            name: 'CleanRide Support',
            lastMessage: 'Your refund has been processed. Let us know if you need anything else.',
            time: 'Mon',
            unread: 0,
          ),
        ],
      ),
    );
  }

  Widget _chatItem(
    BuildContext context, {
    required String chatId,
    required String initials,
    required String name,
    required String lastMessage,
    required String time,
    required int unread,
    String? imageUrl,
  }) {
    return InkWell(
      onTap: () => context.push('/customer/chat/$chatId'),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primaryLight,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null
                  ? Text(initials, style: AppTypography.labelLarge.copyWith(color: AppColors.primary))
                  : null,
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                      Text(
                        time,
                        style: AppTypography.labelSmall.copyWith(
                          color: unread > 0 ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          style: AppTypography.bodyMedium.copyWith(
                            color: unread > 0
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: unread > 0 ? FontWeight.w500 : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unread > 0) ...[
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$unread',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
