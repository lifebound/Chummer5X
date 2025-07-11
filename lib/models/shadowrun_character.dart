// Supporting classes for the enhanced model
import 'package:flutter/foundation.dart';
import 'dart:math';

class Attribute {
  final String name;
  final String metatypeCategory;
  final double totalValue;
  final double metatypeMin;
  final double metatypeMax;
  final double metatypeAugMax;
  final double base;
  final double karma;
  final double? adeptMod;

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
      totalValue: double.tryParse(json['totalvalue']?.toString() ?? '0') ?? 0.0,
      metatypeMin: double.tryParse(json['metatypemin']?.toString() ?? '0') ?? 0.0,
      metatypeMax: double.tryParse(json['metatypemax']?.toString() ?? '0') ?? 0.0,
      metatypeAugMax: double.tryParse(json['metatypeaugmax']?.toString() ?? '0') ?? 0.0,
      base: double.tryParse(json['base']?.toString() ?? '0') ?? 0.0,
      karma: double.tryParse(json['karma']?.toString() ?? '0') ?? 0.0,
    );
  }

  Attribute copyWith({double? adeptMod}) {
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
  final double? adeptMod;

  const LimitDetail({
    required this.total,
    required this.modifiers,
    this.adeptMod,
  });

  LimitDetail copyWith({int? total, List<LimitModifier>? modifiers, double? adeptMod}) {
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
  final String range;
  final String duration;
  final String drain;
  final String source;
  final String page;
  final String description;
  final String? improvementSource; // Keep for backwards compatibility
  final String? grade; // Keep for backwards compatibility

  const Spell({
    required this.name,
    required this.category,
    this.range = '',
    this.duration = '',
    this.drain = '',
    this.source = '',
    this.page = '',
    this.description = '',
    this.improvementSource,
    this.grade,
  });

  factory Spell.fromJson(Map<String, dynamic> json) => Spell(
    name: json['name'] ?? '',
    category: json['category'] ?? '',
    range: json['range'] ?? '',
    duration: json['duration'] ?? '',
    drain: json['drain'] ?? '',
    source: json['source'] ?? '',
    page: json['page'] ?? '',
    description: json['description'] ?? '',
    improvementSource: json['improvementsource'],
    grade: json['grade'],
  );

  // Utility getters
  String get displayName => name;
  bool get hasCompleteInfo => 
    name.isNotEmpty && 
    range.isNotEmpty && 
    duration.isNotEmpty && 
    drain.isNotEmpty && 
    source.isNotEmpty;
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
  final String target;
  final String duration;
  final String fading;
  final String source;
  final String page;
  final String description;

  const ComplexForm({
    required this.name,
    this.target = '',
    this.duration = '',
    this.fading = '',
    this.source = '',
    this.description = '',
    this.page = '',
  });

  factory ComplexForm.fromJson(Map<String, dynamic> json) => ComplexForm(
    name: json['name'] ?? '',
    target: json['target'] ?? '',
    duration: json['duration'] ?? '',
    fading: json['fading'] ?? '',
    source: json['source'] ?? '',
    description: json['description'] ?? '',
    page: json['page'] ?? '',
  );

  // Utility getters
  String get displayName => name;
  bool get hasCompleteInfo => 
    name.isNotEmpty && 
    target.isNotEmpty && 
    duration.isNotEmpty && 
    fading.isNotEmpty && 
    source.isNotEmpty;
}

class AdeptPower {
  final String name;
  final String? rating;
  final String? extra;
  final double? pointsPerLevel; // Optional field for points per level
  final double? extraPointCost; // Optional field for extra point cost
  final bool? hasLevels; // Indicates if the power has levels
  final int? maxLevels; // Maximum levels for the power, if applicable
  final String? action; // Optional action type for the power
  final bool? discounted; // Indicates if the power is discounted
  final String source; // source for the power
  final String page; // page for the power
  final String? description; // Optional description for the power
  final Map<String, String>? bonus;


  const AdeptPower({
    required this.name,
    this.rating,
    this.extra,
    this.pointsPerLevel,
    this.extraPointCost,
    this.hasLevels,
    this.maxLevels,
    this.action,
    this.discounted,
    required this.source,
    required this.page,
    this.description,
    this.bonus,
    
  });

  factory AdeptPower.fromJson(Map<String, dynamic> json) {
    debugPrint('Parsing AdeptPower from JSON: $json');
    return AdeptPower(
      name: json['name'] ?? '',
      rating: json['rating']?.toString(),
      extra: json['extra'],
      source: json['source'] ?? '',
      page: json['page'] ?? '',
      bonus: (json['bonus'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      pointsPerLevel: json['pointsperlevel'] != null
          ? double.tryParse(json['pointsperlevel'].toString())
          : null,
      extraPointCost: json['extrapointcost'] != null
          ? double.tryParse(json['extrapointcost'].toString())
          : null,
      hasLevels: json['haslevels'] == true,
      maxLevels: json['maxlevels'] != null
          ? int.tryParse(json['maxlevels'].toString())
          : null,
      action: json['action'],
      discounted: json['discounted'] == true,
      description: json['description'],
    );
  }

  String get displayName => name;
  bool get hasCompleteInfo => 
    name.isNotEmpty && 
    rating != null &&
    source.isNotEmpty&&
    page.isNotEmpty;
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

  // Character type flags
  final bool isAdept;
  final bool isMagician;
  final bool isTechnomancer;

  ShadowrunCharacter({
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
    required List<Attribute> attributes,
    required this.skills,
    this.limits = const {},
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
    this.isAdept = false,
    this.isMagician = false,
    this.isTechnomancer = false,
  }) : attributes = _ensureEssenceAttribute(attributes);
  
  // Static helper method to ensure ESS attribute is always present
  static List<Attribute> _ensureEssenceAttribute(List<Attribute> inputAttributes) {
    // Check if ESS already exists
    final hasEssence = inputAttributes.any((attr) => attr.name == 'ESS');
    
    if (hasEssence) {
      return inputAttributes;
    }
    
    // Add hard-coded ESS attribute if not present
    return [
      ...inputAttributes,
      const Attribute(
        name: 'ESS',
        metatypeCategory: 'Special',
        totalValue: 6.0,
        metatypeMin: 6.0,
        metatypeMax: 6.0,
        metatypeAugMax: 6.0,
        base: 6.0,
        karma: 0.0,
      ),
    ];
  }

  // Factory constructor for basic XML parsing (backwards compatible)
  factory ShadowrunCharacter.fromXml(Map<String, dynamic> xmlData) {
    // Create basic attributes from the old format for backwards compatibility
    final attributes = <Attribute>[
      Attribute(
        name: 'BOD',
        metatypeCategory: 'Physical',
        totalValue: double.tryParse(xmlData['body']?.toString() ?? '1') ?? 1.0,
        metatypeMin: 1.0,
        metatypeMax: 6.0,
        metatypeAugMax: 9.0,
        base: 1.0,
        karma: 0.0,
      ),
      Attribute(
        name: 'AGI',
        metatypeCategory: 'Physical',
        totalValue: double.tryParse(xmlData['agility']?.toString() ?? '1') ?? 1.0,
        metatypeMin: 1.0,
        metatypeMax: 6.0,
        metatypeAugMax: 9.0,
        base: 1.0,
        karma: 0.0,
      ),
      Attribute(
        name: 'REA',
        metatypeCategory: 'Physical',
        totalValue: double.tryParse(xmlData['reaction']?.toString() ?? '1') ?? 1.0,
        metatypeMin: 1.0,
        metatypeMax: 6.0,
        metatypeAugMax: 9.0,
        base: 1.0,
        karma: 0.0,
      ),
      Attribute(
        name: 'STR',
        metatypeCategory: 'Physical',
        totalValue: double.tryParse(xmlData['strength']?.toString() ?? '1') ?? 1.0,
        metatypeMin: 1.0,
        metatypeMax: 6.0,
        metatypeAugMax: 9.0,
        base: 1.0,
        karma: 0.0,
      ),
      Attribute(
        name: 'CHA',
        metatypeCategory: 'Mental',
        totalValue: double.tryParse(xmlData['charisma']?.toString() ?? '1') ?? 1.0,
        metatypeMin: 1.0,
        metatypeMax: 6.0,
        metatypeAugMax: 9.0,
        base: 1.0,
        karma: 0.0,
      ),
      Attribute(
        name: 'INT',
        metatypeCategory: 'Mental',
        totalValue: double.tryParse(xmlData['intuition']?.toString() ?? '1') ?? 1.0,
        metatypeMin: 1.0,
        metatypeMax: 6.0,
        metatypeAugMax: 9.0,
        base: 1.0,
        karma: 0.0,
      ),
      Attribute(
        name: 'LOG',
        metatypeCategory: 'Mental',
        totalValue: double.tryParse(xmlData['logic']?.toString() ?? '1') ?? 1.0,
        metatypeMin: 1.0,
        metatypeMax: 6.0,
        metatypeAugMax: 9.0,
        base: 1.0,
        karma: 0.0,
      ),
      Attribute(
        name: 'WIL',
        metatypeCategory: 'Mental',
        totalValue: double.tryParse(xmlData['willpower']?.toString() ?? '1') ?? 1.0,
        metatypeMin: 1.0,
        metatypeMax: 6.0,
        metatypeAugMax: 9.0,
        base: 1.0,
        karma: 0.0,
      ),
      Attribute(
        name: 'EDG',
        metatypeCategory: 'Special',
        totalValue: double.tryParse(xmlData['edge']?.toString() ?? '1') ?? 1.0,
        metatypeMin: 1.0,
        metatypeMax: 6.0,
        metatypeAugMax: 9.0,
        base: 1.0,
        karma: 0.0,
      ),
      // ESS is always hard-coded, not imported from XML
      const Attribute(
        name: 'ESS',
        metatypeCategory: 'Special',
        totalValue: 6.0,
        metatypeMin: 6.0,
        metatypeMax: 6.0,
        metatypeAugMax: 6.0,
        base: 6.0,
        karma: 0.0,
      ),
      if ((double.tryParse(xmlData['magic']?.toString() ?? '0') ?? 0.0) > 0)
        Attribute(
          name: 'MAG',
          metatypeCategory: 'Special',
          totalValue: double.tryParse(xmlData['magic']?.toString() ?? '0') ?? 0.0,
          metatypeMin: 1.0,
          metatypeMax: 6.0,
          metatypeAugMax: 9.0,
          base: 1.0,
          karma: 0.0,
        ),
      if ((double.tryParse(xmlData['resonance']?.toString() ?? '0') ?? 0.0) > 0)
        Attribute(
          name: 'RES',
          metatypeCategory: 'Special',
          totalValue: double.tryParse(xmlData['resonance']?.toString() ?? '0') ?? 0.0,
          metatypeMin: 1.0,
          metatypeMax: 6.0,
          metatypeAugMax: 9.0,
          base: 1.0,
          karma: 0.0,
        ),
    ];

    // Remove limits from XML parsing - use lambda getters only

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
      conditionMonitor: ConditionMonitor.fromXml(xmlData, xmlData),
      nuyen: int.tryParse(xmlData['nuyen']?.toString() ?? '0') ?? 0,
    );
  }

  // Convenience getters for backwards compatibility
  int get body => _getAttributeValue('BOD').ceil();
  int get agility => _getAttributeValue('AGI').ceil();
  int get reaction => _getAttributeValue('REA').ceil();
  int get strength => _getAttributeValue('STR').ceil();
  int get charisma => _getAttributeValue('CHA').ceil();
  int get intuition => _getAttributeValue('INT').ceil();
  int get logic => _getAttributeValue('LOG').ceil();
  int get willpower => _getAttributeValue('WIL').ceil();
  int get edge => _getAttributeValue('EDG').ceil();
  int get magic => _getAttributeValue('MAG').ceil();
  int get resonance => _getAttributeValue('RES').ceil();
  int get essence => _getAttributeValue('ESS').ceil(); 

  int get physicalLimit => (((strength * 2) + body + reaction)/3).ceil().toInt();
  int get mentalLimit => (((logic * 2) + willpower + intuition)/3).ceil().toInt();
  int get socialLimit => (((charisma * 2) + willpower + essence)/3).ceil().toInt();
  int get astralLimit => max(mentalLimit,socialLimit);

  int get physicalDamage => conditionMonitor.physicalCMFilled;
  int get stunDamage => conditionMonitor.stunCMFilled;
  int get physicalBoxes => conditionMonitor.physicalCMTotal;
  int get stunBoxes => conditionMonitor.stunCMTotal;

  // Helper method to get attribute values by name
  double _getAttributeValue(String attributeName) {
    final attribute = attributes.firstWhere(
      (attr) => attr.name == attributeName,
      orElse: () => const Attribute(
        name: '', 
        metatypeCategory: '', 
        totalValue: 0.0,
        metatypeMin: 0.0,
        metatypeMax: 0.0,
        metatypeAugMax: 0.0,
        base: 0.0,
        karma: 0.0,
      ),
    );
    debugPrint('Getting value for attribute $attributeName: ${attribute.totalValue} rounded: ${attribute.totalValue.ceil()} (Adept Mod: ${attribute.adeptMod ?? 0})');
    return attribute.totalValue + (attribute.adeptMod ?? 0.0);
  }

  // Derived attributes (calculated)
  int get initiative => reaction + intuition;
  int get composure => charisma + willpower;
  int get judgeIntentions => charisma + intuition;
  int get memory => logic + willpower;
  int get liftCarry => body + strength;
  int get movement => agility * 2 + 10;

  // Condition Monitor Penalty calculation
  // For every 3 points of damage on either track (not including overflow), apply -1 penalty
  int get conditionMonitorPenalty {
    final physicalPenalty = (conditionMonitor.physicalCMFilled.clamp(0, conditionMonitor.physicalCMTotal) / 3).ceil();
    final stunPenalty = (conditionMonitor.stunCMFilled.clamp(0, conditionMonitor.stunCMTotal) / 3).ceil();
    return -(physicalPenalty + stunPenalty);
  }
  
  // copyWith method for creating modified copies of the character
  ShadowrunCharacter copyWith({
    String? name,
    String? alias,
    String? metatype,
    String? ethnicity,
    String? age,
    String? sex,
    String? height,
    String? weight,
    String? streetCred,
    String? notoriety,
    String? publicAwareness,
    String? karma,
    String? totalKarma,
    List<Attribute>? attributes,
    List<Skill>? skills,
    List<Spell>? spells,
    List<Spirit>? spirits,
    List<ComplexForm>? complexForms,
    List<AdeptPower>? adeptPowers,
    List<Gear>? gear,
    ConditionMonitor? conditionMonitor,
    int? nuyen,
    bool? magEnabled,
    bool? resEnabled,
    bool? depEnabled,
    bool? isAdept,
    bool? isMagician,
    bool? isTechnomancer,
  }) {
    return ShadowrunCharacter(
      name: name ?? this.name,
      alias: alias ?? this.alias,
      metatype: metatype ?? this.metatype,
      ethnicity: ethnicity ?? this.ethnicity,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      streetCred: streetCred ?? this.streetCred,
      notoriety: notoriety ?? this.notoriety,
      publicAwareness: publicAwareness ?? this.publicAwareness,
      karma: karma ?? this.karma,
      totalKarma: totalKarma ?? this.totalKarma,
      attributes: attributes ?? this.attributes,
      skills: skills ?? this.skills,
      spells: spells ?? this.spells,
      spirits: spirits ?? this.spirits,
      complexForms: complexForms ?? this.complexForms,
      adeptPowers: adeptPowers ?? this.adeptPowers,
      gear: gear ?? this.gear,
      conditionMonitor: conditionMonitor ?? this.conditionMonitor,
      nuyen: nuyen ?? this.nuyen,
      magEnabled: magEnabled ?? this.magEnabled,
      resEnabled: resEnabled ?? this.resEnabled,
      depEnabled: depEnabled ?? this.depEnabled,
      isAdept: isAdept ?? this.isAdept,
      isMagician: isMagician ?? this.isMagician,
      isTechnomancer: isTechnomancer ?? this.isTechnomancer,
    );
  }

  // Navigation logic computed properties
  bool get shouldShowSpellsTab => isMagician;
  bool get shouldShowSpiritsTab => isMagician;
  bool get shouldShowAdeptPowersTab => isAdept;
  bool get shouldShowComplexFormsTab => isTechnomancer;
  bool get shouldShowSpritesTab => isTechnomancer;

  // Method to adjust condition monitor filled values
  ShadowrunCharacter adjustConditionMonitor({
    required bool isPhysical,
    required bool increment,
  }) {
    final currentConditionMonitor = conditionMonitor;
    
    if (isPhysical) {
      int newPhysicalFilled = currentConditionMonitor.physicalCMFilled;
      final maxPhysicalDamage = currentConditionMonitor.physicalCMTotal + currentConditionMonitor.physicalCMOverflow;
      
      if (increment) {
        // Increment but don't exceed total + overflow (death threshold)
        newPhysicalFilled = (newPhysicalFilled + 1).clamp(0, maxPhysicalDamage);
      } else {
        // Decrement but don't go below zero
        newPhysicalFilled = (newPhysicalFilled - 1).clamp(0, maxPhysicalDamage);
      }
      
      // Return new character with updated physical condition monitor
      return copyWith(
        conditionMonitor: ConditionMonitor(
          physicalCM: currentConditionMonitor.physicalCM,
          physicalCMFilled: newPhysicalFilled,
          physicalCMOverflow: currentConditionMonitor.physicalCMOverflow,
          physicalCMThresholdOffset: currentConditionMonitor.physicalCMThresholdOffset,
          stunCM: currentConditionMonitor.stunCM,
          stunCMFilled: currentConditionMonitor.stunCMFilled,
          stunCMThresholdOffset: currentConditionMonitor.stunCMThresholdOffset,
        ),
      );
    } else {
      int newStunFilled = currentConditionMonitor.stunCMFilled;
      
      if (increment) {
        // Increment but don't exceed total
        newStunFilled = (newStunFilled + 1).clamp(0, currentConditionMonitor.stunCMTotal);
      } else {
        // Decrement but don't go below zero
        newStunFilled = (newStunFilled - 1).clamp(0, currentConditionMonitor.stunCMTotal);
      }
      
      // Return new character with updated stun condition monitor
      return copyWith(
        conditionMonitor: ConditionMonitor(
          physicalCM: currentConditionMonitor.physicalCM,
          physicalCMFilled: currentConditionMonitor.physicalCMFilled,
          physicalCMOverflow: currentConditionMonitor.physicalCMOverflow,
          physicalCMThresholdOffset: currentConditionMonitor.physicalCMThresholdOffset,
          stunCM: currentConditionMonitor.stunCM,
          stunCMFilled: newStunFilled,
          stunCMThresholdOffset: currentConditionMonitor.stunCMThresholdOffset,
        ),
      );
    }
  }
}
