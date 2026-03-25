import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';

class AdminShell extends StatelessWidget {
  final StatefulNavigationShell child;

  AdminShell({super.key, required this.child});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: child,
      drawer: _buildDrawer(context),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: NavigationBar(
            selectedIndex: child.currentIndex,
            onDestinationSelected: (index) {
              if (index == 4) {
                _scaffoldKey.currentState?.openDrawer();
              } else {
                child.goBranch(index);
              }
            },
            backgroundColor: Colors.white,
            elevation: 0,
            indicatorColor: AppColors.primaryLight,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            height: 64,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.book_online_outlined),
                selectedIcon: Icon(Icons.book_online),
                label: 'Bookings',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: 'Team',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_balance_outlined),
                selectedIcon: Icon(Icons.account_balance),
                label: 'Finance',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu),
                selectedIcon: Icon(Icons.menu),
                label: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_car_wash,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'CleanRide',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.people_alt,
                  label: 'Customers',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/admin/customers');
                  },
                ),
                _DrawerItem(
                  icon: Icons.design_services,
                  label: 'Services',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/admin/services-mgmt');
                  },
                ),
                _DrawerItem(
                  icon: Icons.inventory,
                  label: 'Inventory',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/admin/inventory-mgmt');
                  },
                ),
                _DrawerItem(
                  icon: Icons.analytics,
                  label: 'Analytics',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/admin/analytics');
                  },
                ),
                _DrawerItem(
                  icon: Icons.local_offer,
                  label: 'Promotions',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/admin/promotions');
                  },
                ),
                const Divider(height: 1),
                _DrawerItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/admin/more');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      horizontalTitleGap: 12,
    );
  }
}
