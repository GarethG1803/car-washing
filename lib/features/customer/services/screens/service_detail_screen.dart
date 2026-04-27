import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/services_provider.dart';
import 'package:clean_ride/data/providers/booking_state_provider.dart';
import 'package:gap/gap.dart';

class ServiceDetailScreen extends ConsumerWidget {
  final String serviceId;
  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(serviceDetailProvider(serviceId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: serviceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const Gap(12),
            Text('Could not load service', style: AppTypography.titleMedium),
            const Gap(16),
            TextButton(
              onPressed: () => ref.invalidate(serviceDetailProvider(serviceId)),
              child: const Text('Retry'),
            ),
          ]),
        ),
        data: (service) {
          if (service == null) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
                const Gap(12),
                Text('Service not found', style: AppTypography.titleMedium),
                const Gap(12),
                TextButton(onPressed: () => context.pop(), child: const Text('Go Back')),
              ]),
            );
          }
          return CustomScrollView(slivers: [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, Color(0xFF0047B3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.local_car_wash, size: 80, color: Colors.white24),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(service.name, style: AppTypography.headlineMedium),
                  const Gap(8),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(service.category.name.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                    ),
                  ]),
                  const Gap(16),
                  Text(
                    'Rp ${NumberFormat('#,###').format(service.price.toInt())}',
                    style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  if (service.description.isNotEmpty) ...[
                    const Gap(24),
                    Text('Description', style: AppTypography.titleMedium),
                    const Gap(8),
                    Text(service.description,
                        style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary, height: 1.5)),
                  ],
                  if (service.features.isNotEmpty) ...[
                    const Gap(24),
                    Text("What's Included", style: AppTypography.titleMedium),
                    const Gap(12),
                    ...service.features.map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(children: [
                          const Icon(Icons.check_circle, size: 20, color: AppColors.success),
                          const Gap(12),
                          Expanded(child: Text(f, style: AppTypography.bodyMedium)),
                        ]),
                      ),
                    ),
                  ],
                  const Gap(100),
                ]),
              ),
            ),
          ]);
        },
      ),
      bottomNavigationBar: serviceAsync.maybeWhen(
        data: (service) {
          if (service == null) return null;
          return Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: SafeArea(
              child: Row(children: [
                Expanded(
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Price', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    Text(
                      'Rp ${NumberFormat('#,###').format(service.price.toInt())}',
                      style: AppTypography.titleLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(bookingStateProvider.notifier).setService(service.id);
                      context.push('/customer/booking/flow');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                    ),
                    child: const Text('Book This Service'),
                  ),
                ),
              ]),
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }
}
