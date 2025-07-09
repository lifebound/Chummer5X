// Supporting classes for the enhanced model
class Attribute {
  final String name;
  final String metatypeCategory;
  final int totalValue;
  final int metatypeMin;
  final int metatypeMax;
  final int metatypeAugMax;
  final int base;
  final int karma;
  final int? adeptMod;

  const Attribute({
    required this.name,
    required this.metatypeCategory,
    required this.totalValue,
    required this.metatypeMin,
    required this.metatypeMax,
    required this.metatypeAugMax,
    required this.base,
    required this.karma,
    this.adeptMod,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      name: json['name'] ?? '',
      metatypeCategory: json['metatypecategory'] ?? '',
      totalValue: int.tryParse(json['totalvalue']?.toString() ?? '0') ?? 0,
      metatypeMin: int.tryParse(json['metatypemin']?.toString() ?? '0') ?? 0,
      metatypeMax: int.tryParse(json['metatypemax']?.toString() ?? '0') ?? 0,
      metatypeAugMax: int.tryParse(json['metatypeaugmax']?.toString() ?? '0') ?? 0,
      base: int.tryParse(json['base']?.toString() ?? '0') ?? 0,
      karma: int.tryParse(json['karma']?.toString() ?? '0') ?? 0,
    );
  }

  Attribute copyWith({int? adeptMod}) {
    return Attribute(
      name: name,
      metatypeCategory: metatypeCategory,
      totalValue: totalValue,
      metatypeMin: metatypeMin,
      metatypeMax: metatypeMax,
      metatypeAugMax: metatypeAugMax,
      base: base,
      karma: karma,
      adeptMod: adeptMod ?? this.adeptMod,
    );
  }
}

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
  final String skillGroupName;
  final int skillGroupTotal;
  final int? adeptMod;
  final bool isPrioritySkill;
  final List<SkillSpecialization> specializations;

  const Skill({
    required this.name,
    this.karma,
    this.base,
    required this.skillGroupName,
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
      skillGroupName: skillGroupName,
      skillGroupTotal: skillGroupTotal,
      isPrioritySkill: isPrioritySkill,
      specializations: specs,
    );
  }

  Skill copyWith({int? adeptMod, bool? isPrioritySkill}) {
    return Skill(
      name: name,
      karma: karma,
      base: base,
      skillGroupName: skillGroupName,
      skillGroupTotal: skillGroupTotal,
      adeptMod: adeptMod ?? this.adeptMod,
      isPrioritySkill: isPrioritySkill ?? this.isPrioritySkill,
      specializations: specializations,
    );
  }
}

class LimitModifier {
  final String? limit;
  final dynamic value;
  final dynamic bonus;
  final String? source;
  final String? condition;
  final String? name;

  const LimitModifier({
    this.limit,
    this.value,
    this.source,
    this.condition,
    this.bonus,
    this.name,
  });

  factory LimitModifier.fromJson(Map<String, dynamic> json) {
    return LimitModifier(
      limit: json['limit'],
      value: json['value'],
      bonus: json['bonus'],
      source: json['source'],
      condition: json['condition'],
      name: json['name'],
    );
  }
}

class LimitDetail {
  final int total;
  final List<LimitModifier> modifiers;
  final int? adeptMod;

  const LimitDetail({
    required this.total,
    required this.modifiers,
    this.adeptMod,
  });

  LimitDetail copyWith({int? total, List<LimitModifier>? modifiers, int? adeptMod}) {
    return LimitDetail(
      total: total ?? this.total,
      modifiers: modifiers ?? this.modifiers,
      adeptMod: adeptMod ?? this.adeptMod,
    );
  }
}

class Spell {
  final String name;
  final String category;
  final String? improvementSource;
  final String? grade;

  const Spell({
    required this.name,
    required this.category,
    this.improvementSource,
    this.grade,
  });

  factory Spell.fromJson(Map<String, dynamic> json) => Spell(
    name: json['name'] ?? '',
    category: json['category'] ?? '',
    improvementSource: json['improvementsource'],
    grade: json['grade'],
  );
}

class Spirit {
  final String name;
  final String type;

  const Spirit({
    required this.name,
    required this.type,
  });

  factory Spirit.fromJson(Map<String, dynamic> json) => Spirit(
    name: json['name'] ?? '',
    type: json['type'] ?? '',
  );
}

class ComplexForm {
  final String name;

  const ComplexForm({required this.name});

  factory ComplexForm.fromJson(Map<String, dynamic> json) => ComplexForm(
    name: json['name'] ?? '',
  );
}

class AdeptPower {
  final String name;
  final String? rating;
  final String? extra;

  const AdeptPower({
    required this.name,
    this.rating,
    this.extra,
  });

  factory AdeptPower.fromJson(Map<String, dynamic> json) {
    return AdeptPower(
      name: json['name'] ?? '',
      rating: json['rating']?.toString(),
      extra: json['extra'],
    );
  }
}

class Gear {
  final String? guid;
  final dynamic name;
  final dynamic category;
  final dynamic rating;
  final bool equipped;
  final dynamic quantity;
  final String source;
  final List<Gear>? children;

  const Gear({
    this.guid,
    this.name,
    this.category,
    this.rating,
    this.equipped = false,
    this.quantity,
    this.source = '',
    this.children,
  });

  Gear copyWith({List<Gear>? children}) {
    return Gear(
      guid: guid,
      name: name,
      category: category,
      rating: rating,
      equipped: equipped,
      quantity: quantity,
      source: source,
      children: children ?? this.children,
    );
  }
}

class ConditionMonitor {
  final int physicalCM;          // Maximum physical condition monitor
  final int physicalCMFilled;    // Current physical damage taken
  final int physicalCMOverflow;  // Physical overflow (death track)
  final int physicalCMThresholdOffset; // Physical threshold offset
  
  final int stunCM;              // Maximum stun condition monitor  
  final int stunCMFilled;        // Current stun damage taken
  final int stunCMThresholdOffset; // Stun threshold offset

  const ConditionMonitor({
    this.physicalCM = 0,
    this.physicalCMFilled = 0,
    this.physicalCMOverflow = 0,
    this.physicalCMThresholdOffset = 0,
    this.stunCM = 0,
    this.stunCMFilled = 0,
    this.stunCMThresholdOffset = 0,
  });

  // Computed properties
  int get physicalCMTotal => physicalCM + physicalCMThresholdOffset;
  int get stunCMTotal => stunCM + stunCMThresholdOffset;
  
  bool get isPhysicalDown => physicalCMFilled >= physicalCMTotal;
  bool get isPhysicalDead => physicalCMFilled >= (physicalCMTotal + physicalCMOverflow);
  bool get isStunDown => stunCMFilled >= stunCMTotal;
  
  // Status strings
  String get physicalStatus {
    if (isPhysicalDead) return 'Dead';
    if (isPhysicalDown) return 'Down';
    return 'Up';
  }
  
  String get stunStatus {
    if (isStunDown) return 'Unconscious';
    return 'Conscious';
  }

  factory ConditionMonitor.fromXml(Map<String, dynamic> xmlData, Map<String, dynamic> calculatedValues) {
    return ConditionMonitor(
      // From calculatedvalues
      physicalCM: int.tryParse(calculatedValues['physicalcm']?.toString() ?? '0') ?? 0,
      physicalCMOverflow: int.tryParse(calculatedValues['physicalcmoverflow']?.toString() ?? '0') ?? 0,
      physicalCMThresholdOffset: int.tryParse(calculatedValues['physicalcmthresholdoffset']?.toString() ?? '0') ?? 0,
      stunCM: int.tryParse(calculatedValues['stuncm']?.toString() ?? '0') ?? 0,
      stunCMThresholdOffset: int.tryParse(calculatedValues['stuncmthresholdoffset']?.toString() ?? '0') ?? 0,
      
      // From root level
      physicalCMFilled: int.tryParse(xmlData['physicalcmfilled']?.toString() ?? '0') ?? 0,
      stunCMFilled: int.tryParse(xmlData['stuncmfilled']?.toString() ?? '0') ?? 0,
    );
  }
}

class ShadowrunCharacter {
  final String? name;
  final String? alias;
  final String? metatype;
  final String? ethnicity;
  final String? age;
  final String? sex;
  final String? height;
  final String? weight;
  final String? streetCred;
  final String? notoriety;
  final String? publicAwareness;
  final String? karma;
  final String? totalKarma;
  
  // Enhanced attributes system
  final List<Attribute> attributes;
  final List<Skill> skills;
  final Map<String, LimitDetail> limits;
  
  // Magic/Resonance
  final List<Spell> spells;
  final List<Spirit> spirits;
  final List<ComplexForm> complexForms;
  final List<AdeptPower> adeptPowers;
  
  // Equipment
  final List<Gear> gear;
  
  // Condition Monitor
  final ConditionMonitor conditionMonitor;
  
  // Character progression
  final int nuyen;
  
  // Attribute enabled flags
  final bool magEnabled;
  final bool resEnabled;
  final bool depEnabled;

  const ShadowrunCharacter({
    this.name,
    this.alias,
    this.metatype,
    this.ethnicity,
    this.age,
    this.sex,
    this.height,
    this.weight,
    this.streetCred,
    this.notoriety,
    this.publicAwareness,
    this.karma,
    this.totalKarma,
    required this.attributes,
    required this.skills,
    required this.limits,
    this.spells = const [],
    this.spirits = const [],
    this.complexForms = const [],
    this.adeptPowers = const [],
    this.gear = const [],
    required this.conditionMonitor,
    this.nuyen = 0,
    this.magEnabled = false,
    this.resEnabled = false,
    this.depEnabled = false,
  });
  
  // Factory constructor for basic XML parsing (backwards compatible)
  factory ShadowrunCharacter.fromXml(Map<String, dynamic> xmlData) {
    // Create basic attributes from the old format for backwards compatibility
    final attributes = <Attribute>[
      Attribute(
        name: 'Body',
        metatypeCategory: 'Physical',
        totalValue: int.tryParse(xmlData['body']?.toString() ?? '1') ?? 1,
        metatypeMin: 1,
        metatypeMax: 6,
        metatypeAugMax: 9,
        base: 1,
        karma: 0,
      ),
      Attribute(
        name: 'Agility',
        metatypeCategory: 'Physical',
        totalValue: int.tryParse(xmlData['agility']?.toString() ?? '1') ?? 1,
        metatypeMin: 1,
        metatypeMax: 6,
        metatypeAugMax: 9,
        base: 1,
        karma: 0,
      ),
      Attribute(
        name: 'Reaction',
        metatypeCategory: 'Physical',
        totalValue: int.tryParse(xmlData['reaction']?.toString() ?? '1') ?? 1,
        metatypeMin: 1,
        metatypeMax: 6,
        metatypeAugMax: 9,
        base: 1,
        karma: 0,
      ),
      Attribute(
        name: 'Strength',
        metatypeCategory: 'Physical',
        totalValue: int.tryParse(xmlData['strength']?.toString() ?? '1') ?? 1,
        metatypeMin: 1,
        metatypeMax: 6,
        metatypeAugMax: 9,
        base: 1,
        karma: 0,
      ),
      Attribute(
        name: 'Charisma',
        metatypeCategory: 'Mental',
        totalValue: int.tryParse(xmlData['charisma']?.toString() ?? '1') ?? 1,
        metatypeMin: 1,
        metatypeMax: 6,
        metatypeAugMax: 9,
        base: 1,
        karma: 0,
      ),
      Attribute(
        name: 'Intuition',
        metatypeCategory: 'Mental',
        totalValue: int.tryParse(xmlData['intuition']?.toString() ?? '1') ?? 1,
        metatypeMin: 1,
        metatypeMax: 6,
        metatypeAugMax: 9,
        base: 1,
        karma: 0,
      ),
      Attribute(
        name: 'Logic',
        metatypeCategory: 'Mental',
        totalValue: int.tryParse(xmlData['logic']?.toString() ?? '1') ?? 1,
        metatypeMin: 1,
        metatypeMax: 6,
        metatypeAugMax: 9,
        base: 1,
        karma: 0,
      ),
      Attribute(
        name: 'Willpower',
        metatypeCategory: 'Mental',
        totalValue: int.tryParse(xmlData['willpower']?.toString() ?? '1') ?? 1,
        metatypeMin: 1,
        metatypeMax: 6,
        metatypeAugMax: 9,
        base: 1,
        karma: 0,
      ),
      Attribute(
        name: 'Edge',
        metatypeCategory: 'Special',
        totalValue: int.tryParse(xmlData['edge']?.toString() ?? '1') ?? 1,
        metatypeMin: 1,
        metatypeMax: 6,
        metatypeAugMax: 9,
        base: 1,
        karma: 0,
      ),
      if ((int.tryParse(xmlData['magic']?.toString() ?? '0') ?? 0) > 0)
        Attribute(
          name: 'Magic',
          metatypeCategory: 'Special',
          totalValue: int.tryParse(xmlData['magic']?.toString() ?? '0') ?? 0,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 1,
          karma: 0,
        ),
      if ((int.tryParse(xmlData['resonance']?.toString() ?? '0') ?? 0) > 0)
        Attribute(
          name: 'Resonance',
          metatypeCategory: 'Special',
          totalValue: int.tryParse(xmlData['resonance']?.toString() ?? '0') ?? 0,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 1,
          karma: 0,
        ),
    ];

    // Create basic limits
    final limits = <String, LimitDetail>{
      'Physical': LimitDetail(
        total: int.tryParse(xmlData['physicallimit']?.toString() ?? '0') ?? 0,
        modifiers: [],
      ),
      'Mental': LimitDetail(
        total: int.tryParse(xmlData['mentallimit']?.toString() ?? '0') ?? 0,
        modifiers: [],
      ),
      'Social': LimitDetail(
        total: int.tryParse(xmlData['sociallimit']?.toString() ?? '0') ?? 0,
        modifiers: [],
      ),
    };

    return ShadowrunCharacter(
      name: xmlData['name'] ?? '',
      alias: xmlData['alias'] ?? '',
      metatype: xmlData['metatype'] ?? '',
      ethnicity: xmlData['ethnicity'] ?? '',
      age: xmlData['age'] ?? '',
      sex: xmlData['sex'] ?? '',
      height: xmlData['height'] ?? '',
      weight: xmlData['weight'] ?? '',
      streetCred: xmlData['streetcred'] ?? '0',
      notoriety: xmlData['notoriety'] ?? '0',
      publicAwareness: xmlData['publicawareness'] ?? '0',
      karma: xmlData['karma'] ?? '0',
      totalKarma: xmlData['totalkarma'] ?? '0',
      attributes: attributes,
      skills: [], // Will be populated by enhanced parser
      limits: limits,
      conditionMonitor: ConditionMonitor.fromXml(xmlData, xmlData),
      nuyen: int.tryParse(xmlData['nuyen']?.toString() ?? '0') ?? 0,
    );
  }

  // Convenience getters for backwards compatibility
  int get body => _getAttributeValue('Body');
  int get agility => _getAttributeValue('Agility');
  int get reaction => _getAttributeValue('Reaction');
  int get strength => _getAttributeValue('Strength');
  int get charisma => _getAttributeValue('Charisma');
  int get intuition => _getAttributeValue('Intuition');
  int get logic => _getAttributeValue('Logic');
  int get willpower => _getAttributeValue('Willpower');
  int get edge => _getAttributeValue('Edge');
  int get magic => _getAttributeValue('Magic');
  int get resonance => _getAttributeValue('Resonance');

  int get physicalLimit => limits['Physical']?.total ?? 0;
  int get mentalLimit => limits['Mental']?.total ?? 0;
  int get socialLimit => limits['Social']?.total ?? 0;

  int get physicalDamage => conditionMonitor.physicalCMFilled;
  int get stunDamage => conditionMonitor.stunCMFilled;
  int get physicalBoxes => conditionMonitor.physicalCMTotal;
  int get stunBoxes => conditionMonitor.stunCMTotal;

  // Helper method to get attribute values by name
  int _getAttributeValue(String attributeName) {
    final attribute = attributes.firstWhere(
      (attr) => attr.name == attributeName,
      orElse: () => const Attribute(
        name: '', 
        metatypeCategory: '', 
        totalValue: 0,
        metatypeMin: 0,
        metatypeMax: 0,
        metatypeAugMax: 0,
        base: 0,
        karma: 0,
      ),
    );
    return attribute.totalValue + (attribute.adeptMod ?? 0);
  }

  // Derived attributes (calculated)
  int get initiative => reaction + intuition;
  int get composure => charisma + willpower;
  int get judgeIntentions => charisma + intuition;
  int get memory => logic + willpower;
  int get liftCarry => body + strength;
  int get movement => agility * 2 + 10;
}
