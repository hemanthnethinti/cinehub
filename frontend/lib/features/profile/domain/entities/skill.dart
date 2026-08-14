/// Skill value object — a user's declared professional skill.
///
/// Immutable. Changes produce a new [Skill] via [copyWith].
/// Equality is based on [name] alone (case-sensitive).
final class Skill {
  const Skill({
    required this.name,
    this.category,
    this.proficiency = 1,
  });

  final String name;

  /// One of `SKILL_CATEGORIES` values (directing, cinematography, writing…).
  final String? category;

  /// Self-assessed proficiency on a 1–5 scale.
  final int proficiency;

  Skill copyWith({
    String? name,
    String? category,
    int? proficiency,
  }) =>
      Skill(
        name: name ?? this.name,
        category: category ?? this.category,
        proficiency: proficiency ?? this.proficiency,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Skill && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'Skill(name: $name, proficiency: $proficiency)';
}
