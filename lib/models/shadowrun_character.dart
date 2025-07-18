// Supporting classes for the enhanced model
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'package:chummer5x/models/attributes.dart';
import 'package:chummer5x/models/qualities.dart';
import 'package:chummer5x/models/skills.dart';
import 'package:chummer5x/models/limits.dart';
import 'package:chummer5x/models/spells.dart';
import 'package:chummer5x/models/adept_powers.dart';
import 'package:chummer5x/models/complex_forms.dart';
import 'package:chummer5x/models/gear.dart';
import 'package:chummer5x/models/condition_monitor.dart';
//import 'package:chummer5x/models/critter_base.dart';
import 'package:chummer5x/models/spirit.dart';
import 'package:chummer5x/models/sprite.dart';
import 'package:chummer5x/models/initiation.dart';
import 'package:chummer5x/models/submersion.dart';
import 'package:chummer5x/models/calendar.dart';
import 'package:chummer5x/models/game_notes.dart';
import 'package:chummer5x/models/expense_entry.dart';
import 'package:chummer5x/models/mugshot.dart';





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
  final List<Quality>? qualities; // Added qualities for character traits
  
  // Magic/Resonance
  final List<Spell> spells;
  final List<Spirit> spirits;
  final List<Sprite> sprites; // Added sprites for technomancers
  final List<ComplexForm> complexForms;
  final List<AdeptPower> adeptPowers;
  final List<InitiationGrade> initiationGrades; // Added for magic users
  final List<SubmersionGrade> submersionGrades; // Added for technomancers
  
  // Equipment
  final List<Gear> gear;
  
  // Condition Monitor
  final ConditionMonitor conditionMonitor;
  
  // Character progression
  final int nuyen;
  
  // Expense tracking
  final List<ExpenseEntry> karmaExpenseEntries;
  final List<ExpenseEntry> nuyenExpenseEntries;
  
  // Calendar and notes
  final Calendar? calendar;
  final GameNotes? gameNotes;
  
  // Character mugshot
  final Mugshot? mugshot;
  
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
    this.qualities = const [],
    required this.skills,
    this.limits = const {},
    this.spells = const [],
    this.spirits = const [],
    this.sprites = const [], // Initialize sprites list
    this.complexForms = const [],
    this.adeptPowers = const [],
    this.gear = const [],
    required this.conditionMonitor,
    this.nuyen = 0,
    this.karmaExpenseEntries = const [],
    this.nuyenExpenseEntries = const [],
    this.calendar,
    this.gameNotes,
    this.mugshot,
    this.magEnabled = false,
    this.resEnabled = false,
    this.depEnabled = false,
    this.isAdept = false,
    this.isMagician = false,
    this.isTechnomancer = false,
    this.initiationGrades = const [],
    this.submersionGrades = const [],
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
    final physicalPenalty = (conditionMonitor.physicalCMFilled.clamp(0, conditionMonitor.physicalCMTotal) ~/ 3);
    final stunPenalty = (conditionMonitor.stunCMFilled.clamp(0, conditionMonitor.stunCMTotal) ~/ 3);
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
    List<Quality>? qualities,
    List<Skill>? skills,
    List<Spell>? spells,
    List<Spirit>? spirits,
    List<Sprite>? sprites,
    List<ComplexForm>? complexForms,
    List<AdeptPower>? adeptPowers,
    List<Gear>? gear,
    ConditionMonitor? conditionMonitor,
    int? nuyen,
    List<ExpenseEntry>? karmaExpenseEntries,
    List<ExpenseEntry>? nuyenExpenseEntries,
    bool? magEnabled,
    bool? resEnabled,
    bool? depEnabled,
    bool? isAdept,
    bool? isMagician,
    bool? isTechnomancer,
    Mugshot? mugshot,

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
      qualities: qualities ?? this.qualities,
      skills: skills ?? this.skills,
      spells: spells ?? this.spells,
      spirits: spirits ?? this.spirits,
      sprites: sprites ?? this.sprites,
      complexForms: complexForms ?? this.complexForms,
      adeptPowers: adeptPowers ?? this.adeptPowers,
      gear: gear ?? this.gear,
      conditionMonitor: conditionMonitor ?? this.conditionMonitor,
      nuyen: nuyen ?? this.nuyen,
      karmaExpenseEntries: karmaExpenseEntries ?? this.karmaExpenseEntries,
      nuyenExpenseEntries: nuyenExpenseEntries ?? this.nuyenExpenseEntries,
      magEnabled: magEnabled ?? this.magEnabled,
      resEnabled: resEnabled ?? this.resEnabled,
      depEnabled: depEnabled ?? this.depEnabled,
      isAdept: isAdept ?? this.isAdept,
      isMagician: isMagician ?? this.isMagician,
      isTechnomancer: isTechnomancer ?? this.isTechnomancer,
      mugshot: mugshot ?? this.mugshot,
    );
  }

  // Navigation logic computed properties
  bool get shouldShowSpellsTab => isMagician;
  bool get shouldShowSpiritsTab => isMagician;
  bool get shouldShowAdeptPowersTab => isAdept;
  bool get shouldShowComplexFormsTab => isTechnomancer;
  bool get shouldShowSpritesTab => isTechnomancer;
  bool get shouldShowInitiationGradesTab => isMagician;
  bool get shouldShowSubmersionGradesTab => isTechnomancer;
  //check if the character has the spell "Bind"
  bool get canFetterSpirit => spells.any((spell) => spell.name == "Bind");
  //technomancers can fetter sprites only if the have the quality "Resonant Stream: Technoshaman"
  bool get canFetterSprite => qualities?.any((quality) => quality.name == "Resonant Stream: Technoshaman") ?? false;

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








// Initiation and Submersion classes




