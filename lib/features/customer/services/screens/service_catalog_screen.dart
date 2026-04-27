import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_chip.dart';
import 'package:clean_ride/data/models/service_package.dart';
import 'package:clean_ride/data/providers/services_provider.dart';
import 'package:clean_ride/features/customer/services/widgets/service_package_card.dart';
import 'package:gap/gap.dart';

class ServiceCatalogScreen extends ConsumerStatefulWidget {
  const ServiceCatalogScreen({super.key});

  @override
  ConsumerState<ServiceCatalogScreen> createState() =>
      _ServiceCatalogScreenState();
}

class _ServiceCatalogScreenState extends ConsumerState<ServiceCatalogScreen> {
  int _selectedFilter = 0;
  final _searchController = TextEditingController();
  final _filters = ['All', 'Sedan', 'SUV', 'Truck', 'Motorcycle'];

  List<ServicePackage> _applyFilter(List<ServicePackage> all) {
    final query = _searchController.text.toLowerCase();
    var filtered = all;
    if (_selectedFilter != 0) {
      final categories = [
        null,
        ServiceCategory.basic,
        ServiceCategory.premium,
        ServiceCategory.deluxe,
        ServiceCategory.addon,
      ];
      filtered =
          filtered.where((s) => s.category == categories[_selectedFilter]).toList();
    }
    if (query.isNotEmpty) {
      filtered = filtered
          .where((s) =>
              s.name.toLowerCase().contains(query) ||
              s.description.toLowerCase().contains(query))
          .toList();
    }
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Services'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const Gap(8),
              itemBuilder: (context, index) {
                return AppChip(
                  label: _filters[index],
                  isSelected: _selectedFilter == index,
                  onTap: () => setState(() => _selectedFilter = index),
                );
              },
            ),
          ),
          const Gap(8),
          Expanded(
            child: servicesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppColors.error),
                    const Gap(12),
                    Text('Failed to load services',
                        style: AppTypography.titleMedium),
                    const Gap(4),
                    Text(e.toString(),
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center),
                    const Gap(16),
                    TextButton(
                      onPressed: () =>
                          ref.invalidate(servicesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (services) {
                final filtered = _applyFilter(services);
                if (filtered.isEmpty) {
                  return Center(
                    child: Text('No services found',
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.textSecondary)),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return ServicePackageCard(service: filtered[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
