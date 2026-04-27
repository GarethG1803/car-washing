import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/users_provider.dart';
import 'package:gap/gap.dart';

class EmployeeDetailScreen extends ConsumerWidget {
  final String employeeId;
  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDetailProvider(employeeId));

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
              Text('Could not load employee',
                  style: AppTypography.titleMedium),
              const Gap(16),
              TextButton(
                onPressed: () =>
                    ref.invalidate(userDetailProvider(employeeId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Employee not found'));
          }
          final name = user['name']?.toString() ?? 'Employee';
          final email = user['email']?.toString() ?? '';
          final initials = name
              .split(' ')
              .map((x) => x.isNotEmpty ? x[0] : '')
              .take(2)
              .join();
          final createdAt = user['created_at']?.toString() ?? '';

          return CustomScrollView(slivers: [
            SliverAppBar(
              expandedHeight: 200,
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
                child: Column(children: [
                  _card('Account Info', [
                    _infoRow(Icons.email_outlined, email),
                    if (createdAt.isNotEmpty)
                      _infoRow(
                        Icons.calendar_today_outlined,
                        'Joined: ${createdAt.length > 10 ? createdAt.substring(0, 10) : createdAt}',
                      ),
                  ]),
                  const Gap(16),
                  _card('Documents', [
                    _docRow('ID Verification', true),
                    _docRow('Driver\'s License', true),
                    _docRow('Background Check', true),
                    _docRow('Insurance', false),
                  ]),
                  const Gap(24),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd),
                          ),
                        ),
                        child: const Text('Deactivate'),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd),
                          ),
                        ),
                        child: const Text('Edit Profile'),
                      ),
                    ),
                  ]),
                  const Gap(32),
                ]),
              ),
            ),
          ]);
        },
      ),
    );
  }

  Widget _card(String title, List<Widget> children) => Container(
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
            ...children
          ],
        ),
      );

  Widget _infoRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const Gap(12),
          Expanded(child: Text(text, style: AppTypography.bodyMedium)),
        ]),
      );

  Widget _docRow(String name, bool verified) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Icon(
            verified ? Icons.check_circle : Icons.pending,
            size: 18,
            color: verified ? AppColors.success : AppColors.warning,
          ),
          const Gap(12),
          Expanded(child: Text(name, style: AppTypography.bodyMedium)),
          Text(
            verified ? 'Verified' : 'Pending',
            style: AppTypography.labelSmall.copyWith(
              color: verified ? AppColors.success : AppColors.warning,
            ),
          ),
        ]),
      );
}
