import 'package:cinehubapp/features/profile/domain/entities/skill.dart';

/// Data Transfer Object for a single skill entry.
///
/// Maps from the backend shape: `{ name, category, proficiency }`.
final class SkillDto {
  const SkillDto({
    required this.name,
    this.category,
    this.proficiency = 1,
  });

  final String name;
  final String? category;
  final int proficiency;

  factory SkillDto.fromJson(Map<String, dynamic> json) => SkillDto(
        name: json['name'] as String? ?? '',
        category: json['category'] as String?,
        proficiency: (json['proficiency'] as num?)?.toInt() ?? 1,
      );

  Skill toDomain() => Skill(
        name: name,
        category: category,
        proficiency: proficiency,
      );
}
