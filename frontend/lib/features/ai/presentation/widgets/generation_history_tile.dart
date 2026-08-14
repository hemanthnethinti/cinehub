import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/features/ai/domain/entities/ai_entity.dart';

class GenerationHistoryTile extends StatelessWidget {
  const GenerationHistoryTile({
    super.key,
    required this.history,
    required this.onTap,
  });

  final AiHistoryEntity history;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.auto_awesome, color: AppColors.primary),
      ),
      title: Text('${history.module.toUpperCase()} : ${history.task.toUpperCase()}'),
      subtitle: Text(
        history.output.toString(),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
