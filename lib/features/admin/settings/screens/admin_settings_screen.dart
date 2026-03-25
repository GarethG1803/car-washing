import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:gap/gap.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('More'), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(children: [
          _section('Quick Access', [
            _menuItem(Icons.people_alt, 'Customers', () => context.push('/admin/customers')),
            _menuItem(Icons.design_services, 'Services & Pricing', () => context.push('/admin/services-mgmt')),
            _menuItem(Icons.inventory, 'Inventory', () => context.push('/admin/inventory-mgmt')),
            _menuItem(Icons.analytics, 'Analytics', () => context.push('/admin/analytics')),
            _menuItem(Icons.local_offer, 'Promotions', () => context.push('/admin/promotions')),
          ]),
          const Gap(16),
          _section('Business Settings', [
            _menuItem(Icons.schedule, 'Business Hours', () {}),
            _menuItem(Icons.map_outlined, 'Service Zones', () {}),
            _menuItem(Icons.notifications_outlined, 'Notification Config', () {}),
            _menuItem(Icons.payment, 'Payment Settings', () {}),
            _menuItem(Icons.receipt_long, 'Tax Configuration', () {}),
          ]),
          const Gap(16),
          _section('App Settings', [
            _menuItem(Icons.palette_outlined, 'Appearance', () {}),
            _menuItem(Icons.language, 'Language', () {}),
            _menuItem(Icons.security, 'Security', () {}),
            _menuItem(Icons.backup, 'Backup & Export', () {}),
          ]),
          const Gap(16),
          _section('Support', [
            _menuItem(Icons.help_outline, 'Help Center', () {}),
            _menuItem(Icons.bug_report_outlined, 'Report Issue', () {}),
            _menuItem(Icons.info_outline, 'About CleanRide', () {}),
          ]),
          const Gap(24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd))),
              child: const Text('Sign Out'),
            ),
          ),
          const Gap(12),
          TextButton(onPressed: () => context.go('/role-select'), child: Text('Switch Role', style: AppTypography.labelLarge.copyWith(color: AppColors.primary))),
          const Gap(16),
          Text('CleanRide Admin v1.0.0', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
          const Gap(32),
        ]),
      ),
    );
  }

  Widget _section(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusMd), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), child: Text(title, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary))),
        ...items,
      ]),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary, size: 22),
      title: Text(label, style: AppTypography.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
      onTap: onTap,
    );
  }
}
