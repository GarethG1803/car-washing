import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/users_provider.dart';
import 'package:gap/gap.dart';

class CustomerCrmDetail extends ConsumerWidget {
  final String customerId;
  const CustomerCrmDetail({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDetailProvider(customerId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: userAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.error),
              const Gap(12),
              Text('Could not load customer',
                  style: AppTypography.titleMedium),
              const Gap(16),
              TextButton(
                onPressed: () =>
                    ref.invalidate(userDetailProvider(customerId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Customer not found'));
          }
          final name = user['name']?.toString() ?? 'Customer';
          final email = user['email']?.toString() ?? '';
          final createdAt = user['created_at']?.toString() ?? '';
          final initials = name
              .split(' ')
              .map((x) => x.isNotEmpty ? x[0] : '')
              .take(2)
              .join();

          return CustomScrollView(slivers: [
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, Color(0xFF0047B3)],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Gap(20),
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white24,
                          child: Text(
                            initials,
                            style: AppTypography.headlineMedium
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        const Gap(8),
                        Text(
                          name,
                          style: AppTypography.titleLarge
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          email,
                          style: AppTypography.bodyMedium
                              .copyWith(color: Colors.white70),
                        ),
                      ],
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
                    _section('Contact Info', [
                      _infoRow(Icons.email_outlined, email),
                      if (createdAt.isNotEmpty)
                        _infoRow(
                          Icons.calendar_today_outlined,
                          'Member since: ${createdAt.length > 10 ? createdAt.substring(0, 10) : createdAt}',
                        ),
                    ]),
                    const Gap(32),
                  ],
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleMedium),
          const Gap(12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const Gap(12),
        Expanded(child: Text(text, style: AppTypography.bodyMedium)),
      ]),
    );
  }
}
