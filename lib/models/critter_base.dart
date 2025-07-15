enum CritterType { spirit, sprite }

abstract class Critter {
  final String name;
  final String? crittername; // Optional critter name for spirits
  final CritterType type;
  final int force;
  final String initiativeType;
  final int initiativeDice;
  final Map<String, int> baseSkills;
  final Map<String, int> attributeModifiers;
  final List<String> powers;
  final String? special;
  int services;
  bool bound;
  bool fettered;
  Critter({
    required this.name,
    this.crittername,
    required this.type,
    required this.force,
    required this.initiativeType,
    required this.initiativeDice,
    required this.baseSkills,
    required this.attributeModifiers,
    required this.powers,
    this.special,
    this.services = 0,
    this.bound = false,
    this.fettered = false,
  });
}