import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/router/app_router.dart';
import 'package:clean_ride/data/models/user.dart';

class RoleSelectScreen extends ConsumerWidget {
  const RoleSelectScreen({super.key});

  static const List<_RoleOption> _roles = [
    _RoleOption(
      icon: Icons.person_outline,
      title: 'Customer',
      subtitle: 'Book car wash services',
      iconColor: AppColors.primary,
      bgColor: AppColors.primaryLight,
      role: UserRole.customer,
      route: '/customer/home',
    ),
    _RoleOption(
      icon: Icons.local_car_wash,
      title: 'Washer',
      subtitle: 'Manage jobs & earnings',
      iconColor: AppColors.success,
      bgColor: Color(0xFFD1FAE5),
      role: UserRole.washer,
      route: '/washer/dashboard',
    ),
    _RoleOption(
      icon: Icons.admin_panel_settings,
      title: 'Admin',
      subtitle: 'Manage your business',
      iconColor: AppColors.warning,
      bgColor: Color(0xFFFEF3C7),
      role: UserRole.admin,
      route: '/admin/dashboard',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(),

              // Header
              Text(
                'Choose Your Role',
                style: AppTypography.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Select a role to explore the app',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Role cards
              ...List.generate(_roles.length, (index) {
                final role = _roles[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < _roles.length - 1 ? AppSpacing.lg : 0,
                  ),
                  child: _RoleCard(
                    option: role,
                    onTap: () {
                      try {
                        ref.read(roleProvider.notifier).state = role.role;
                      } catch (_) {
                        // Provider may not be accessible in all contexts
                      }
                      context.go(role.route);
                    },
                  ),
                );
              }),

              const Spacer(),

              // Footer hint
              Text(
                'You can switch roles anytime from settings',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data class for role options
// ---------------------------------------------------------------------------

class _RoleOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color bgColor;
  final UserRole role;
  final String route;

  const _RoleOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.bgColor,
    required this.role,
    required this.route,
  });
}

// ---------------------------------------------------------------------------
// Role card widget
// ---------------------------------------------------------------------------

class _RoleCard extends StatelessWidget {
  final _RoleOption option;
  final VoidCallback onTap;

  const _RoleCard({
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Icon circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: option.bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    option.icon,
                    size: 28,
                    color: option.iconColor,
                  ),
                ),

                const SizedBox(width: AppSpacing.lg),

                // Title + subtitle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: AppTypography.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        option.subtitle,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chevron
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
