class SkillGroup {
  final String name;
  final String? base;
  final String? karma;

  const SkillGroup({
    required this.name,
    this.base,
    this.karma,
  });

  factory SkillGroup.fromJson(Map<String, dynamic> json) {
    return SkillGroup(
      name: json['name'] ?? '',
      base: json['base'],
      karma: json['karma'],
    );
  }
}

class SkillSpecialization {
  final String name;
  final bool free;
  final bool expertise;

  const SkillSpecialization({
    required this.name,
    this.free = false,
    this.expertise = false,
  });

  factory SkillSpecialization.fromJson(Map<String, dynamic> json) {
    return SkillSpecialization(
      name: json['name'] ?? '',
      free: json['free'] == 'True',
      expertise: json['expertise'] == 'True',
    );
  }
}

class Skill {
  final String name;
  final String? karma;
  final String? base;
  final String? category; // Added category field
  final String skillGroupName;
  final int skillGroupTotal;
  final double? adeptMod;
  final bool isPrioritySkill;
  final List<SkillSpecialization> specializations;

  const Skill({
    required this.name,
    this.karma,
    this.base,
    required this.skillGroupName,
    this.category,
    required this.skillGroupTotal,
    this.adeptMod,
    this.isPrioritySkill = false,
    this.specializations = const [],
  });

  factory Skill.fromJson(Map<String, dynamic> json, String skillGroupName, int skillGroupTotal, {bool isPrioritySkill = false}) {
    final specs = <SkillSpecialization>[];
    if (json['specs'] != null) {
      final specsData = json['specs'];
      if (specsData is Map && specsData['spec'] != null) {
        final specData = specsData['spec'];
        if (specData is List) {
          specs.addAll(specData.map((s) => SkillSpecialization.fromJson(Map<String, dynamic>.from(s))));
        } else if (specData is Map) {
          specs.add(SkillSpecialization.fromJson(Map<String, dynamic>.from(specData)));
        }
      }
    }

    return Skill(
      name: json['name'] ?? '',
      karma: json['karma'],
      base: json['base'],
      category: json['category'],
      skillGroupName: skillGroupName,
      skillGroupTotal: skillGroupTotal,
      isPrioritySkill: isPrioritySkill,
      specializations: specs,
    );
  }

  Skill copyWith({double? adeptMod, bool? isPrioritySkill}) {
    return Skill(
      name: name,
      karma: karma,
      base: base,
      category: category,
      skillGroupName: skillGroupName,
      skillGroupTotal: skillGroupTotal,
      adeptMod: adeptMod ?? this.adeptMod,
      isPrioritySkill: isPrioritySkill ?? this.isPrioritySkill,
      specializations: specializations,
    );
  }
}