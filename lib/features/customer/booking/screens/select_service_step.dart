import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/services_provider.dart';
import 'package:clean_ride/data/providers/booking_state_provider.dart';
import 'package:gap/gap.dart';

class SelectServiceStep extends ConsumerWidget {
  const SelectServiceStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);
    final bookingState = ref.watch(bookingStateProvider);
    final selectedId = bookingState.serviceId;

    return servicesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const Gap(12),
          Text('Could not load services', style: AppTypography.titleMedium),
          const Gap(16),
          TextButton(
            onPressed: () => ref.invalidate(servicesProvider),
            child: const Text('Retry'),
          ),
        ]),
      ),
      data: (services) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Service', style: AppTypography.titleLarge),
            const Gap(4),
            Text(
              'Choose your wash package',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const Gap(20),
            ...services.map((service) {
              final isSelected = service.id == selectedId;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () =>
                      ref.read(bookingStateProvider.notifier).setService(service.id),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.divider,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.divider,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : null,
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(service.name, style: AppTypography.titleMedium),
                              const Gap(4),
                              Text(
                                '${service.duration} min • ${service.features.length} services included',
                                style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textSecondary),
                              ),
                              if (service.description.isNotEmpty) ...[
                                const Gap(2),
                                Text(
                                  service.description,
                                  style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textSecondary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Rp ${NumberFormat('#,###').format(service.price.toInt())}',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
