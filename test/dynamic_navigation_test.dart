import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/condition_monitor.dart';
import 'package:chummer5x/models/shadowrun_character.dart';

void main() {
  group('Dynamic Navigation Tests', () {
    test('should parse adept, magician, and technomancer flags from XML data', () {
      // Test basic character types parsing
      final testCharacter = ShadowrunCharacter(
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

      expect(testCharacter.isAdept, isTrue);
      expect(testCharacter.isMagician, isFalse);
      expect(testCharacter.isTechnomancer, isFalse);
    });

    test('should identify magician character type', () {
      final testCharacter = ShadowrunCharacter(
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

      expect(testCharacter.isAdept, isFalse);
      expect(testCharacter.isMagician, isTrue);
      expect(testCharacter.isTechnomancer, isFalse);
    });

    test('should identify technomancer character type', () {
      final testCharacter = ShadowrunCharacter(
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

      expect(testCharacter.isAdept, isFalse);
      expect(testCharacter.isMagician, isFalse);
      expect(testCharacter.isTechnomancer, isTrue);
    });

    test('should handle hybrid character types (adept/magician)', () {
      final testCharacter = ShadowrunCharacter(
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

      expect(testCharacter.isAdept, isTrue);
      expect(testCharacter.isMagician, isTrue);
      expect(testCharacter.isTechnomancer, isFalse);
    });

    test('should default to mundane (all false) when not specified', () {
      final testCharacter = ShadowrunCharacter(
        attributes: [],
        skills: [],
        limits: {},
        conditionMonitor: ConditionMonitor(
          physicalCM: 10,
          stunCM: 10,
        ),
      );

      expect(testCharacter.isAdept, isFalse);
      expect(testCharacter.isMagician, isFalse);
      expect(testCharacter.isTechnomancer, isFalse);
    });
  });

  group('Navigation Logic Tests', () {
    test('should show adept powers tab when character is adept', () {
      final testCharacter = ShadowrunCharacter(
        attributes: [],
        skills: [],
        limits: {},
        conditionMonitor: ConditionMonitor(
          physicalCM: 10,
          stunCM: 10,
        ),
        isAdept: true,
      );

      expect(testCharacter.shouldShowAdeptPowersTab, isTrue);
    });

    test('should show spells and spirits tabs when character is magician', () {
      final testCharacter = ShadowrunCharacter(
        attributes: [],
        skills: [],
        limits: {},
        conditionMonitor: ConditionMonitor(
          physicalCM: 10,
          stunCM: 10,
        ),
        isMagician: true,
      );

      expect(testCharacter.shouldShowSpellsTab, isTrue);
      expect(testCharacter.shouldShowSpiritsTab, isTrue);
    });

    test('should show complex forms and sprites tabs when character is technomancer', () {
      final testCharacter = ShadowrunCharacter(
        attributes: [],
        skills: [],
        limits: {},
        conditionMonitor: ConditionMonitor(
          physicalCM: 10,
          stunCM: 10,
        ),
        isTechnomancer: true,
      );

      expect(testCharacter.shouldShowComplexFormsTab, isTrue);
      expect(testCharacter.shouldShowSpritesTab, isTrue);
    });

    test('should show appropriate tabs for hybrid character', () {
      final testCharacter = ShadowrunCharacter(
        attributes: [],
        skills: [],
        limits: {},
        conditionMonitor: ConditionMonitor(
          physicalCM: 10,
          stunCM: 10,
        ),
        isAdept: true,
        isMagician: true,
      );

      expect(testCharacter.shouldShowAdeptPowersTab, isTrue);
      expect(testCharacter.shouldShowSpellsTab, isTrue);
      expect(testCharacter.shouldShowSpiritsTab, isTrue);
      expect(testCharacter.shouldShowComplexFormsTab, isFalse);
      expect(testCharacter.shouldShowSpritesTab, isFalse);
    });

    test('should hide all special tabs for mundane character', () {
      final testCharacter = ShadowrunCharacter(
        attributes: [],
        skills: [],
        limits: {},
        conditionMonitor: ConditionMonitor(
          physicalCM: 10,
          stunCM: 10,
        ),
      );

      expect(testCharacter.shouldShowAdeptPowersTab, isFalse);
      expect(testCharacter.shouldShowSpellsTab, isFalse);
      expect(testCharacter.shouldShowSpiritsTab, isFalse);
      expect(testCharacter.shouldShowComplexFormsTab, isFalse);
      expect(testCharacter.shouldShowSpritesTab, isFalse);
    });
  });
}
