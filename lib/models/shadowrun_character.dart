class ShadowrunCharacter {
  final String name;
  final String alias;
  final String metatype;
  final String ethnicity;
  final String age;
  final String sex;
  final String height;
  final String weight;
  final String streetCred;
  final String notoriety;
  final String publicAwareness;
  final String karma;
  final String totalKarma;
  
  // Attributes
  final int body;
  final int agility;
  final int reaction;
  final int strength;
  final int charisma;
  final int intuition;
  final int logic;
  final int willpower;
  final int edge;
  final int magic;
  final int resonance;
  
  // Derived Attributes
  final int physicalLimit;
  final int mentalLimit;
  final int socialLimit;
  final int initiative;
  final int composure;
  final int judgeIntentions;
  final int memory;
  final int liftCarry;
  final int movement;
  
  // Condition Monitors
  final int physicalDamage;
  final int stunDamage;
  final int physicalBoxes;
  final int stunBoxes;
  
  const ShadowrunCharacter({
    required this.name,
    required this.alias,
    required this.metatype,
    required this.ethnicity,
    required this.age,
    required this.sex,
    required this.height,
    required this.weight,
    required this.streetCred,
    required this.notoriety,
    required this.publicAwareness,
    required this.karma,
    required this.totalKarma,
    required this.body,
    required this.agility,
    required this.reaction,
    required this.strength,
    required this.charisma,
    required this.intuition,
    required this.logic,
    required this.willpower,
    required this.edge,
    required this.magic,
    required this.resonance,
    required this.physicalLimit,
    required this.mentalLimit,
    required this.socialLimit,
    required this.initiative,
    required this.composure,
    required this.judgeIntentions,
    required this.memory,
    required this.liftCarry,
    required this.movement,
    required this.physicalDamage,
    required this.stunDamage,
    required this.physicalBoxes,
    required this.stunBoxes,
  });
  
  factory ShadowrunCharacter.fromXml(Map<String, dynamic> xmlData) {
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
      body: int.tryParse(xmlData['body']?.toString() ?? '1') ?? 1,
      agility: int.tryParse(xmlData['agility']?.toString() ?? '1') ?? 1,
      reaction: int.tryParse(xmlData['reaction']?.toString() ?? '1') ?? 1,
      strength: int.tryParse(xmlData['strength']?.toString() ?? '1') ?? 1,
      charisma: int.tryParse(xmlData['charisma']?.toString() ?? '1') ?? 1,
      intuition: int.tryParse(xmlData['intuition']?.toString() ?? '1') ?? 1,
      logic: int.tryParse(xmlData['logic']?.toString() ?? '1') ?? 1,
      willpower: int.tryParse(xmlData['willpower']?.toString() ?? '1') ?? 1,
      edge: int.tryParse(xmlData['edge']?.toString() ?? '1') ?? 1,
      magic: int.tryParse(xmlData['magic']?.toString() ?? '0') ?? 0,
      resonance: int.tryParse(xmlData['resonance']?.toString() ?? '0') ?? 0,
      physicalLimit: int.tryParse(xmlData['physicallimit']?.toString() ?? '0') ?? 0,
      mentalLimit: int.tryParse(xmlData['mentallimit']?.toString() ?? '0') ?? 0,
      socialLimit: int.tryParse(xmlData['sociallimit']?.toString() ?? '0') ?? 0,
      initiative: int.tryParse(xmlData['initiative']?.toString() ?? '0') ?? 0,
      composure: int.tryParse(xmlData['composure']?.toString() ?? '0') ?? 0,
      judgeIntentions: int.tryParse(xmlData['judgeintentions']?.toString() ?? '0') ?? 0,
      memory: int.tryParse(xmlData['memory']?.toString() ?? '0') ?? 0,
      liftCarry: int.tryParse(xmlData['liftcarry']?.toString() ?? '0') ?? 0,
      movement: int.tryParse(xmlData['movement']?.toString() ?? '0') ?? 0,
      physicalDamage: int.tryParse(xmlData['physicaldamage']?.toString() ?? '0') ?? 0,
      stunDamage: int.tryParse(xmlData['stundamage']?.toString() ?? '0') ?? 0,
      physicalBoxes: int.tryParse(xmlData['physicalboxes']?.toString() ?? '0') ?? 0,
      stunBoxes: int.tryParse(xmlData['stunboxes']?.toString() ?? '0') ?? 0,
    );
  }
}
