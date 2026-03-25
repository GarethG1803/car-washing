import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_chip.dart';
import 'package:clean_ride/data/mock/mock_services.dart';
import 'package:clean_ride/data/models/service_package.dart';
import 'package:clean_ride/features/customer/services/widgets/service_package_card.dart';
import 'package:gap/gap.dart';

class ServiceCatalogScreen extends StatefulWidget {
  const ServiceCatalogScreen({super.key});

  @override
  State<ServiceCatalogScreen> createState() => _ServiceCatalogScreenState();
}

class _ServiceCatalogScreenState extends State<ServiceCatalogScreen> {
  int _selectedFilter = 0;
  final _searchController = TextEditingController();
  final _filters = ['All', 'Basic', 'Premium', 'Deluxe', 'Add-ons'];

  List<ServicePackage> get _filteredServices {
    final all = [...MockServices.packages, ...MockServices.addons];
    if (_selectedFilter == 0) return all;
    final category = [
      null,
      ServiceCategory.basic,
      ServiceCategory.premium,
      ServiceCategory.deluxe,
      ServiceCategory.addon,
    ][_selectedFilter];
    return all.where((s) => s.category == category).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: _filteredServices.length,
              itemBuilder: (context, index) {
                return ServicePackageCard(service: _filteredServices[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
