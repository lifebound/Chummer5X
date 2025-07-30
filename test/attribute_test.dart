import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/attributes.dart';
import 'package:chummer5x/models/shadowrun_character.dart';
import 'package:chummer5x/models/condition_monitor.dart';

void main() {
  // Test cases for attribute calculations

  group('Attribute Limits', () {
    final character = ShadowrunCharacter(
        attributes: [
          const Attribute(name: 'BOD', totalValue: 4.0, metatypeCategory: 'Physical',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 5.0, karma: 0.0),
          const Attribute(name: 'AGI', totalValue: 4.0, metatypeCategory: 'Physical',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 4.0, karma: 0.0),
          const Attribute(name: 'REA', totalValue: 8.0, metatypeCategory: 'Physical',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 3.0, karma: 0.0),
          const Attribute(name: 'STR', totalValue: 5.0, metatypeCategory: 'Physical',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 2.0, karma: 0.0),
          const Attribute(name: 'CHA', totalValue: 2.0, metatypeCategory: 'Social',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 1.0, karma: 0.0),
          const Attribute(name: 'INT', totalValue: 4.0, metatypeCategory: 'Mental',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 3.0, karma: 0.0),
          const Attribute(name: 'LOG', totalValue: 6.0, metatypeCategory: 'Mental',
            metatypeMin:    1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 4.0, karma: 0.0),
          const Attribute(name: 'WIL', totalValue: 6.0, metatypeCategory: 'Mental',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 2.0, karma: 0.0),
          const Attribute(name: 'EDG', totalValue: 6.0, metatypeCategory: 'Special',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 3.0, karma: 0.0),
          const Attribute(name: 'MAG', totalValue: 5.0, metatypeCategory: 'Special',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 2.0, karma: 0.0),
          const Attribute(name: 'MAGAdept', totalValue: 3.0, metatypeCategory: 'Special',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 1.0, karma: 0.0),
          const Attribute(name: 'RES', totalValue: 4.0, metatypeCategory: 'Special',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 2.0, karma: 0.0),
          const Attribute(name: 'ESS', totalValue: 5.45, metatypeCategory: 'Special',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 3.0, karma: 0.0),
          const Attribute(name: 'DEP', totalValue: 2.0, metatypeCategory: 'Special',
            metatypeMin: 1.0, metatypeMax: 6.0, metatypeAugMax: 9.0, base: 1.0, karma: 0.0),
        ],
        skills: [],
        limits: {},
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          stunCM: 10,
          physicalCMFilled: 0,
          stunCMFilled: 0,

        ),
      );
    test('should calculate limits correctly', () {
      

      expect(character.physicalLimit, 8);
      expect(character.socialLimit, 6);
      expect(character.mentalLimit, 8);
      expect(character.astralLimit, 8);
    });
  });
}