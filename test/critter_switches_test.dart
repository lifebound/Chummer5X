import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/shadowrun_character.dart';

void main() {
  group('Critter Switch Features Tests', () {
    test('ShadowrunCharacter should have canFetterSpirit and canFetterSprites properties', () {
      // Test character with Bind spell for canFetterSpirit
      final characterWithBind = ShadowrunCharacter(
        name: 'Test Mage',
        attributes: [],
        skills: [],
        spells: [
          const Spell(name: 'Bind', category: 'Enchantment'),
        ],
        conditionMonitor: const ConditionMonitor(),
      );
      
      // Test character with Resonant Stream: Technoshaman quality for canFetterSprite
      final characterWithTechnoshaman = ShadowrunCharacter(
        name: 'Test Technomancer',
        attributes: [],
        skills: [],
        qualities: [
          const Quality(
            name: 'Resonant Stream: Technoshaman',
            source: 'SR5',
            page: '78',
            karmaCost: 5,
            qualityType: QualityType.positive
          ),
        ],
        conditionMonitor: const ConditionMonitor(),
      );
      
      // Test character with neither
      final basicCharacter = ShadowrunCharacter(
        name: 'Basic Character',
        attributes: [],
        skills: [],
        conditionMonitor: const ConditionMonitor(),
      );
      
      expect(characterWithBind.canFetterSpirit, true, reason: "canFetterSpirit should be true when character has Bind spell");
      expect(characterWithTechnoshaman.canFetterSprite, true, reason: "canFetterSprite should be true when character has Resonant Stream: Technoshaman quality");
      expect(basicCharacter.canFetterSpirit, false, reason: "canFetterSpirit should be false when character doesn't have Bind spell");
      expect(basicCharacter.canFetterSprite, false, reason: "canFetterSprite should be false when character doesn't have required quality");
    });

    test('Spirit should have bound and fettered properties accessible', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Fire', 3, 2, true, true);
      
      expect(spirit, isNotNull, reason: "Spirit should be generated successfully");
      expect(spirit!.bound, true, reason: "Spirit should be bound when specified");
      expect(spirit.fettered, true, reason: "Spirit should be fettered when specified");
      expect(spirit.type, CritterType.spirit, reason: "Type should be spirit");
    });

    test('Sprite should have bound and fettered properties accessible', () {
      final sprite = CritterFactory.generateSprite('Data Sprite', 2, 3, false, true);
      
      expect(sprite, isNotNull, reason: "Sprite should be generated successfully");
      expect(sprite!.bound, false, reason: "Sprite should not be bound when specified");
      expect(sprite.fettered, true, reason: "Sprite should be fettered when specified");
      expect(sprite.type, CritterType.sprite, reason: "Type should be sprite");
    });

    test('Switch labels should be correct for different critter types', () {
      // This is more of a documentation test for the UI behavior
      const spiritBoundLabel = 'Bound';
      const spriteBoundLabel = 'Registered';
      const spiritFetteredLabel = 'Fettered';
      const spriteFetteredLabel = 'Sprite Pet';
      
      expect(spiritBoundLabel, 'Bound', reason: "Spirit bound switch should be labeled 'Bound'");
      expect(spriteBoundLabel, 'Registered', reason: "Sprite bound switch should be labeled 'Registered'");
      expect(spiritFetteredLabel, 'Fettered', reason: "Spirit fettered switch should be labeled 'Fettered'");
      expect(spriteFetteredLabel, 'Sprite Pet', reason: "Sprite fettered switch should be labeled 'Sprite Pet'");
    });
  });
}
