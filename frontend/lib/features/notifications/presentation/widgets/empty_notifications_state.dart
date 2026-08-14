import 'package:flutter/material.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class EmptyNotificationsState extends StatelessWidget {
  const EmptyNotificationsState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.notifications_none_rounded,
      title: 'No Notifications',
      subtitle: 'You are all caught up!',
    );
  }
}
