import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/admin_supply_provider.dart';
import 'package:gap/gap.dart';

class AdminSupplyRequestsScreen extends ConsumerWidget {
  const AdminSupplyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(adminSupplyRequestsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Supply Requests', style: AppTypography.titleLarge),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: requestsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const Gap(12),
            Text('Could not load requests', style: AppTypography.bodyLarge),
            TextButton(
              onPressed: () => ref.invalidate(adminSupplyRequestsProvider),
              child: const Text('Retry'),
            ),
          ]),
        ),
        data: (batches) {
          if (batches.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.textSecondary),
                const Gap(12),
                Text('No supply requests', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
              ]),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: batches.length,
            itemBuilder: (context, index) {
              final batch = batches[index];
              final batchId = batch['batch_id'] as String;
              final employeeName = batch['employee_name'] ?? 'Unknown';
              final status = batch['status'] as String;
              final items = batch['items'] as List;
              final createdAt = batch['created_at'] != null
                  ? DateTime.parse(batch['created_at'].toString())
                  : null;

              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text('Request #${batchId.substring(0, 8)}',
                                style: AppTypography.titleMedium),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md, vertical: 4),
                            decoration: BoxDecoration(
                              color: status == 'pending'
                                  ? AppColors.warning.withValues(alpha: 0.1)
                                  : status == 'approved'
                                      ? AppColors.success.withValues(alpha: 0.1)
                                      : AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: AppTypography.labelSmall.copyWith(
                                color: status == 'pending'
                                    ? AppColors.warning
                                    : status == 'approved'
                                        ? AppColors.success
                                        : AppColors.error,
                              ),
                            ),
                          ),
                          if (status != 'pending')
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18),
                              color: AppColors.error,
                              onPressed: () => _deleteBatch(context, ref, batchId),
                            ),
                        ],
                      ),
                      const Gap(AppSpacing.sm),
                      Text('Requested by: $employeeName',
                          style: AppTypography.bodyMedium),
                      if (createdAt != null) ...[
                        const Gap(AppSpacing.xs),
                        Text(
                            DateFormat('dd MMM yyyy, HH:mm').format(createdAt),
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.textSecondary)),
                      ],
                      const Gap(AppSpacing.md),
                      Text('Items:', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                      const Gap(AppSpacing.xs),
                      ...items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.circle, size: 6, color: AppColors.primary),
                                const Gap(AppSpacing.sm),
                                Text(
                                  '${item['item_name']} x${item['quantity_requested']}',
                                  style: AppTypography.bodyMedium,
                                ),
                              ],
                            ),
                          )),
                      if (status == 'pending') ...[
                        const Gap(AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _handleAction(
                                    context, ref, batchId, 'rejected'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side: const BorderSide(color: AppColors.error),
                                ),
                                child: const Text('Reject Batch'),
                              ),
                            ),
                            const Gap(AppSpacing.md),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _handleAction(
                                    context, ref, batchId, 'approved'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Approve Batch'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleAction(
      BuildContext context, WidgetRef ref, String batchId, String status) async {
    final actions = ref.read(adminSupplyActionsProvider);
    final error = await actions.updateRequest(batchId, status);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error == null ? 'Batch $status' : 'Failed: $error'),
          backgroundColor:
              error == null ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

      Future<void> _deleteBatch(BuildContext context, WidgetRef ref, String batchId) async {
        final actions = ref.read(adminSupplyActionsProvider);
        final error = await actions.deleteBatch(batchId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error == null ? 'Batch deleted' : 'Failed: $error'),
              backgroundColor: error == null ? AppColors.success : AppColors.error,
            ),
          );
        }
      }
}