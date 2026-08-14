import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/features/admin/presentation/widgets/admin_layout.dart';
import 'package:cinehubapp/features/admin/presentation/providers/admin_providers.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return AdminLayout(
      title: 'Dashboard Overview',
      child: statsAsync.when(
        data: (stats) => const Center(child: Text('Dashboard stats loaded (Unreachable)')),
        loading: () => const Padding(
          padding: EdgeInsets.all(24.0),
          child: ShimmerBox(width: double.infinity, height: 300),
        ),
        error: (err, stack) => ErrorStateWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(dashboardStatsProvider),
        ),
      ),
    );
  }
}
