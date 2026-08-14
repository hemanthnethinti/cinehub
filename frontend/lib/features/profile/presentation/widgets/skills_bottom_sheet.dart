import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/features/profile/domain/entities/skill.dart';
import 'package:cinehubapp/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:cinehubapp/features/profile/presentation/providers/profile_providers.dart';
import 'package:cinehubapp/shared/widgets/buttons/buttons.dart';
import 'package:go_router/go_router.dart';

class SkillsBottomSheet extends ConsumerStatefulWidget {
  const SkillsBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SkillsBottomSheet(),
    );
  }

  @override
  ConsumerState<SkillsBottomSheet> createState() => _SkillsBottomSheetState();
}

class _SkillsBottomSheetState extends ConsumerState<SkillsBottomSheet> {
  late final List<Skill> _skills;
  final _skillController = TextEditingController();

  static const _suggestions = [
    'Flutter', 'Dart', 'Java', 'Kotlin', 'Node.js', 'Express', 'MongoDB',
    'PostgreSQL', 'Redis', 'Docker', 'Git', 'AWS', 'Firebase', 'Figma',
    'Python', 'C++', 'React', 'Next.js'
  ];

  @override
  void initState() {
    super.initState();
    final current = ref.read(profileNotifierProvider.notifier).currentProfile?.skills ?? [];
    _skills = List.from(current);
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  void _addSkill(String name) {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;
    
    if (_skills.length >= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 20 skills allowed.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_skills.any((s) => s.name.toLowerCase() == cleanName.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Skill already added.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _skills.add(Skill(name: cleanName, proficiency: 1));
      _skillController.clear();
    });
  }

  void _removeSkill(Skill skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  void _updateSkillProficiency(Skill skill, int newProficiency) {
    setState(() {
      final index = _skills.indexOf(skill);
      if (index != -1) {
        _skills[index] = skill.copyWith(proficiency: newProficiency);
      }
    });
  }

  void _save() {
    _skills.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final params = ProfileUpdateParams(skills: _skills);
    ref.read(profileNotifierProvider.notifier).updateProfile(params);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      padding: EdgeInsets.only(
        bottom: bottomInset > 0 ? bottomInset : AppSpacing.xxl,
        top: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Skills (${_skills.length} / 20)', style: AppTypography.headlineMedium),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          TextField(
            controller: _skillController,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Add a skill (e.g. Flutter)',
              hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                onPressed: () => _addSkill(_skillController.text),
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.md,
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.md,
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.md,
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            onSubmitted: _addSkill,
          ),
          const SizedBox(height: AppSpacing.md),
          
          if (_skills.isNotEmpty) ...[
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _skills.length,
                itemBuilder: (context, index) {
                  final skill = _skills[index];
                  return SkillInputTile(
                    skill: skill,
                    onRemove: () => _removeSkill(skill),
                    onProficiencyChanged: (val) => _updateSkillProficiency(skill, val),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          Text('Suggestions', style: AppTypography.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: _suggestions.map((s) {
              return SkillSuggestionChip(
                label: s,
                onTap: () => _addSkill(s),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          PrimaryButton(
            label: 'Save Skills',
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

class SkillInputTile extends StatelessWidget {
  const SkillInputTile({
    super.key,
    required this.skill,
    required this.onRemove,
    required this.onProficiencyChanged,
  });

  final Skill skill;
  final VoidCallback onRemove;
  final ValueChanged<int> onProficiencyChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.md,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              skill.name,
              style: AppTypography.bodyMedium,
            ),
          ),
          SkillLevelSelector(
            level: skill.proficiency,
            onChanged: onProficiencyChanged,
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
            onPressed: onRemove,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class SkillLevelSelector extends StatelessWidget {
  const SkillLevelSelector({
    super.key,
    required this.level,
    required this.onChanged,
  });

  final int level;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starLevel = index + 1;
        return GestureDetector(
          onTap: () => onChanged(starLevel),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(
              starLevel <= level ? Icons.star_rounded : Icons.star_outline_rounded,
              color: starLevel <= level ? AppColors.primary : AppColors.border,
              size: 20,
            ),
          ),
        );
      }),
    );
  }
}

class SkillSuggestionChip extends StatelessWidget {
  const SkillSuggestionChip({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.surfaceElevated,
      side: const BorderSide(color: AppColors.border),
      labelStyle: AppTypography.caption,
    );
  }
}
