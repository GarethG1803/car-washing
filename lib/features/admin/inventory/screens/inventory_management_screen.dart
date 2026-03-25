import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_inventory.dart';
import 'package:clean_ride/data/models/inventory_item.dart';
import 'package:gap/gap.dart';

class InventoryManagementScreen extends StatelessWidget {
  const InventoryManagementScreen({super.key});

  Color _statusColor(StockStatus s) {
    switch (s) { case StockStatus.inStock: return AppColors.success; case StockStatus.lowStock: return AppColors.warning; case StockStatus.outOfStock: return AppColors.error; }
  }

  String _statusLabel(StockStatus s) {
    switch (s) { case StockStatus.inStock: return 'In Stock'; case StockStatus.lowStock: return 'Low Stock'; case StockStatus.outOfStock: return 'Out of Stock'; }
  }

  @override
  Widget build(BuildContext context) {
    final lowStockCount = MockInventory.items.where((i) => i.status != StockStatus.inStock).length;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Inventory'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        Row(children: [
          _summaryCard('Total Items', '${MockInventory.items.length}', Icons.inventory_2, AppColors.primary),
          const Gap(12),
          _summaryCard('Alerts', '$lowStockCount', Icons.warning_amber, AppColors.warning),
        ]),
        const Gap(24),
        Text('All Items', style: AppTypography.titleMedium),
        const Gap(12),
        ...MockInventory.items.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: _statusColor(item.status).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.inventory_2_outlined, color: _statusColor(item.status), size: 22),
            ),
            const Gap(12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.name, style: AppTypography.titleMedium),
              Text('${item.category} • ${item.currentStock}/${item.maximumStock} ${item.unit}', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: _statusColor(item.status).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(_statusLabel(item.status), style: AppTypography.labelSmall.copyWith(color: _statusColor(item.status), fontSize: 10)),
              ),
              const Gap(4),
              Text('Rp ${NumberFormat('#,###').format(item.unitPrice.toInt())}/${item.unit.substring(0, item.unit.length > 3 ? 3 : item.unit.length)}', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
            ]),
          ]),
        )),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, backgroundColor: AppColors.primary, icon: const Icon(Icons.add, color: Colors.white), label: Text('Reorder', style: AppTypography.labelLarge.copyWith(color: Colors.white))),
    );
  }

  Widget _summaryCard(String label, String value, IconData icon, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color)),
        const Gap(12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)), Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary))]),
      ]),
    ));
  }
}
