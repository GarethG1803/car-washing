import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/services_provider.dart';
import 'package:gap/gap.dart';

class ServiceManagementScreen extends ConsumerWidget {
  const ServiceManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Services & Pricing'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: servicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.error),
              const Gap(12),
              Text('Could not load services',
                  style: AppTypography.titleMedium),
              const Gap(16),
              TextButton(
                onPressed: () => ref.invalidate(servicesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (services) {
          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_car_wash_outlined,
                      size: 64, color: AppColors.textSecondary),
                  const Gap(16),
                  Text('No services configured',
                      style: AppTypography.titleMedium),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text('Wash Packages', style: AppTypography.titleMedium),
              const Gap(12),
              ...services.map((s) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.local_car_wash,
                            color: AppColors.primary),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(s.name,
                                  style: AppTypography.titleMedium),
                              if (s.isPopular) ...[
                                const Gap(8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius:
                                        BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Popular',
                                    style: AppTypography.labelSmall
                                        .copyWith(
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ]),
                            Text(
                              '${s.duration} min • ${s.category.name}',
                              style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Rp ${NumberFormat('#,###').format(s.price.toInt())}',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(8),
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert,
                            color: AppColors.textSecondary, size: 20),
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                              value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(
                              value: 'disable', child: Text('Disable')),
                        ],
                      ),
                    ]),
                  )),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
