import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';

class AdminLayout extends StatelessWidget {
  const AdminLayout({
    super.key,
    required this.child,
    required this.title,
    this.actions,
  });

  final Widget child;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 900;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: Text(title),
              actions: actions,
            ),
      drawer: isDesktop ? null : const AdminDrawer(),
      body: Row(
        children: [
          if (isDesktop) const AdminSideNavigation(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDesktop) ...[
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (actions != null) Row(children: actions!),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSideNavigation extends StatelessWidget {
  const AdminSideNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings, size: 32, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  'Admin Console',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _NavItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  path: '/admin',
                ),
                _NavItem(
                  icon: Icons.people_outline,
                  label: 'Users',
                  path: '/admin/users',
                ),
                _NavItem(
                  icon: Icons.movie_outlined,
                  label: 'Projects',
                  path: '/admin/projects',
                ),
                _NavItem(
                  icon: Icons.gavel_outlined,
                  label: 'Moderation',
                  path: '/admin/moderation',
                ),
                _NavItem(
                  icon: Icons.report_outlined,
                  label: 'Reports',
                  path: '/admin/reports',
                ),
                _NavItem(
                  icon: Icons.analytics_outlined,
                  label: 'Analytics',
                  path: '/admin/analytics',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Exit Admin'),
            onTap: () => context.go(Routes.home),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: AdminSideNavigation(),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.path,
  });

  final IconData icon;
  final String label;
  final String path;

  @override
  Widget build(BuildContext context) {
    // Basic route matching for highlighted state
    final currentPath = GoRouterState.of(context).uri.toString();
    final isSelected = currentPath == path || (path != '/admin' && currentPath.startsWith(path));

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withAlpha(25),
      onTap: () {
        // If mobile drawer is open, close it
        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.pop(context);
        }
        context.go(path);
      },
    );
  }
}
