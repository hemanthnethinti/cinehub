import 'package:flutter/material.dart';
import 'package:cinehubapp/features/admin/presentation/widgets/admin_layout.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Analytics & Insights',
      child: ErrorStateWidget(
        message: 'Backend endpoint required: GET /api/v1/admin/analytics',
      ),
    );
  }
}
