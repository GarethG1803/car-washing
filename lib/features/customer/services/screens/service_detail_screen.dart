import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_services.dart';
import 'package:clean_ride/features/customer/services/widgets/addon_tile.dart';
import 'package:gap/gap.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;

  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final Set<String> _selectedAddons = {};

  @override
  Widget build(BuildContext context) {
    final service = MockServices.packages.firstWhere(
      (s) => s.id == widget.serviceId,
      orElse: () => MockServices.packages.first,
    );

    double addonTotal = MockServices.addons
        .where((a) => _selectedAddons.contains(a.id))
        .fold(0, (sum, a) => sum + a.price);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: service.imageUrl != null
                  ? Image.network(
                      service.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, Color(0xFF0047B3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.local_car_wash,
                          size: 80,
                          color: Colors.white24,
                        ),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name, style: AppTypography.headlineMedium),
                  const Gap(8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const Gap(4),
                      Text(
                        '${service.rating}',
                        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ' (120 reviews)',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                      const Gap(4),
                      Text(
                        '${service.duration} min',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const Gap(8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          service.category.name.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  Text(
                    'Rp ${NumberFormat('#,###').format(service.price.toInt())}',
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(24),
                  Text('Description', style: AppTypography.titleMedium),
                  const Gap(8),
                  Text(
                    service.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const Gap(24),
                  Text("What's Included", style: AppTypography.titleMedium),
                  const Gap(12),
                  ...service.features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 20, color: AppColors.success),
                          const Gap(12),
                          Expanded(
                            child: Text(feature, style: AppTypography.bodyMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(24),
                  Text('Add-ons', style: AppTypography.titleMedium),
                  const Gap(12),
                  ...MockServices.addons.map(
                    (addon) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AddonTile(
                        addon: addon,
                        isSelected: _selectedAddons.contains(addon.id),
                        onToggle: () {
                          setState(() {
                            if (_selectedAddons.contains(addon.id)) {
                              _selectedAddons.remove(addon.id);
                            } else {
                              _selectedAddons.add(addon.id);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const Gap(100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Rp ${NumberFormat('#,###').format((service.price + addonTotal).toInt())}',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.push('/customer/booking/flow'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  child: const Text('Book This Service'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
