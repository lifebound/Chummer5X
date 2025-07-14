import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/shadowrun_character.dart';

void main() {
  group('Quality Tests', () {
    test('Quality should be created with all required fields', () {
      const quality = Quality(
        name: 'Ambidextrous',
        source: 'SR5',
        page: '72',
        karmaCost: 4,
        qualityType: QualityType.positive,
      );

      expect(quality.name, 'Ambidextrous');
      expect(quality.source, 'SR5');
      expect(quality.page, '72');
      expect(quality.karmaCost, 4);
    });

    test('Quality should handle negative karma costs for flaws', () {
      const flaw = Quality(
        name: 'Bad Luck',
        source: 'SR5',
        page: '79',
        karmaCost: -12,
        qualityType: QualityType.negative
      );

      expect(flaw.name, 'Bad Luck');
      expect(flaw.karmaCost, -12);
      expect(flaw.karmaCost < 0, true, reason: 'Flaws should have negative karma costs');
    });

    test('Quality should handle zero karma cost for free qualities', () {
      const freeQuality = Quality(
        name: 'Human Variant',
        source: 'SR5',
        page: '66',
        karmaCost: 0,
        qualityType: QualityType.positive
      );

      expect(freeQuality.karmaCost, 0);
    });
  });

  group('ShadowrunCharacter Qualities Tests', () {
    test('Character should be created with empty qualities list by default', () {
      final character = ShadowrunCharacter(
        name: 'Test Character',
        attributes: [],
        skills: [],
        conditionMonitor: const ConditionMonitor(),
      );

      expect(character.qualities, null);
    });

    test('Character should be created with provided qualities', () {
      const qualities = [
        Quality(
          name: 'Ambidextrous',
          source: 'SR5',
          page: '72',
          karmaCost: 4,
          qualityType: QualityType.positive
        ),
        Quality(
          name: 'Analytical Mind',
          source: 'SR5',
          page: '72',
          karmaCost: 5,
          qualityType: QualityType.positive
        ),
      ];

      final character = ShadowrunCharacter(
        name: 'Test Character',
        attributes: [],
        skills: [],
        qualities: qualities,
        conditionMonitor: const ConditionMonitor(),
      );

      expect(character.qualities, isNotNull);
      expect(character.qualities!.length, 2);
      expect(character.qualities![0].name, 'Ambidextrous');
      expect(character.qualities![1].name, 'Analytical Mind');
    });

    test('Character should handle mix of positive and negative karma qualities', () {
      const qualities = [
        Quality(
          name: 'Ambidextrous',
          source: 'SR5',
          page: '72',
          karmaCost: 4,
          qualityType: QualityType.positive
        ),
        Quality(
          name: 'Bad Luck',
          source: 'SR5',
          page: '79',
          karmaCost: -12,
          qualityType: QualityType.negative
        ),
        Quality(
          name: 'Distinctive Style',
          source: 'SR5',
          page: '80',
          karmaCost: -5,
          qualityType: QualityType.negative
        ),
      ];

      final character = ShadowrunCharacter(
        name: 'Test Character',
        attributes: [],
        skills: [],
        qualities: qualities,
        conditionMonitor: const ConditionMonitor(),
      );

      final positiveQualities = character.qualities!.where((q) => q.karmaCost > 0).toList();
      final negativeQualities = character.qualities!.where((q) => q.karmaCost < 0).toList();

      expect(positiveQualities.length, 1);
      expect(negativeQualities.length, 2);
      expect(positiveQualities[0].name, 'Ambidextrous');
      expect(negativeQualities.map((q) => q.name), containsAll(['Bad Luck', 'Distinctive Style']));
    });

    test('Character copyWith should preserve qualities when not specified', () {
      const originalQualities = [
        Quality(
          name: 'Ambidextrous',
          source: 'SR5',
          page: '72',
          karmaCost: 4,
          qualityType: QualityType.positive
        ),
      ];

      final originalCharacter = ShadowrunCharacter(
        name: 'Original Character',
        attributes: [],
        skills: [],
        qualities: originalQualities,
        conditionMonitor: const ConditionMonitor(),
      );

      final copiedCharacter = originalCharacter.copyWith(name: 'Updated Character');

      expect(copiedCharacter.name, 'Updated Character');
      expect(copiedCharacter.qualities, originalQualities);
      expect(copiedCharacter.qualities![0].name, 'Ambidextrous');
    });

    test('Character copyWith should update qualities when specified', () {
      const originalQualities = [
        Quality(
          name: 'Ambidextrous',
          source: 'SR5',
          page: '72',
          karmaCost: 4,
          qualityType: QualityType.positive
        ),
      ];

      const newQualities = [
        Quality(
          name: 'Analytical Mind',
          source: 'SR5',
          page: '72',
          karmaCost: 5,
          qualityType: QualityType.positive
        ),
        Quality(
          name: 'Astral Chameleon',
          source: 'SR5',
          page: '72',
          karmaCost: 10,
          qualityType: QualityType.positive
        ),
      ];

      final originalCharacter = ShadowrunCharacter(
        name: 'Test Character',
        attributes: [],
        skills: [],
        qualities: originalQualities,
        conditionMonitor: const ConditionMonitor(),
      );

      final updatedCharacter = originalCharacter.copyWith(qualities: newQualities);

      expect(updatedCharacter.qualities, newQualities);
      expect(updatedCharacter.qualities!.length, 2);
      expect(updatedCharacter.qualities![0].name, 'Analytical Mind');
      expect(updatedCharacter.qualities![1].name, 'Astral Chameleon');
    });

    test('Character copyWith should handle clearing qualities', () {
      const originalQualities = [
        Quality(
          name: 'Ambidextrous',
          source: 'SR5',
          page: '72',
          karmaCost: 4,
          qualityType: QualityType.positive
        ),
      ];

      final originalCharacter = ShadowrunCharacter(
        name: 'Test Character',
        attributes: [],
        skills: [],
        qualities: originalQualities,
        conditionMonitor: const ConditionMonitor(),
      );

      final clearedCharacter = originalCharacter.copyWith(qualities: []);

      expect(clearedCharacter.qualities, isNotNull);
      expect(clearedCharacter.qualities!.isEmpty, true);
    });

    test('canFetterSprite should return true when character has Resonant Stream: Technoshaman quality', () {
      const qualities = [
        Quality(
          name: 'Resonant Stream: Technoshaman',
          source: 'SR5',
          page: '78',
          karmaCost: 5,
          qualityType: QualityType.positive
        ),
      ];

      final character = ShadowrunCharacter(
        name: 'Technomancer',
        attributes: [],
        skills: [],
        qualities: qualities,
        conditionMonitor: const ConditionMonitor(),
      );

      expect(character.canFetterSprite, true);
    });

    test('canFetterSprite should return false when character does not have Resonant Stream: Technoshaman quality', () {
      const qualities = [
        Quality(
          name: 'Some Other Quality',
          source: 'SR5',
          page: '72',
          karmaCost: 4,
          qualityType: QualityType.negative
        ),
      ];

      final character = ShadowrunCharacter(
        name: 'Regular Character',
        attributes: [],
        skills: [],
        qualities: qualities,
        conditionMonitor: const ConditionMonitor(),
      );

      expect(character.canFetterSprite, false);
    });

    test('canFetterSprite should return false when character has no qualities', () {
      final character = ShadowrunCharacter(
        name: 'No Qualities Character',
        attributes: [],
        skills: [],
        conditionMonitor: const ConditionMonitor(),
      );

      expect(character.canFetterSprite, false);
    });

    test('canFetterSprite should return false when character has empty qualities list', () {
      final character = ShadowrunCharacter(
        name: 'Empty Qualities Character',
        attributes: [],
        skills: [],
        qualities: const [],
        conditionMonitor: const ConditionMonitor(),
      );

      expect(character.canFetterSprite, false);
    });
  });

  group('Quality Utility Tests', () {
    test('Should be able to find quality by name', () {
      const qualities = [
        Quality(
          name: 'Ambidextrous',
          source: 'SR5',
          page: '72',
          karmaCost: 4,
          qualityType: QualityType.positive
        ),
        Quality(
          name: 'Analytical Mind',
          source: 'SR5',
          page: '72',
          karmaCost: 5,
          qualityType: QualityType.positive
        ),
        Quality(
          name: 'Bad Luck',
          source: 'SR5',
          page: '79',
          karmaCost: -12,
          qualityType: QualityType.negative
        ),
      ];

      final character = ShadowrunCharacter(
        name: 'Test Character',
        attributes: [],
        skills: [],
        qualities: qualities,
        conditionMonitor: const ConditionMonitor(),
      );

      final foundQuality = character.qualities!.firstWhere(
        (quality) => quality.name == 'Analytical Mind',
        orElse: () => const Quality(name: '', source: '', page: '', karmaCost: 0, qualityType: QualityType.positive),
      );

      expect(foundQuality.name, 'Analytical Mind');
      expect(foundQuality.karmaCost, 5);
    });

    test('Should calculate total karma cost of all qualities', () {
      const qualities = [
        Quality(
          name: 'Ambidextrous',
          source: 'SR5',
          page: '72',
          karmaCost: 4,
          qualityType: QualityType.positive
        ),
        Quality(
          name: 'Analytical Mind',
          source: 'SR5',
          page: '72',
          karmaCost: 5,
          qualityType: QualityType.positive
        ),
        Quality(
          name: 'Bad Luck',
          source: 'SR5',
          page: '79',
          karmaCost: -12,
          qualityType: QualityType.negative
        ),
        Quality(
          name: 'Distinctive Style',
          source: 'SR5',
          page: '80',
          karmaCost: -5,
          qualityType: QualityType.negative
        ),
      ];

      final character = ShadowrunCharacter(
        name: 'Test Character',
        attributes: [],
        skills: [],
        qualities: qualities,
        conditionMonitor: const ConditionMonitor(),
      );

      final totalKarmaCost = character.qualities!
          .map((quality) => quality.karmaCost)
          .reduce((a, b) => a + b);

      expect(totalKarmaCost, -8); // 4 + 5 - 12 - 5 = -8
    });

    test('Should separate positive and negative qualities', () {
      const qualities = [
        Quality(
          name: 'Ambidextrous',
          source: 'SR5',
          page: '72',
          karmaCost: 4,
          qualityType: QualityType.positive
        ),
        Quality(
          name: 'Analytical Mind',
          source: 'SR5',
          page: '72',
          karmaCost: 5,
          qualityType: QualityType.positive
        ),
        Quality(
          name: 'Bad Luck',
          source: 'SR5',
          page: '79',
          karmaCost: -12,
          qualityType: QualityType.negative
        ),
        Quality(
          name: 'Free Quality',
          source: 'SR5',
          page: '66',
          karmaCost: 0,
          qualityType: QualityType.positive
        ),
      ];

      final character = ShadowrunCharacter(
        name: 'Test Character',
        attributes: [],
        skills: [],
        qualities: qualities,
        conditionMonitor: const ConditionMonitor(),
      );

      final positiveQualities = character.qualities!.where((q) => q.karmaCost > 0).toList();
      final negativeQualities = character.qualities!.where((q) => q.karmaCost < 0).toList();
      final freeQualities = character.qualities!.where((q) => q.karmaCost == 0).toList();

      expect(positiveQualities.length, 2);
      expect(negativeQualities.length, 1);
      expect(freeQualities.length, 1);
      expect(positiveQualities.map((q) => q.name), containsAll(['Ambidextrous', 'Analytical Mind']));
      expect(negativeQualities[0].name, 'Bad Luck');
      expect(freeQualities[0].name, 'Free Quality');
    });

    test('Should handle qualities with same name but different sources', () {
      const qualities = [
        Quality(
          name: 'Lucky',
          source: 'SR5',
          page: '74',
          karmaCost: 12,
          qualityType: QualityType.positive
        ),
        Quality(
          name: 'Lucky',
          source: 'RG',
          page: '155',
          karmaCost: 10,
          qualityType: QualityType.positive
        ),
      ];

      final character = ShadowrunCharacter(
        name: 'Test Character',
        attributes: [],
        skills: [],
        qualities: qualities,
        conditionMonitor: const ConditionMonitor(),
      );

      expect(character.qualities!.length, 2);
      expect(character.qualities!.every((q) => q.name == 'Lucky'), true);
      expect(character.qualities!.map((q) => q.source), containsAll(['SR5', 'RG']));
      expect(character.qualities!.map((q) => q.karmaCost), containsAll([12, 10]));
    });
  });
}
