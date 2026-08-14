import 'package:flutter/material.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class AiEmptyState extends StatelessWidget {
  const AiEmptyState({
    super.key,
    this.title = 'No Generations Yet',
    this.subtitle = 'Start by creating a bio or project description using AI Studio.',
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.auto_awesome,
      title: title,
      subtitle: subtitle,
    );
  }
}
