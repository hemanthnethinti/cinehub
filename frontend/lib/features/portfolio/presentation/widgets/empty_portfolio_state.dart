import 'package:flutter/material.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class EmptyPortfolioState extends StatelessWidget {
  const EmptyPortfolioState({
    super.key,
    this.title = 'No Portfolio Items',
    this.subtitle = 'There are no items to display yet.',
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.photo_library_outlined,
      title: title,
      subtitle: subtitle,
    );
  }
}
