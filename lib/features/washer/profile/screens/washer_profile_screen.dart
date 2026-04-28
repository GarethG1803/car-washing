import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/features/auth/providers/auth_provider.dart';
import 'package:clean_ride/data/providers/washer_jobs_provider.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:gap/gap.dart';

class WasherProfileScreen extends ConsumerWidget {
  const WasherProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final jobsAsync = ref.watch(washerJobsProvider);
    final totalJobs = jobsAsync.valueOrNull?.length ?? 0;
    final completedJobs = jobsAsync.valueOrNull?.where((j) => j.status == BookingStatus.completed).length ?? 0;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with gradient, avatar, name, rating, status
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, Color(0xFF0047B3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(20),
                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.3),
                            child: const Icon(Icons.person, size: 44, color: Colors.white),
                          ),
                          // Online status dot
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),
                      Text(
                        user?.name ?? 'Washer',
                        style: AppTypography.titleLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const Gap(6),
                      // Rating stars
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(5, (index) {
                            if (index < 4) {
                              return const Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: Colors.amber,
                              );
                            } else {
                              return const Icon(
                                Icons.star_half_rounded,
                                size: 18,
                                color: Colors.amber,
                              );
                            }
                          }),
                          const Gap(6),
                          Text(
                            '4.9',
                            style: AppTypography.labelLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Gap(6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Online',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
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
                  // Stats row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('Total Jobs', '$totalJobs'),
                      ),
                      const Gap(AppSpacing.md),
                      Expanded(
                        child: _buildStatCard('Completed', '$completedJobs'),
                      ),
                      const Gap(AppSpacing.md),
                      Expanded(
                        child: _buildStatCard('Role', user?.role.name ?? '-'),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.xl),

                  // Specialties Section
                  Text(
                    'Specialties',
                    style: AppTypography.titleMedium,
                  ),
                  const Gap(AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      'Premium Detail',
                      'Ceramic Coating',
                      'Paint Correction',
                    ]
                        .map((specialty) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                specialty,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const Gap(AppSpacing.xl),

                  // Documents Section
                  _menuSection('Documents', [
                    _documentItem(
                      'ID Verification',
                      Icons.badge_outlined,
                      isVerified: true,
                    ),
                    _documentItem(
                      "Driver's License",
                      Icons.credit_card,
                      isVerified: true,
                    ),
                    _documentItem(
                      'Background Check',
                      Icons.verified_user_outlined,
                      isVerified: true,
                    ),
                    _documentItem(
                      'Insurance',
                      Icons.shield_outlined,
                      isVerified: false,
                      isPending: true,
                    ),
                  ]),
                  const Gap(AppSpacing.lg),

                  // Settings Section
                  _menuSection('Settings', [
                    _menuItem(
                      Icons.person_outline,
                      'Edit Profile',
                      () {},
                    ),
                    _menuItem(
                      Icons.account_balance_outlined,
                      'Bank Account',
                      () {},
                    ),
                    _menuItem(
                      Icons.notifications_outlined,
                      'Notifications',
                      () {},
                    ),
                    _menuItem(
                      Icons.lock_outline,
                      'Change Password',
                      () {},
                    ),
                    _menuItem(
                      Icons.help_outline,
                      'Help & Support',
                      () {},
                    ),
                    _menuItem(
                      Icons.privacy_tip_outlined,
                      'Privacy Policy',
                      () {},
                    ),
                  ]),
                  const Gap(AppSpacing.xl),

                  // Sign Out
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(authNotifierProvider.notifier).logout();
                        context.go('/');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ),
                  const Gap(AppSpacing.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const Gap(4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuSection(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary, size: 22),
      title: Text(label, style: AppTypography.bodyLarge),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _documentItem(
    String label,
    IconData icon, {
    bool isVerified = false,
    bool isPending = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary, size: 22),
      title: Text(label, style: AppTypography.bodyLarge),
      trailing: isVerified
          ? const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20,
                ),
                Gap(4),
                Text(
                  'Verified',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          : isPending
              ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    Gap(4),
                    Text(
                      'Pending',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
    );
  }
}
