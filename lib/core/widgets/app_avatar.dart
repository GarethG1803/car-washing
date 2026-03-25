import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final bool showStatus;
  final bool isOnline;

  const AppAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 48,
    this.showStatus = false,
    this.isOnline = false,
  });

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildAvatar(),
          if (showStatus) _buildStatusDot(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: size / 2,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => _buildInitialsFallback(),
        errorWidget: (context, url, error) => _buildInitialsFallback(),
      );
    }
    return _buildInitialsFallback();
  }

  Widget _buildInitialsFallback() {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.primaryLight,
      child: Text(
        _initials,
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.primary,
          fontSize: size * 0.35,
        ),
      ),
    );
  }

  Widget _buildStatusDot() {
    const double dotSize = 10;
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          color: isOnline ? AppColors.success : AppColors.textSecondary,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
    );
  }
}
