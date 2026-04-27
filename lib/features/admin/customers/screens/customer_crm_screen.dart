import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/users_provider.dart';
import 'package:gap/gap.dart';

class CustomerCrmScreen extends ConsumerStatefulWidget {
  const CustomerCrmScreen({super.key});

  @override
  ConsumerState<CustomerCrmScreen> createState() =>
      _CustomerCrmScreenState();
}

class _CustomerCrmScreenState extends ConsumerState<CustomerCrmScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(usersProvider('customer'));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: TextField(
            onChanged: (v) => setState(() => _query = v.toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search customers...',
              hintStyle: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              prefixIcon: const Icon(Icons.search,
                  color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        Expanded(
          child: customersAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.error),
                  const Gap(12),
                  Text('Could not load customers',
                      style: AppTypography.titleMedium),
                  const Gap(16),
                  TextButton(
                    onPressed: () =>
                        ref.invalidate(usersProvider('customer')),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (customers) {
              final filtered = _query.isEmpty
                  ? customers
                  : customers.where((c) {
                      final name =
                          c['name']?.toString().toLowerCase() ?? '';
                      final email =
                          c['email']?.toString().toLowerCase() ?? '';
                      return name.contains(_query) ||
                          email.contains(_query);
                    }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people_outline,
                          size: 64, color: AppColors.textSecondary),
                      const Gap(16),
                      Text(
                        _query.isEmpty
                            ? 'No customers yet'
                            : 'No results found',
                        style: AppTypography.titleMedium,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Gap(8),
                itemBuilder: (context, index) {
                  final customer = filtered[index];
                  final name =
                      customer['name']?.toString() ?? 'Customer';
                  final email =
                      customer['email']?.toString() ?? '';
                  final id = customer['id']?.toString() ?? '';
                  final initials = name
                      .split(' ')
                      .map((w) => w.isNotEmpty ? w[0] : '')
                      .take(2)
                      .join();

                  return GestureDetector(
                    onTap: () =>
                        context.push('/admin/customers/$id'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            initials,
                            style: AppTypography.labelLarge
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: AppTypography.titleMedium),
                              Text(
                                email,
                                style: AppTypography.bodyMedium
                                    .copyWith(
                                        color:
                                            AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: AppColors.textSecondary, size: 20),
                      ]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
