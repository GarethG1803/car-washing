import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class _ChatMessage {
  final String text;
  final bool isSent;
  final String time;

  const _ChatMessage({
    required this.text,
    required this.isSent,
    required this.time,
  });
}

class ChatScreen extends StatelessWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  static const _mockMessages = [
    _ChatMessage(
      text: 'Hi! I have a booking for today at 2 PM.',
      isSent: true,
      time: '1:45 PM',
    ),
    _ChatMessage(
      text: 'Hello Alex! Yes, I can see your Premium Detail booking. I\'ll be there on time.',
      isSent: false,
      time: '1:46 PM',
    ),
    _ChatMessage(
      text: 'Great! Should I leave the car unlocked?',
      isSent: true,
      time: '1:47 PM',
    ),
    _ChatMessage(
      text: 'No need, I\'ll ring the doorbell when I arrive. Just make sure the car is accessible in the driveway.',
      isSent: false,
      time: '1:48 PM',
    ),
    _ChatMessage(
      text: 'Sounds good. There\'s some mud on the floor mats, just a heads up.',
      isSent: true,
      time: '1:50 PM',
    ),
    _ChatMessage(
      text: 'No problem at all! I\'ll take extra care with the mats. The Premium Detail includes deep cleaning so it\'ll look brand new.',
      isSent: false,
      time: '1:51 PM',
    ),
    _ChatMessage(
      text: 'Awesome, thank you!',
      isSent: true,
      time: '1:52 PM',
    ),
    _ChatMessage(
      text: 'I\'m about 10 minutes away. See you soon!',
      isSent: false,
      time: '2:24 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&fit=crop'),
            ),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Marcus Rivera', style: AppTypography.titleMedium.copyWith(fontSize: 15)),
                Text(
                  'Online',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.success,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone_outlined, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _mockMessages.length,
              itemBuilder: (context, index) {
                final message = _mockMessages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.sm,
              top: AppSpacing.sm,
              bottom: MediaQuery.of(context).padding.bottom + AppSpacing.sm,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.divider, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const Gap(8),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isSent)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&fit=crop'),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isSent ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isSent ? 18 : 4),
                  bottomRight: Radius.circular(message.isSent ? 4 : 18),
                ),
                boxShadow: message.isSent
                    ? null
                    : const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: message.isSent
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: AppTypography.bodyMedium.copyWith(
                      color: message.isSent ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    message.time,
                    style: AppTypography.labelSmall.copyWith(
                      color: message.isSent
                          ? Colors.white.withOpacity(0.7)
                          : AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
