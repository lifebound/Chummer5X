import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/utils/skill_attribute_map.dart';
import 'package:chummer5x/models/attributes.dart';
void main() {
  group('Skill Defaulting Tests', () {
    late List<Attribute> testAttributes;

    setUp(() {
      testAttributes = [
        const Attribute(
          name: 'AGI',
          metatypeCategory: '',
          totalValue: 5,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 5,
          karma: 0,
        ),
        const Attribute(
          name: 'LOG',
          metatypeCategory: '',
          totalValue: 4,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 4,
          karma: 0,
        ),
      ];
    });

    test('Skills that allow defaulting should use attribute - 1', () {
      // Archery allows defaulting and uses AGI
      final rating = calculateTotalSkillRating('Archery', 0, testAttributes);
      expect(rating, equals(4)); // AGI (5) - 1 = 4
    });

    test('Skills that don\'t allow defaulting should return 0', () {
      // Electronic Warfare doesn't allow defaulting
      final rating = calculateTotalSkillRating('Electronic Warfare', 0, testAttributes);
      expect(rating, equals(0));
    });

    test('Skills with points should use normal calculation', () {
      // Archery with 3 skill points should use AGI + skill rating
      final rating = calculateTotalSkillRating('Archery', 3, testAttributes);
      expect(rating, equals(8)); // AGI (5) + skill (3) = 8
    });

    test('Priority skills with defaulting should get +2 bonus', () {
      // Archery defaulting with priority skill bonus
      final rating = calculateTotalSkillRating('Archery', 0, testAttributes, isPrioritySkill: true);
      expect(rating, equals(7)); // AGI (5) - 0 (not defaulted) + 2 (priority) = 7
    });

    test('Priority skills that don\'t allow defaulting but have priority should work normally', () {
      // Electronic Warfare with priority skill but 0 base skill points
      // Priority bonus makes it have effective skill points, so normal calculation
      final rating = calculateTotalSkillRating('Electronic Warfare', 0, testAttributes, isPrioritySkill: true);
      expect(rating, equals(6)); // LOG (4) + priority (2) = 6
    });

    test('Non-defaulting skills with points should use normal calculation', () {
      // Electronic Warfare with 2 skill points should use LOG + skill rating
      final rating = calculateTotalSkillRating('Electronic Warfare', 2, testAttributes);
      expect(rating, equals(6)); // LOG (4) + skill (2) = 6
    });

    test('Non-defaulting priority skills with points should work normally', () {
      // Electronic Warfare with priority skill and 1 point
      final rating = calculateTotalSkillRating('Electronic Warfare', 1, testAttributes, isPrioritySkill: true);
      expect(rating, equals(7)); // LOG (4) + skill (1) + priority (2) = 7
    });

    test('skillAllowsDefaulting should correctly identify defaulting skills', () {
      expect(skillAllowsDefaulting('Archery'), isTrue);
      expect(skillAllowsDefaulting('Electronic Warfare'), isFalse);
      expect(skillAllowsDefaulting('Pilot Aerospace'), isFalse);
      expect(skillAllowsDefaulting('Running'), isTrue);
    });

    test('Specializations should not apply to non-defaulting skills with 0 points', () {
      // Electronic Warfare with specialization but 0 points
      final rating = calculateSpecializedSkillRating(
        'Electronic Warfare', 
        0, 
        testAttributes, 
        hasSpecialization: true
      );
      expect(rating, equals(0)); // Still 0, no specialization bonus
    });

    test('Specializations should apply to defaulting skills', () {
      // Archery defaulting with specialization
      final rating = calculateSpecializedSkillRating(
        'Archery', 
        0, 
        testAttributes, 
        hasSpecialization: true
      );
      expect(rating, equals(6)); // (AGI - 1) + specialization = 4 + 2 = 6
    });

    test('Specializations should apply to non-defaulting skills with points', () {
      // Electronic Warfare with 2 points and specialization
      final rating = calculateSpecializedSkillRating(
        'Electronic Warfare', 
        2, 
        testAttributes, 
        hasSpecialization: true
      );
      expect(rating, equals(8)); // LOG (4) + skill (2) + specialization (2) = 8
    });
  });
}
