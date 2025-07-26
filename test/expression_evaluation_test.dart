import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';

void main() {
  group('Expression Evaluation Tests', () {
    test('Rating expression evaluation', () {
      // Test rating expression like "(Rating * 3)F"
      final result1 = ShadowrunItem.evaluateRatingExpression('(Rating * 3)F', 4);
      expect(result1['display'], equals('12F'), 
        reason: 'Rating 4 * 3 should equal 12 with F suffix');
      expect(result1['tooltip'], equals('(Rating * 3)F'), 
        reason: 'Tooltip should contain original expression');

      // Test rating expression without suffix
      final result2 = ShadowrunItem.evaluateRatingExpression('(Rating * 2)', 5);
      expect(result2['display'], equals('10'), 
        reason: 'Rating 5 * 2 should equal 10 without suffix');
      expect(result2['tooltip'], equals('(Rating * 2)'), 
        reason: 'Tooltip should contain original expression');

      // Test case insensitive matching
      final result3 = ShadowrunItem.evaluateRatingExpression('(rating * 1)S', 3);
      expect(result3['display'], equals('3S'), 
        reason: 'Case insensitive rating expression should work');

      // Test non-rating expression should pass through unchanged
      final result4 = ShadowrunItem.evaluateRatingExpression('Normal Text', 4);
      expect(result4['display'], equals('Normal Text'), 
        reason: 'Non-rating expressions should pass through unchanged');
      expect(result4['tooltip'], equals('Normal Text'), 
        reason: 'Non-rating expression tooltips should match display');
    });

    test('Ability expression evaluation', () {
      final attributes = {
        'STR': 4, 'BOD': 3, 'AGI': 5, 'REA': 4,
        'CHA': 2, 'INT': 6, 'LOG': 5, 'WIL': 4,
        'EDG': 3, 'MAG': 0, 'RES': 0,
      };

      // Test basic ability reference
      final result1 = ShadowrunItem.evaluateAbilityExpression('({STR})S', attributes: attributes);
      expect(result1['display'], equals('4S'), 
        reason: 'STR 4 should display as 4S');
      expect(result1['tooltip'], equals('({STR})S'), 
        reason: 'Tooltip should contain original expression');

      // Test ability with positive modifier
      final result2 = ShadowrunItem.evaluateAbilityExpression('({STR}+1)P', attributes: attributes);
      expect(result2['display'], equals('5P'), 
        reason: 'STR 4 + 1 should display as 5P');
      expect(result2['tooltip'], equals('({STR}+1)P'), 
        reason: 'Tooltip should contain original expression');

      // Test ability with negative modifier
      final result3 = ShadowrunItem.evaluateAbilityExpression('({AGI}-2)M', attributes: attributes);
      expect(result3['display'], equals('3M'), 
        reason: 'AGI 5 - 2 should display as 3M');

      // Test case insensitive matching
      final result4 = ShadowrunItem.evaluateAbilityExpression('({str})S', attributes: attributes);
      expect(result4['display'], equals('4S'), 
        reason: 'Case insensitive ability expressions should work');

      // Test with no attributes provided (should use defaults)
      final result5 = ShadowrunItem.evaluateAbilityExpression('({STR})S');
      expect(result5['display'], equals('1S'), 
        reason: 'Default STR should be 1');

      // Test non-ability expression should pass through unchanged
      final result6 = ShadowrunItem.evaluateAbilityExpression('Normal Text', attributes: attributes);
      expect(result6['display'], equals('Normal Text'), 
        reason: 'Non-ability expressions should pass through unchanged');
    });

    test('Edge cases', () {
      // Test invalid rating multiplier should pass through unchanged (not a valid pattern)
      final result1 = ShadowrunItem.evaluateRatingExpression('(Rating * abc)F', 4);
      expect(result1['display'], equals('(Rating * abc)F'), 
        reason: 'Invalid multiplier patterns should pass through unchanged');

      // Test unknown attribute should default to 0
      final result2 = ShadowrunItem.evaluateAbilityExpression('({XYZ})S', attributes: {'STR': 4});
      expect(result2['display'], equals('0S'), 
        reason: 'Unknown attributes should default to 0');

      // Test malformed expressions
      final result3 = ShadowrunItem.evaluateRatingExpression('(Rating *)', 4);
      expect(result3['display'], equals('(Rating *)'), 
        reason: 'Malformed rating expressions should pass through unchanged');

      final result4 = ShadowrunItem.evaluateAbilityExpression('({STR})', attributes: {'STR': 4});
      expect(result4['display'], equals('({STR})'), 
        reason: 'Ability expressions without suffix should pass through unchanged');
    });
  });
}
