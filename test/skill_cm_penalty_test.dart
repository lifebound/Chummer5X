import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/shadowrun_character.dart';
import 'package:chummer5x/utils/skill_attribute_map.dart';

void main() {
  group('Skill CM Penalty Tests', () {
    late List<Attribute> testAttributes;
    
    setUp(() {
      testAttributes = [
        const Attribute(
          name: 'AGI',
          metatypeCategory: 'Physical',
          totalValue: 4,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 4,
          karma: 0,
        ),
        const Attribute(
          name: 'RES',
          metatypeCategory: 'Special',
          totalValue: 7,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 7,
          karma: 0,
        ),
      ];
    });

    test('Non-defaultable skill with 0 points and CM penalty should remain 0', () {
      // Aeronautics Mechanic (non-defaultable) with 0 points, CM penalty -1
      final skillTotal = calculateTotalSkillRating(
        'Aeronautics Mechanic', 
        0, 
        testAttributes, 
        isPrioritySkill: false,
        conditionMonitorPenalty: -1,
      );
      
      expect(skillTotal, 0); // Should remain 0, never go below
    });

    test('Defaultable skill with 0 points and CM penalty should apply penalty to default', () {
      // Archery (defaultable) with 0 points, AGI 4, CM penalty -1
      // Default would be 4 - 1 = 3, then CM penalty: 3 - 1 = 2
      final skillTotal = calculateTotalSkillRating(
        'Archery', 
        0, 
        testAttributes, 
        isPrioritySkill: false,
        conditionMonitorPenalty: -1,
      );
      
      expect(skillTotal, 2); // AGI(4) - 1 (default) - 1 (CM penalty) = 2
    });

    test('Skill with points and CM penalty should apply penalty but not go below 0', () {
      // Registering with 6 points (4 base + 2 priority), RES 7, CM penalty -2
      // Should be: 6 + 7 - 2 = 11
      final skillTotal = calculateTotalSkillRating(
        'Registering', 
        4, // base points
        testAttributes, 
        isPrioritySkill: true, // adds +2 priority bonus
        conditionMonitorPenalty: -2,
      );
      
      expect(skillTotal, 11); // 4 (base) + 2 (priority) + 7 (RES) - 2 (CM penalty) = 11
    });

    test('CM penalty should never reduce skill below 0', () {
      // Test extreme case where CM penalty would make skill negative
      final skillTotal = calculateTotalSkillRating(
        'Archery', 
        0, 
        testAttributes, 
        isPrioritySkill: false,
        conditionMonitorPenalty: -10, // Extreme penalty
      );
      
      expect(skillTotal, 0); // Should clamp to 0, never negative
    });

    test('Specialized skill should apply CM penalty correctly', () {
      // Test that specialization bonus is applied after CM penalty
      final skillTotal = calculateSpecializedSkillRating(
        'Registering', 
        4, // base points
        testAttributes, 
        isPrioritySkill: true,
        hasSpecialization: true,
        conditionMonitorPenalty: -2,
      );
      
      expect(skillTotal, 13); // 4 (base) + 2 (priority) + 7 (RES) - 2 (CM penalty) + 2 (specialization) = 13
    });
  });
}
