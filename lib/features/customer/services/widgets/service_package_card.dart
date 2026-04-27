import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/models/service_package.dart';
import 'package:gap/gap.dart';

class ServicePackageCard extends StatelessWidget {
  final ServicePackage service;
  final VoidCallback? onTap;

  const ServicePackageCard({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.push('/customer/services/${service.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryLight,
                        AppColors.primary.withValues(alpha: 0.1),
                      ],
                    ),
                    image: service.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(service.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: service.imageUrl == null
                      ? Icon(
                          Icons.local_car_wash,
                          size: 48,
                          color: AppColors.primary.withValues(alpha: 0.5),
                        )
                      : null,
                ),
                if (service.isPopular)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Popular',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: AppTypography.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const Gap(2),
                      Text(
                        service.rating.toString(),
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Text(
                        'Rp ${NumberFormat('#,###').format(service.price.toInt())}',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' • ${service.duration} min',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
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
