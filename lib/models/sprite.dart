import 'package:chummer5x/models/critter_base.dart';
import 'dart:math';

class Sprite extends Critter {
  Sprite({
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
    int get atk => attributeModifiers['ATK']! + force;
    int get dp => attributeModifiers['DP']! + force;
    int get slz => attributeModifiers['SLZ']! + force;
    int get fwl => attributeModifiers['FWL']! + force; // Firewall
    //initiative is calculated as (data processing + force) + initiativeDice, and is rendered as a string
    String get initiative => '${dp + force} + ${initiativeDice}d6';
}
class SpriteTemplate {
  final String typeName;
  final List<String> powers;
  final List<String>? optionalPowers;
  final List<String> baseSkills;
  final String? special;
  final Map<String, int> attributeModifiers;


  const SpriteTemplate({
    required this.typeName,
    required this.powers,
    required this.optionalPowers,
    required this.baseSkills,
    required this.special,
    required this.attributeModifiers,
  });

  Sprite instantiate({required int force, required int services, required bool bound, required bool fettered, String? customName}) {

    final skills = <String, int>{
      for (var skill in baseSkills) skill: force + 1, // tweak as needed
    };

    return Sprite(
      name: typeName,
      crittername: customName,
      force: force,
      type: CritterType.sprite,
      initiativeType: 'Matrix',
      initiativeDice: 4,
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