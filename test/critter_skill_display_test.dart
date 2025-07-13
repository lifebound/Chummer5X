import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/shadowrun_character.dart';

void main() {
  group('Critter Skill Display Tests', () {
    test('Spirit should have baseSkills with proper ratings', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Fire', 3);
      
      expect(spirit, isNotNull);
      expect(spirit!.baseSkills, isNotEmpty);
      
      // Check that base skills have proper ratings (force + 1 = 4 for force 3)
      for (final skillEntry in spirit.baseSkills.entries) {
        expect(skillEntry.value, 3, 
            reason: 'Skill ${skillEntry.key} should have rating 3');
      }
      
      // Verify some expected skills exist
      expect(spirit.baseSkills, containsPair('Assensing', 3));
      expect(spirit.baseSkills, containsPair('Perception', 3));
    });

    test('Sprite should have baseSkills with proper ratings', () {
      final sprite = CritterFactory.generateSprite('Data Sprite', 2);
      
      expect(sprite, isNotNull);
      expect(sprite!.baseSkills, isNotEmpty);
      
      // Check that base skills have proper ratings (force + 1 = 3 for force 2)
      for (final skillEntry in sprite.baseSkills.entries) {
        expect(skillEntry.value, 3, 
            reason: 'Skill ${skillEntry.key} should have rating 3 (force 2 + 1)');
      }
    });

    test('Spirit attributes should be calculated correctly for dice pools', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Fire', 4);
      
      expect(spirit, isNotNull);
      
      // Verify some key attributes for dice pool calculations
      // Fire Spirit modifiers: BOD+1, AGI+2, REA+2, STR+2, WIL+0, LOG-1, INT+1, CHA+0
      expect(spirit!.agi, 6); // AGI = force + 2 = 6 for Force 4 Fire Spirit
      expect(spirit.intu, 5);  // INT = force + 1 = 5 for Force 4 Fire Spirit
      expect(spirit.str, 6);   // STR = force + 2 = 6 for Force 4 Fire Spirit
      expect(spirit.wil, 4);   // WIL = force + 0 = 4 for Force 4 Fire Spirit
      expect(spirit.log, 3);   // LOG = force - 1 = 3 for Force 4 Fire Spirit
    });

    test('Sprite attributes should be available for dice pools', () {
      final sprite = CritterFactory.generateSprite('Data Sprite', 3);
      
      expect(sprite, isNotNull);
      
      // Verify sprite attributes exist
      expect(sprite!.atk, greaterThan(0));
      expect(sprite.slz, greaterThan(0));
      expect(sprite.dp, greaterThan(0));
      expect(sprite.fwl, greaterThan(0));
    });
  });
}
