import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';

void main() {
  group('Expression Evaluation Demo', () {
    test('Rating expressions work as described in the requirements', () {
      // Example: "(Rating * 3)F" for a rating 4 item should render as "12F"
      final result = ShadowrunItem.evaluateRatingExpression('(Rating * 3)F', 4);
      expect(result['display'], equals('12F'), 
        reason: 'Rating 4 * 3 should display as 12F as requested');
      expect(result['tooltip'], equals('(Rating * 3)F'), 
        reason: 'Tooltip should show original expression for reference');
      

    });

    test('Ability score expressions work as described in the requirements', () {
      final attributes = {'STR': 4, 'AGI': 3};
      
      // Example: "({STR})S" with STR=4 should render as "4S"
      final result1 = ShadowrunItem.evaluateAbilityExpression('({STR})S', attributes: attributes);
      expect(result1['display'], equals('4S'), 
        reason: 'STR 4 should display as 4S as requested');
      
      // Example: "({STR}+1)P" with STR=4 should render as "5P"
      final result2 = ShadowrunItem.evaluateAbilityExpression('({STR}+1)P', attributes: attributes);
      expect(result2['display'], equals('5P'), 
        reason: 'STR 4 + 1 should display as 5P as requested');
      

    });

    test('Practical examples from Shadowrun weapons', () {
      final attributes = {
        'STR': 4, 'BOD': 3, 'AGI': 5, 'REA': 4,
        'CHA': 2, 'INT': 6, 'LOG': 5, 'WIL': 4,
        'EDG': 3, 'MAG': 0, 'RES': 0,
      };
      
      // Unarmed strike damage: ({STR})S
      final unarmed = ShadowrunItem.evaluateAbilityExpression('({STR})S', attributes: attributes);
      expect(unarmed['display'], equals('4S'));
      
      // Knife damage: ({STR}+1)P  
      final knife = ShadowrunItem.evaluateAbilityExpression('({STR}+1)P', attributes: attributes);
      expect(knife['display'], equals('5P'));
      
    });

    test('Rating-based gear examples', () {
      // Examples of rating-based expressions that might appear in gear
      
      // Rating 3 item with capacity (Rating * 2)
      final capacity = ShadowrunItem.evaluateRatingExpression('(Rating * 2)', 3);
      expect(capacity['display'], equals('6'));
      
      // Rating 5 item with force (Rating * 1)F
      final force = ShadowrunItem.evaluateRatingExpression('(Rating * 1)F', 5);
      expect(force['display'], equals('5F'));
      

    });
  });
}
