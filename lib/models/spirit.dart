import 'package:chummer5x/models/critter_base.dart';
import 'dart:math';

class Spirit extends Critter {

  Spirit({
    required String name,
    String? crittername,
    required CritterType type,
    required int force,
    required String initiativeType,
    required int initiativeDice,
    required Map<String, int> baseSkills,
    required List<String> powers,
    String? special,
    required Map<String, int> attributeModifiers,
    required int services,
    required bool bound,
    required bool fettered,
  }) : super(
          name: name,
          crittername: crittername,
          type: type,
          force: force,
          initiativeType: initiativeType,
          initiativeDice: initiativeDice,
          baseSkills: baseSkills,
          powers: powers,
          special: special,
          attributeModifiers: attributeModifiers,
          services: services,
          bound: bound,
          fettered: fettered,
        );
    int get bod => max((attributeModifiers['BOD'] ?? 0) + force, 1);
    int get agi => max((attributeModifiers['AGI'] ?? -1) + force, 1);
    int get rea => max((attributeModifiers['REA'] ?? -1) + force, 1);
    int get str => max((attributeModifiers['STR'] ?? 0) + force, 1);
    int get wil => max((attributeModifiers['WIL'] ?? 0) + force, 1);
    int get log => max((attributeModifiers['LOG'] ?? -2) + force, 1);
    int get intu => max((attributeModifiers['INT'] ?? 0) + force, 1);
    int get cha => max((attributeModifiers['CHA'] ?? 0) + force, 1);
    int get edg => force ~/ 2; // Edge is half the force
  // Utility getters for display
  String get initiative => '${force + rea} + ${initiativeDice}D6';
  String get astralInitiative => '${force * 2} + ${initiativeDice + 1}D6';
}

class SpiritTemplate {
  final String typeName;
  final List<String> powers;
  final List<String>? optionalPowers;
  final List<String> baseSkills;
  final String? special;
  final Map<String, int> attributeModifiers;

  const SpiritTemplate({
    required this.typeName,
    required this.powers,
    required this.optionalPowers,
    required this.baseSkills,
    required this.special,
    required this.attributeModifiers,
  });

  Spirit instantiate({
    required int force,
    required int services,
    required bool bound,
    required bool fettered,
    String? customName
  }) {
    final skills = <String, int>{
      for (var skill in baseSkills) skill: force, // tweak as needed
    };

    return Spirit(
      name: typeName,
      crittername: customName,
      force: force,
      type: CritterType.spirit,
      initiativeType: 'Astral',
      initiativeDice: 2,
      baseSkills: skills,
      powers: [...powers],
      special: special,
      attributeModifiers: attributeModifiers,
      services: services,
      bound: bound,
      fettered: fettered,
    );
  }
}