import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_button.dart';
import 'package:gap/gap.dart';

class WasherInventoryScreen extends StatefulWidget {
  const WasherInventoryScreen({super.key});

  @override
  State<WasherInventoryScreen> createState() => _WasherInventoryScreenState();
}

class _WasherInventoryScreenState extends State<WasherInventoryScreen> {
  final List<_SupplyItem> _supplies = [
    _SupplyItem(
      name: 'Car Shampoo',
      icon: Icons.local_car_wash,
      quantity: 'Good',
      status: _StockLevel.good,
      isChecked: true,
    ),
    _SupplyItem(
      name: 'Microfiber Towels',
      icon: Icons.dry_cleaning,
      quantity: 'Low',
      status: _StockLevel.low,
      isChecked: true,
    ),
    _SupplyItem(
      name: 'Wax Polish',
      icon: Icons.auto_awesome,
      quantity: 'Good',
      status: _StockLevel.good,
      isChecked: true,
    ),
    _SupplyItem(
      name: 'Glass Cleaner',
      icon: Icons.cleaning_services,
      quantity: 'Good',
      status: _StockLevel.good,
      isChecked: true,
    ),
    _SupplyItem(
      name: 'Tire Shine',
      icon: Icons.circle_outlined,
      quantity: 'Out',
      status: _StockLevel.out,
      isChecked: false,
    ),
    _SupplyItem(
      name: 'Interior Cleaner',
      icon: Icons.weekend_outlined,
      quantity: 'Good',
      status: _StockLevel.good,
      isChecked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Supplies',
          style: AppTypography.titleLarge,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Summary bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            color: AppColors.surface,
            child: Row(
              children: [
                _buildSummaryPill(
                  label: 'Good',
                  count: _supplies
                      .where((s) => s.status == _StockLevel.good)
                      .length,
                  color: AppColors.success,
                ),
                const Gap(AppSpacing.sm),
                _buildSummaryPill(
                  label: 'Low',
                  count: _supplies
                      .where((s) => s.status == _StockLevel.low)
                      .length,
                  color: AppColors.warning,
                ),
                const Gap(AppSpacing.sm),
                _buildSummaryPill(
                  label: 'Out',
                  count: _supplies
                      .where((s) => s.status == _StockLevel.out)
                      .length,
                  color: AppColors.error,
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.sm),

          // Supplies list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              itemCount: _supplies.length,
              itemBuilder: (context, index) {
                final supply = _supplies[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CheckboxListTile(
                    value: supply.isChecked,
                    onChanged: (value) {
                      setState(() {
                        _supplies[index] = supply.copyWith(
                          isChecked: value ?? false,
                        );
                      });
                    },
                    activeColor: AppColors.primary,
                    title: Row(
                      children: [
                        Icon(
                          supply.icon,
                          size: 20,
                          color: _stockColor(supply.status),
                        ),
                        const Gap(AppSpacing.md),
                        Expanded(
                          child: Text(
                            supply.name,
                            style: AppTypography.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(
                        left: 32,
                        top: 4,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _stockColor(supply.status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Gap(6),
                          Text(
                            supply.quantity,
                            style: AppTypography.labelSmall.copyWith(
                              color: _stockColor(supply.status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                );
              },
            ),
          ),

          // Request Supplies button
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SafeArea(
              child: AppButton(
                label: 'Request Supplies',
                icon: Icons.add_shopping_cart,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Supply request submitted!'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPill({
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const Gap(6),
          Text(
            '$label ($count)',
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _stockColor(_StockLevel level) {
    switch (level) {
      case _StockLevel.good:
        return AppColors.success;
      case _StockLevel.low:
        return AppColors.warning;
      case _StockLevel.out:
        return AppColors.error;
    }
  }
}

enum _StockLevel { good, low, out }

class _SupplyItem {
  final String name;
  final IconData icon;
  final String quantity;
  final _StockLevel status;
  final bool isChecked;

  const _SupplyItem({
    required this.name,
    required this.icon,
    required this.quantity,
    required this.status,
    required this.isChecked,
  });

  _SupplyItem copyWith({
    String? name,
    IconData? icon,
    String? quantity,
    _StockLevel? status,
    bool? isChecked,
  }) {
    return _SupplyItem(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
