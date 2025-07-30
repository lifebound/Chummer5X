import 'package:chummer5x/models/spirit.dart';
import 'package:chummer5x/models/sprite.dart';

class CritterFactory {
  static final Map<String, SpiritTemplate> _spiritTemplates = {
    'Spirit of Air': const SpiritTemplate(
      typeName: 'Spirit of Air',
      powers: ['Accident', 'Confusion', 'Concealment', 'Elemental Attack', 'Engulf', 'Guard', 'Movement', 'Psychokinesis', 'Search'],
      optionalPowers: ['Astral Form', 'Materialization', 'Sapience'],
      baseSkills: ['Assensing', 'Astral Combat', 'Perception', 'Running', 'Unarmed Combat'],
      special: 'Immune to gases, +2 dice vs. ranged attacks',
      attributeModifiers: {
        'BOD': -2,
        'AGI': 3,
        'REA': 4,
        'STR': -3,
        'WIL': 0,
        'LOG': 0,
        'INT': 0,
        'CHA': 0,

      },
    ),
    'Spirit of Earth': const SpiritTemplate(
      typeName: 'Spirit of Earth',
      powers: ['Binding', 'Concealment', 'Elemental Attack', 'Guard', 'Hardened Armor', 'Movement', 'Search'],
      optionalPowers: ['Astral Form', 'Materialization', 'Sapience'],
      baseSkills: ['Assensing', 'Astral Combat', 'Perception', 'Unarmed Combat'],
      special: 'Immune to petrification, +2 dice vs. spells',
      attributeModifiers: {
        'BOD': 4,
        'AGI': -2,
        'REA': -1,
        'STR': 4,
        'WIL': 0,
        'LOG': -1,
        'INT': 0,
        'CHA': -1,
        'EDG': 0,
      },
    ),
    'Spirit of Fire': const SpiritTemplate(
      typeName: 'Spirit of Fire',
      powers: ['Accident', 'Confusion', 'Elemental Attack', 'Engulf', 'Guard', 'Noxious Breath', 'Search'],
      optionalPowers: ['Astral Form', 'Materialization', 'Sapience'],
      baseSkills: ['Assensing', 'Astral Combat', 'Exotic Ranged Weapon', 'Perception', 'Unarmed Combat'],
      special: 'Immune to fire, vulnerable to water',
      attributeModifiers: {
        'BOD': 1,
        'AGI': 2,
        'REA': 2,
        'STR': 2,
        'WIL': 0,
        'LOG': -1,
        'INT': 1,
        'CHA': 0,
        'EDG': 0,
      },
    ),
    'Spirit of Water': const SpiritTemplate(
      typeName: 'Spirit of Water',
      powers: ['Binding', 'Concealment', 'Confusion', 'Elemental Attack', 'Engulf', 'Guard', 'Movement', 'Weather Control'],
      optionalPowers: ['Astral Form', 'Materialization', 'Sapience'],
      baseSkills: ['Assensing', 'Astral Combat', 'Exotic Ranged Weapon', 'Perception', 'Swimming', 'Unarmed Combat'],
      special: 'Vulnerable to fire, immune to drowning',
      attributeModifiers: {
        'BOD': 0,
        'AGI': 1,
        'REA': 2,
        'STR': 0,
        'WIL': 2,
        'LOG': 0,
        'INT': 1,
        'CHA': 2,
        'EDG': 0,
      },
    ),
    'Spirit of Man': const SpiritTemplate(
      typeName: 'Spirit of Man',
      powers: ['Accident', 'Confusion', 'Concealment', 'Guard', 'Influence', 'Search'],
      optionalPowers: ['Astral Form', 'Materialization', 'Sapience'],
      baseSkills: ['Assensing', 'Astral Combat', 'Perception', 'Spellcasting', 'Unarmed Combat'],
      special: 'Enhanced social interactions in urban areas',
      attributeModifiers: {
        'BOD': 1,
        'AGI': 0,
        'REA': 0,
        'STR': -1,
        'WIL': 1,
        'LOG': 1,
        'INT': 2,
        'CHA': 2,
        'EDG': 0,
      },
    ),
    'Spirit of Beasts': const SpiritTemplate(
      typeName: 'Spirit of Beasts',
      powers: ['Animal Control', 'Concealment', 'Enhanced Senses', 'Fear', 'Guard', 'Movement', 'Track'],
      optionalPowers: ['Astral Form', 'Materialization', 'Sapience'],
      baseSkills: ['Assensing', 'Astral Combat', 'Perception', 'Running', 'Unarmed Combat'],
      special: 'Enhanced tracking and animal handling',
      attributeModifiers: {
        'BOD': 2,
        'AGI': 1,
        'REA': 2,
        'STR': 2,
        'WIL': 0,
        'LOG': -1,
        'INT': 1,
        'CHA': 0,
        'EDG': 0,
      },
    ),
    'Spirit of Plants': const SpiritTemplate(
      typeName: 'Spirit of Plants',
      powers: ['Concealment', 'Engulf', 'Entanglement', 'Guard', 'Search'],
      optionalPowers: ['Astral Form', 'Materialization', 'Sapience'],
      baseSkills: ['Assensing', 'Astral Combat', 'Perception', 'Unarmed Combat'],
      special: 'Enhanced abilities in natural environments',
      attributeModifiers: {
        'BOD': 1,
        'AGI': -1,
        'REA': -1,
        'STR': 1,
        'WIL': 2,
        'LOG': 0,
        'INT': 1,
        'CHA': 0,
        'EDG': 0,
      },
    ),
    'Spirit of Guidance': const SpiritTemplate(
      typeName: 'Spirit of Guidance',
      powers: ['Accident', 'Confusion', 'Guard', 'Influence', 'Search'],
      optionalPowers: ['Astral Form', 'Materialization', 'Sapience'],
      baseSkills: ['Assensing', 'Astral Combat', 'Counterspelling', 'Perception', 'Unarmed Combat'],
      special: 'Provides guidance and insight',
      attributeModifiers: {
        'BOD': 0,
        'AGI': 0,
        'REA': 1,
        'STR': -2,
        'WIL': 2,
        'LOG': 3,
        'INT': 3,
        'CHA': 1,
        'EDG': 0,
      },
    ),
    'Spirit of Tasks': const SpiritTemplate(
      typeName: 'Spirit of Tasks',
      powers: ['Accident', 'Binding', 'Concealment', 'Guard', 'Movement', 'Psychokinesis', 'Search'],
      optionalPowers: ['Astral Form', 'Materialization', 'Sapience'],
      baseSkills: ['Assensing', 'Astral Combat', 'Artisan', 'Perception', 'Unarmed Combat'],
      special: 'Skilled at specific tasks and crafts',
      attributeModifiers: {
        'BOD': 2,
        'AGI': 2,
        'REA': 1,
        'STR': 2,
        'WIL': 1,
        'LOG': 0,
        'INT': 1,
        'CHA': 0,
        'EDG': 0,
      },
    ),
  };

  static final Map<String, SpriteTemplate> _spriteTemplates = {
    'Courier Sprite': const SpriteTemplate(
      typeName: 'Courier Sprite',
      powers: ['Cookie', 'Hash'],
      optionalPowers: [],
      baseSkills: ['Computer', 'Hacking'],
      special: '',
      attributeModifiers: {
        'ATK': 0,
        'SLZ': 3,
        'DP': 1,
        'FWL': 2,
      },
    ),
    'Crack Sprite': const SpriteTemplate(
      typeName: 'Crack Sprite',
      powers: ['Suppression'],
      optionalPowers: [],
      baseSkills: ['Computer', 'Electronic Warfare', 'Hacking'],
      special: '',
      attributeModifiers: {
        'ATK': 0,
        'SLZ': 3,
        'DP': 2,
        'FWL': 1,
      },
    ),
    'Data Sprite': const SpriteTemplate(
      typeName: 'Data Sprite',
      powers: ['Camouflage', 'Watermark'],
      optionalPowers: [],
      baseSkills: ['Computer', 'Electronic Warfare'],
      special: '',
      attributeModifiers: {
        'ATK': -1,
        'SLZ': 0,
        'DP': 4,
        'FWL': 1,
      },
    ),
    'Fault Sprite': const SpriteTemplate(
      typeName: 'Fault Sprite',
      powers: ['Electron Storm'],
      optionalPowers: [],
      baseSkills: ['Computer', 'Cybercombat', 'Hacking'],
      special: '',
       attributeModifiers: {
        'ATK': 3,
        'SLZ': 0,
        'DP': 1,
        'FWL': 2,
      },
    ),
    'Machine Sprite': const SpriteTemplate(
      typeName: 'Machine Sprite',
      powers: ['Diagnostics','Gremlins','Stability'],
      optionalPowers: [],
      baseSkills: ['Computer', 'Electronic Warfare','Hardware'],
      special: '',
      attributeModifiers: {
        'ATK': 1,
        'SLZ': 0,
        'DP': 3,
        'FWL': 2,
      },
    ),
    'Companion Sprite': const SpriteTemplate(
      typeName: 'Companion Sprite',
      powers: ['Shield','Bodyguard'],
      optionalPowers: [],
      baseSkills: ['Computer', 'Electronic Warfare'],
      special: '',
      attributeModifiers: {
        'ATK': -1,
        'SLZ': 1,
        'DP': 0,
        'FWL': 4,
      },
    ),
    'Generalist Sprite': const SpriteTemplate(
      typeName: 'Generalist Sprite',
      powers: ['Any 2 Optional Powers'],
      optionalPowers: [],
      baseSkills: ['Hacking', 'Electronic Warfare'],
      special: '',
      attributeModifiers: {
        'ATK': 0,
        'SLZ': 3,
        'DP': 1,
        'FWL': 1,
      },
    ),
  };

  static Sprite? generateSprite(String typeName, int force, int services, bool bound, bool fettered, {String? nameOverride}) {
    final template = _spriteTemplates[typeName];
    return template?.instantiate(force: force, services: services, bound: bound, fettered: fettered, customName: nameOverride);
  }
  
  static Spirit? generateSpirit(String typeName, int force, int services, bool bound, bool fettered, {String? nameOverride}) {
    final template = _spiritTemplates[typeName];
    return template?.instantiate(force: force, services: services, bound: bound, fettered: fettered, customName: nameOverride);
  }
  
  static List<String> get availableSpriteTypes => _spriteTemplates.keys.toList();
  static List<String> get availableSpiritTypes => _spiritTemplates.keys.toList();
  
  static SpriteTemplate? getSpriteTemplate(String typeName) => _spriteTemplates[typeName];
  static SpiritTemplate? getSpiritTemplate(String typeName) => _spiritTemplates[typeName];
}
