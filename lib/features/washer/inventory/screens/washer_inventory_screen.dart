import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_button.dart';
import 'package:clean_ride/data/providers/washer_inventory_provider.dart';
import 'package:gap/gap.dart';

class WasherInventoryScreen extends ConsumerStatefulWidget {
  const WasherInventoryScreen({super.key});

  @override
  ConsumerState<WasherInventoryScreen> createState() => _WasherInventoryScreenState();
}

class _WasherInventoryScreenState extends ConsumerState<WasherInventoryScreen> {
  bool _isSubmitting = false;

  final List<_SupplyItem> _supplies = [
    _SupplyItem(name: 'Car Shampoo', icon: Icons.local_car_wash, isChecked: false),
    _SupplyItem(name: 'Microfiber Towels', icon: Icons.dry_cleaning, isChecked: false),
    _SupplyItem(name: 'Wax Polish', icon: Icons.auto_awesome, isChecked: false),
    _SupplyItem(name: 'Glass Cleaner', icon: Icons.cleaning_services, isChecked: false),
    _SupplyItem(name: 'Tire Shine', icon: Icons.circle_outlined, isChecked: false),
    _SupplyItem(name: 'Interior Cleaner', icon: Icons.weekend_outlined, isChecked: false),
  ];

  Future<void> _submitRequest() async {
    final selected = _supplies.where((s) => s.isChecked).toList();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items selected')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final items = selected.map((s) => {
      'item_name': s.name,
      'quantity_requested': 1,
    }).toList();

    final actions = ref.read(washerInventoryActionsProvider);
    final error = await actions.batchRequest(items);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Supply request submitted!'), backgroundColor: AppColors.success),
      );
      setState(() {
        for (final item in _supplies) { item.isChecked = false; }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $error'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(washerSupplyRequestsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Supplies', style: AppTypography.titleLarge),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Supplies checklist
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              itemCount: _supplies.length,
              itemBuilder: (context, index) {
                final supply = _supplies[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))],
                  ),
                  child: CheckboxListTile(
                    value: supply.isChecked,
                    onChanged: _isSubmitting ? null : (value) => setState(() => supply.isChecked = value ?? false),
                    activeColor: AppColors.primary,
                    title: Row(
                      children: [
                        Icon(supply.icon, size: 20, color: AppColors.primary),
                        const Gap(AppSpacing.md),
                        Text(supply.name, style: AppTypography.bodyLarge),
                      ],
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                  ),
                );
              },
            ),
          ),

          // Request History section
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Request History', style: AppTypography.titleMedium),
                const Gap(AppSpacing.md),
                requestsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Could not load requests'),
                  data: (batches) {
                    if (batches.isEmpty) {
                      return Text('No requests yet', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary));
                    }
                    return Column(
                      children: batches.take(5).map((batch) {
                        final batchId = batch['batch_id'] as String;
                        final status = batch['status'] as String;
                        final items = batch['items'] as List;
                        final createdAt = batch['created_at'] != null
                            ? DateTime.parse(batch['created_at'].toString())
                            : null;

                        return Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      items.map((i) => '${i['item_name']} x${i['quantity_requested']}').join(', '),
                                      style: AppTypography.bodyMedium,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (createdAt != null)
                                      Text(DateFormat('dd/MM/yy HH:mm').format(createdAt),
                                          style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
                                decoration: BoxDecoration(
                                  color: status == 'approved'
                                      ? AppColors.success.withValues(alpha: 0.1)
                                      : status == 'rejected'
                                          ? AppColors.error.withValues(alpha: 0.1)
                                          : AppColors.warning.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status.toUpperCase(),
                                  style: AppTypography.labelSmall.copyWith(
                                    color: status == 'approved'
                                        ? AppColors.success
                                        : status == 'rejected'
                                            ? AppColors.error
                                            : AppColors.warning,
                                  ),
                                ),
                              ),
                              if (status == 'pending')
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18),
                                  color: AppColors.error,
                                  onPressed: () => _deleteBatch(batchId),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),

          // Request Supplies button
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SafeArea(
              child: AppButton(
                label: _isSubmitting ? 'Submitting...' : 'Request Supplies',
                icon: Icons.add_shopping_cart,
                onPressed: _isSubmitting ? null : _submitRequest,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteBatch(String batchId) async {
    final actions = ref.read(washerInventoryActionsProvider);
    final error = await actions.deleteSupplyBatch(batchId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error == null ? 'Request deleted' : 'Failed: $error'),
        backgroundColor: error == null ? AppColors.success : AppColors.error,
      ),
    );
  }
}

class _SupplyItem {
  final String name;
  final IconData icon;
  bool isChecked;
  _SupplyItem({required this.name, required this.icon, this.isChecked = true});
}