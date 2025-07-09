import 'package:flutter_test/flutter_test.dart';
import '../lib/models/shadowrun_character.dart';

void main() {
  group('Navigation Integration Tests', () {
    testWidgets('should show only basic tabs for mundane character', (WidgetTester tester) async {
      // This test verifies that a mundane character only shows basic navigation sections
      final mundaneCharacter = ShadowrunCharacter(
        name: 'Mundane Runner',
        attributes: [],
        skills: [],
        limits: {},
        conditionMonitor: ConditionMonitor(
          physicalCM: 10,
          stunCM: 10,
        ),
        isAdept: false,
        isMagician: false,
        isTechnomancer: false,
      );

      expect(mundaneCharacter.shouldShowSpellsTab, isFalse);
      expect(mundaneCharacter.shouldShowSpiritsTab, isFalse);
      expect(mundaneCharacter.shouldShowAdeptPowersTab, isFalse);
      expect(mundaneCharacter.shouldShowComplexFormsTab, isFalse);
      expect(mundaneCharacter.shouldShowSpritesTab, isFalse);
    });

    testWidgets('should show spells and spirits tabs for magician character', (WidgetTester tester) async {
      final magicianCharacter = ShadowrunCharacter(
        name: 'Hermetic Mage',
        attributes: [],
        skills: [],
        limits: {},
        conditionMonitor: ConditionMonitor(
          physicalCM: 10,
          stunCM: 10,
        ),
        isAdept: false,
        isMagician: true,
        isTechnomancer: false,
      );

      expect(magicianCharacter.shouldShowSpellsTab, isTrue);
      expect(magicianCharacter.shouldShowSpiritsTab, isTrue);
      expect(magicianCharacter.shouldShowAdeptPowersTab, isFalse);
      expect(magicianCharacter.shouldShowComplexFormsTab, isFalse);
      expect(magicianCharacter.shouldShowSpritesTab, isFalse);
    });

    testWidgets('should show adept powers tab for adept character', (WidgetTester tester) async {
      final adeptCharacter = ShadowrunCharacter(
        name: 'Physical Adept',
        attributes: [],
        skills: [],
        limits: {},
        conditionMonitor: ConditionMonitor(
          physicalCM: 10,
          stunCM: 10,
        ),
        isAdept: true,
        isMagician: false,
        isTechnomancer: false,
      );

      expect(adeptCharacter.shouldShowSpellsTab, isFalse);
      expect(adeptCharacter.shouldShowSpiritsTab, isFalse);
      expect(adeptCharacter.shouldShowAdeptPowersTab, isTrue);
      expect(adeptCharacter.shouldShowComplexFormsTab, isFalse);
      expect(adeptCharacter.shouldShowSpritesTab, isFalse);
    });

    testWidgets('should show complex forms and sprites tabs for technomancer character', (WidgetTester tester) async {
      final technomancerCharacter = ShadowrunCharacter(
        name: 'Matrix Specialist',
        attributes: [],
        skills: [],
        limits: {},
        conditionMonitor: ConditionMonitor(
          physicalCM: 10,
          stunCM: 10,
        ),
        isAdept: false,
        isMagician: false,
        isTechnomancer: true,
      );

      expect(technomancerCharacter.shouldShowSpellsTab, isFalse);
      expect(technomancerCharacter.shouldShowSpiritsTab, isFalse);
      expect(technomancerCharacter.shouldShowAdeptPowersTab, isFalse);
      expect(technomancerCharacter.shouldShowComplexFormsTab, isTrue);
      expect(technomancerCharacter.shouldShowSpritesTab, isTrue);
    });

    testWidgets('should show all relevant tabs for mystic adept (hybrid character)', (WidgetTester tester) async {
      final mysticAdeptCharacter = ShadowrunCharacter(
        name: 'Mystic Adept',
        attributes: [],
        skills: [],
        limits: {},
        conditionMonitor: ConditionMonitor(
          physicalCM: 10,
          stunCM: 10,
        ),
        isAdept: true,
        isMagician: true,
        isTechnomancer: false,
      );

      expect(mysticAdeptCharacter.shouldShowSpellsTab, isTrue);
      expect(mysticAdeptCharacter.shouldShowSpiritsTab, isTrue);
      expect(mysticAdeptCharacter.shouldShowAdeptPowersTab, isTrue);
      expect(mysticAdeptCharacter.shouldShowComplexFormsTab, isFalse);
      expect(mysticAdeptCharacter.shouldShowSpritesTab, isFalse);
    });
  });
}
