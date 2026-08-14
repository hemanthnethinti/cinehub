import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/features/admin/presentation/widgets/admin_layout.dart';
import 'package:cinehubapp/features/admin/presentation/providers/admin_providers.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class AdminReportsScreen extends ConsumerWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(adminReportsProvider);

    return AdminLayout(
      title: 'User Reports',
      child: reportsAsync.when(
        data: (reports) => const Center(child: Text('Reports loaded (Unreachable)')),
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(24.0),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, __) => const ShimmerBox(width: double.infinity, height: 80),
        ),
        error: (err, stack) => ErrorStateWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(adminReportsProvider),
        ),
      ),
    );
  }
}
