import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/profile/domain/entities/skill.dart';
import 'package:cinehubapp/shared/widgets/chips/chips.dart';

/// Wraps a list of skills into a chip group.
class SkillChipGroup extends StatelessWidget {
  const SkillChipGroup({
    super.key,
    required this.skills,
    this.onSkillTap,
    this.title = 'Skills',
  });

  final List<Skill> skills;
  final String title;

  /// Optional tap handler, useful if chips are selectable in edit mode.
  final void Function(Skill)? onSkillTap;

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: skills.map((skill) {
              return SkillChip(
                label: skill.name,
                // Highlight high-proficiency skills slightly.
                icon: skill.proficiency >= 4 ? Icons.star : null,
                isSelected: skill.proficiency >= 4,
                onTap: onSkillTap != null ? () => onSkillTap!(skill) : null,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
