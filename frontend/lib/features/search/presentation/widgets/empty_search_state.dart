import 'package:flutter/material.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class EmptySearchState extends StatelessWidget {
  const EmptySearchState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.search_off_rounded,
      title: 'No Results Found',
      subtitle: 'Try adjusting your search or filters to find what you are looking for.',
    );
  }
}
