import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/shadowrun_character.dart';
import 'package:chummer5x/models/condition_monitor.dart';
import 'package:chummer5x/models/attributes.dart';

void main() {
  group('Condition Monitor Tests', () {
    late ShadowrunCharacter character;
    
    setUp(() {
      character = ShadowrunCharacter(
        name: 'Test Character',
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 3,
          physicalCMOverflow: 0,
          stunCM: 9,
          stunCMFilled: 2,
        ),
        skills: [],
        attributes: [
          const Attribute(
            name: 'Body',
            metatypeCategory: 'Physical',
            totalValue: 4,
            metatypeMin: 1,
            metatypeMax: 6,
            metatypeAugMax: 9,
            base: 4,
            karma: 0,
          ),
        ],
        limits: {},
        magEnabled: false,
        resEnabled: false,
        depEnabled: false,
      );
    });

    test('should increment physical condition monitor filled value', () {
      final updatedCharacter = character.adjustConditionMonitor(
        isPhysical: true,
        increment: true,
      );
      
      expect(updatedCharacter.conditionMonitor.physicalCMFilled, 4);
      expect(updatedCharacter.conditionMonitor.stunCMFilled, 2); // Should remain unchanged
    });

    test('should decrement physical condition monitor filled value', () {
      final updatedCharacter = character.adjustConditionMonitor(
        isPhysical: true,
        increment: false,
      );
      
      expect(updatedCharacter.conditionMonitor.physicalCMFilled, 2);
      expect(updatedCharacter.conditionMonitor.stunCMFilled, 2); // Should remain unchanged
    });

    test('should increment stun condition monitor filled value', () {
      final updatedCharacter = character.adjustConditionMonitor(
        isPhysical: false,
        increment: true,
      );
      
      expect(updatedCharacter.conditionMonitor.stunCMFilled, 3);
      expect(updatedCharacter.conditionMonitor.physicalCMFilled, 3); // Should remain unchanged
    });

    test('should decrement stun condition monitor filled value', () {
      final updatedCharacter = character.adjustConditionMonitor(
        isPhysical: false,
        increment: false,
      );
      
      expect(updatedCharacter.conditionMonitor.stunCMFilled, 1);
      expect(updatedCharacter.conditionMonitor.physicalCMFilled, 3); // Should remain unchanged
    });

    test('should not increment beyond total physical CM', () {
      final characterAtMax = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 10,
          physicalCMOverflow: 0, // No overflow allowed
          stunCM: 9,
          stunCMFilled: 2,
        ),
      );
      
      final updatedCharacter = characterAtMax.adjustConditionMonitor(
        isPhysical: true,
        increment: true,
      );
      
      expect(updatedCharacter.conditionMonitor.physicalCMFilled, 10); // Should remain at max when no overflow
    });

    test('should not increment beyond total stun CM', () {
      final characterAtMax = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 3,
          physicalCMOverflow: 0,
          stunCM: 9,
          stunCMFilled: 9,
        ),
      );
      
      final updatedCharacter = characterAtMax.adjustConditionMonitor(
        isPhysical: false,
        increment: true,
      );
      
      expect(updatedCharacter.conditionMonitor.stunCMFilled, 9); // Should remain at max
    });

    test('should not decrement below zero physical CM', () {
      final characterAtZero = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 0,
          physicalCMOverflow: 0,
          stunCM: 9,
          stunCMFilled: 2,
        ),
      );
      
      final updatedCharacter = characterAtZero.adjustConditionMonitor(
        isPhysical: true,
        increment: false,
      );
      
      expect(updatedCharacter.conditionMonitor.physicalCMFilled, 0); // Should remain at zero
    });

    test('should not decrement below zero stun CM', () {
      final characterAtZero = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 3,
          physicalCMOverflow: 0,
          stunCM: 9,
          stunCMFilled: 0,
        ),
      );
      
      final updatedCharacter = characterAtZero.adjustConditionMonitor(
        isPhysical: false,
        increment: false,
      );
      
      expect(updatedCharacter.conditionMonitor.stunCMFilled, 0); // Should remain at zero
    });

    test('should handle overflow when physical CM exceeds track', () {
      final characterAtMax = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 10,
          physicalCMOverflow: 4, // Max overflow allowed
          stunCM: 9,
          stunCMFilled: 2,
        ),
      );
      
      final updatedCharacter = characterAtMax.adjustConditionMonitor(
        isPhysical: true,
        increment: true,
      );
      
      // Should increment beyond the track (into overflow)
      expect(updatedCharacter.conditionMonitor.physicalCMFilled, 11); // Should increment into overflow
    });

    test('should decrease from overflow when decrementing from overflow state', () {
      final characterWithOverflow = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 12, // 2 points into overflow
          physicalCMOverflow: 4,
          stunCM: 9,
          stunCMFilled: 2,
        ),
      );
      
      final updatedCharacter = characterWithOverflow.adjustConditionMonitor(
        isPhysical: true,
        increment: false,
      );
      
      expect(updatedCharacter.conditionMonitor.physicalCMFilled, 11); // Should decrement overflow
    });

    test('should not exceed death threshold (physicalCMTotal + physicalCMOverflow)', () {
      final characterNearDeath = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 14, // At death threshold (10 + 4)
          physicalCMOverflow: 4,
          stunCM: 9,
          stunCMFilled: 2,
        ),
      );
      
      final updatedCharacter = characterNearDeath.adjustConditionMonitor(
        isPhysical: true,
        increment: true,
      );
      
      // Should not exceed death threshold
      expect(updatedCharacter.conditionMonitor.physicalCMFilled, 14); // Should remain at death threshold
    });

    // CM Penalty calculation tests
    test('CM Penalty: 0 stun, 0 physical should be 0', () {
      final testCharacter = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 0,
          physicalCMOverflow: 4,
          stunCM: 9,
          stunCMFilled: 0,
        ),
      );
      
      expect(testCharacter.conditionMonitorPenalty, 0);
    });

    test('CM Penalty: 0 stun, 2 physical should be 0', () {
      final testCharacter = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 2,
          physicalCMOverflow: 4,
          stunCM: 9,
          stunCMFilled: 0,
        ),
      );
      
      expect(testCharacter.conditionMonitorPenalty, 0);
    });

    test('CM Penalty: 3 stun, 0 physical should be -1', () {
      final testCharacter = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 0,
          physicalCMOverflow: 4,
          stunCM: 9,
          stunCMFilled: 3,
        ),
      );
      
      expect(testCharacter.conditionMonitorPenalty, -1);
    });

    test('CM Penalty: 3 stun, 2 physical should be -1', () {
      final testCharacter = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 2,
          physicalCMOverflow: 4,
          stunCM: 9,
          stunCMFilled: 3,
        ),
      );
      
      expect(testCharacter.conditionMonitorPenalty, -1);
    });

    test('CM Penalty: 3 stun, 3 physical should be -2', () {
      final testCharacter = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 3,
          physicalCMOverflow: 4,
          stunCM: 9,
          stunCMFilled: 3,
        ),
      );
      
      expect(testCharacter.conditionMonitorPenalty, -2);
    });

    test('CM Penalty: 0 stun, 11 physical should be -3', () {
      final testCharacter = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 11,
          physicalCMOverflow: 4,
          stunCM: 9,
          stunCMFilled: 0,
        ),
      );
      
      expect(testCharacter.conditionMonitorPenalty, -3);
    });

    test('CM Penalty: 0 stun, 12 physical (1 overflow) should be -3', () {
      final testCharacter = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 12,
          physicalCMOverflow: 4,
          stunCM: 9,
          stunCMFilled: 0,
        ),
      );
      
      expect(testCharacter.conditionMonitorPenalty, -3);
    });

    test('CM Penalty should update dynamically when adjusting condition monitors', () {
      // Start with no penalty
      final testCharacter = character.copyWith(
        conditionMonitor: const ConditionMonitor(
          physicalCM: 10,
          physicalCMFilled: 2,
          physicalCMOverflow: 4,
          stunCM: 9,
          stunCMFilled: 0,
        ),
      );
      expect(testCharacter.conditionMonitorPenalty, 0);
      
      // Add 1 more physical damage (total 3) - should trigger -1 penalty
      final step1 = testCharacter.adjustConditionMonitor(isPhysical: true, increment: true);
      expect(step1.conditionMonitorPenalty, -1);
      
      // Add 3 stun damage - should trigger additional -1 penalty
      var step2 = step1.adjustConditionMonitor(isPhysical: false, increment: true);
      step2 = step2.adjustConditionMonitor(isPhysical: false, increment: true);
      step2 = step2.adjustConditionMonitor(isPhysical: false, increment: true);
      expect(step2.conditionMonitorPenalty, -2);
      
      // Decrement back to 2 stun - should reduce penalty by 1
      final step3 = step2.adjustConditionMonitor(isPhysical: false, increment: false);
      expect(step3.conditionMonitorPenalty, -1);
    });
  });
}
