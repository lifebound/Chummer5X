import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/shadowrun_character.dart';

void main(){

  group('Spirit Tests',(){
    test('Should create a Spirit with all required attributes', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Fire', 3);
      
      expect(spirit?.name, 'Spirit of Fire', reason: "name should equal 'Spirit of Fire'");
      expect(spirit?.type, CritterType.spirit, reason: "type should equal CritterType.spirit");
      expect(spirit?.force, 3, reason: "force should equal 3");
      expect(spirit?.bod, 4, reason: "body should equal 4"); // force(3) + BOD(1) = 4
      expect(spirit?.agi, 5, reason: "agility should equal 5"); // force(3) + AGI(2) = 5
      expect(spirit?.rea, 5, reason: "reaction should equal 5"); // force(3) + REA(2) = 5
      expect(spirit?.str, 5, reason: "strength should equal 5"); // force(3) + STR(2) = 5
      expect(spirit?.wil, 3, reason: "will should equal 3"); // force(3) + WIL(0) = 3
      expect(spirit?.log, 2, reason: "logic should equal 2"); // force(3) + LOG(-1) = 2
      expect(spirit?.intu, 4, reason: "intuition should equal 4"); // force(3) + INT(1) = 4
      expect(spirit?.cha, 3, reason: "charisma should equal 3"); // force(3) + CHA(0) = 3
      expect(spirit?.edg, 1, reason: "edge should equal 1"); // force(3) / 2 = 1
      expect(spirit?.powers, containsAll(['Accident', 'Confusion', 'Elemental Attack', 'Engulf', 'Guard', 'Noxious Breath', 'Search']), reason: "powers should contain all expected Fire Spirit powers");
    });

    test('Should calculate initiative correctly for Spirit', () {
      final spirit = Spirit(
        name: 'Initiative Test Spirit',
        type: CritterType.spirit,
        force: 6,
        initiativeType: 'Astral',
        initiativeDice: 4,
        baseSkills: {},
        powers: [],
        attributeModifiers: {},
      );

      expect(spirit.initiative, '11 + 4D6', reason: "initiative should be calculated correctly"); // rea(5) + intu(6) = 11
      expect(spirit.astralInitiative, '12 + 5D6', reason: "astral initiative should be calculated correctly"); // intu(6) * 2 = 12, dice = 5
    });

  group('Sprite Tests', () {
    
    test('Should make a Crack Sprite with correct type and force', () {
      final sprite = CritterFactory.generateSprite('Crack Sprite', 5);
      expect(sprite?.name, 'Crack Sprite');
      expect(sprite?.type, CritterType.sprite);
      expect(sprite?.force, 5);
      expect(sprite?.atk, 5); // ATK = 0 + force(5) = 5
      expect(sprite?.slz, 8); // SLZ = 3 + force(5) = 8
      expect(sprite?.dp, 7); // DP = 2 + force(5) = 7
      expect(sprite?.fwl, 6); // FWL = 1 + force(5) = 6
      expect(sprite?.powers, contains('Suppression'));
      expect(sprite?.baseSkills.keys, containsAll(['Computer', 'Electronic Warfare', 'Hacking']));
    });

    test('Should make a Courier Sprite with correct attributes', () {
      final sprite = CritterFactory.generateSprite('Courier Sprite', 4);
      expect(sprite?.name, 'Courier Sprite');
      expect(sprite?.type, CritterType.sprite);
      expect(sprite?.force, 4);
      expect(sprite?.atk, 4); // ATK = 0 + force(4) = 4
      expect(sprite?.slz, 7); // SLZ = 3 + force(4) = 7
      expect(sprite?.dp, 5); // DP = 1 + force(4) = 5
      expect(sprite?.fwl, 6); // FWL = 2 + force(4) = 6
      expect(sprite?.powers, containsAll(['Cookie', 'Hash']));
      expect(sprite?.baseSkills.keys, containsAll(['Computer', 'Hacking']));
    });

    test('Should make a Data Sprite with correct attributes', () {
      final sprite = CritterFactory.generateSprite('Data Sprite', 3);
      expect(sprite?.name, 'Data Sprite');
      expect(sprite?.type, CritterType.sprite);
      expect(sprite?.force, 3);
      expect(sprite?.atk, 2); // ATK = -1 + force(3) = 2
      expect(sprite?.slz, 3); // SLZ = 0 + force(3) = 3
      expect(sprite?.dp, 7); // DP = 4 + force(3) = 7
      expect(sprite?.fwl, 4); // FWL = 1 + force(3) = 4
      expect(sprite?.powers, containsAll(['Camouflage', 'Watermark']));
      expect(sprite?.baseSkills.keys, containsAll(['Computer', 'Electronic Warfare']));
    });

    test('Should make a Fault Sprite with correct attributes', () {
      final sprite = CritterFactory.generateSprite('Fault Sprite', 6);
      expect(sprite?.name, 'Fault Sprite');
      expect(sprite?.type, CritterType.sprite);
      expect(sprite?.force, 6);
      expect(sprite?.atk, 9); // ATK = 3 + force(6) = 9
      expect(sprite?.slz, 6); // SLZ = 0 + force(6) = 6
      expect(sprite?.dp, 7); // DP = 1 + force(6) = 7
      expect(sprite?.fwl, 8); // FWL = 2 + force(6) = 8
      expect(sprite?.powers, contains('Electron Storm'));
      expect(sprite?.baseSkills.keys, containsAll(['Computer', 'Cybercombat', 'Hacking']));
    });

    test('Should make a Machine Sprite with correct attributes', () {
      final sprite = CritterFactory.generateSprite('Machine Sprite', 2);
      expect(sprite?.name, 'Machine Sprite');
      expect(sprite?.type, CritterType.sprite);
      expect(sprite?.force, 2);
      expect(sprite?.atk, 3); // ATK = 1 + force(2) = 3
      expect(sprite?.slz, 2); // SLZ = 0 + force(2) = 2
      expect(sprite?.dp, 5); // DP = 3 + force(2) = 5
      expect(sprite?.fwl, 4); // FWL = 2 + force(2) = 4
      expect(sprite?.powers, containsAll(['Diagnostics', 'Gremlins', 'Stability']));
      expect(sprite?.baseSkills.keys, containsAll(['Computer', 'Electronic Warfare', 'Hardware']));
    });

    test('Should make a Companion Sprite with correct attributes', () {
      final sprite = CritterFactory.generateSprite('Companion Sprite', 4);
      expect(sprite?.name, 'Companion Sprite');
      expect(sprite?.type, CritterType.sprite);
      expect(sprite?.force, 4);
      expect(sprite?.atk, 3); // ATK = -1 + force(4) = 3
      expect(sprite?.slz, 5); // SLZ = 1 + force(4) = 5
      expect(sprite?.dp, 4); // DP = 0 + force(4) = 4
      expect(sprite?.fwl, 8); // FWL = 4 + force(4) = 8
      expect(sprite?.powers, containsAll(['Shield', 'Bodyguard']));
      expect(sprite?.baseSkills.keys, containsAll(['Computer', 'Electronic Warfare']));
    });

    test('Should make a Generalist Sprite with correct attributes', () {
      final sprite = CritterFactory.generateSprite('Generalist Sprite', 5);
      expect(sprite?.name, 'Generalist Sprite');
      expect(sprite?.type, CritterType.sprite);
      expect(sprite?.force, 5);
      expect(sprite?.atk, 5); // ATK = 0 + force(5) = 5
      expect(sprite?.slz, 8); // SLZ = 3 + force(5) = 8
      expect(sprite?.dp, 6); // DP = 1 + force(5) = 6
      expect(sprite?.fwl, 6); // FWL = 1 + force(5) = 6
      expect(sprite?.powers, contains('Any 2 Optional Powers'));
      expect(sprite?.baseSkills.keys, containsAll(['Hacking', 'Electronic Warfare']));
    });

    test('Should handle custom name override', () {
      final sprite = CritterFactory.generateSprite('Crack Sprite', 3, nameOverride: 'My Custom Sprite');
      expect(sprite?.name, 'My Custom Sprite');
      expect(sprite?.type, CritterType.sprite);
      expect(sprite?.force, 3);
    });

    test('Should return null for invalid sprite type', () {
      final sprite = CritterFactory.generateSprite('Invalid Sprite', 5);
      expect(sprite, isNull);
    });

    test('Should calculate initiative correctly', () {
      final sprite = CritterFactory.generateSprite('Data Sprite', 4);
      expect(sprite?.initiative, '12 + 4d6'); // DP(8) + force(4) = 12, dice = 4
    });

    test('Should handle edge cases with force 1', () {
      final sprite = CritterFactory.generateSprite('Data Sprite', 1);
      expect(sprite?.name, 'Data Sprite');
      expect(sprite?.force, 1);
      expect(sprite?.atk, 0); // ATK = -1 + force(1) = 0
      expect(sprite?.slz, 1); // SLZ = 0 + force(1) = 1
      expect(sprite?.dp, 5); // DP = 4 + force(1) = 5
      expect(sprite?.fwl, 2); // FWL = 1 + force(1) = 2
    });

    test('Should handle high force values', () {
      final sprite = CritterFactory.generateSprite('Fault Sprite', 12);
      expect(sprite?.name, 'Fault Sprite');
      expect(sprite?.force, 12);
      expect(sprite?.atk, 15); // ATK = 3 + force(12) = 15
      expect(sprite?.slz, 12); // SLZ = 0 + force(12) = 12
      expect(sprite?.dp, 13); // DP = 1 + force(12) = 13
      expect(sprite?.fwl, 14); // FWL = 2 + force(12) = 14
    });
  });

  group('Spirit Factory Tests', () {
    test('Should generate Air Spirit with correct attributes', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Air', 5);
      expect(spirit?.name, 'Spirit of Air', reason: "name should equal 'Spirit of Air'");
      expect(spirit?.type, CritterType.spirit, reason: "type should equal CritterType.spirit");
      expect(spirit?.force, 5, reason: "force should equal 5");
      expect(spirit?.bod, 3, reason: "body should equal 3"); // force(5) + BOD(-2) = 3
      expect(spirit?.agi, 8, reason: "agility should equal 8"); // force(5) + AGI(3) = 8
      expect(spirit?.rea, 9, reason: "reaction should equal 9"); // force(5) + REA(4) = 9
      expect(spirit?.str, 2, reason: "strength should equal 2"); // force(5) + STR(-3) = 2
      expect(spirit?.wil, 5, reason: "will should equal 5"); // force(5) + WIL(1) = 6
      expect(spirit?.log, 5, reason: "logic should equal 5"); // force(5) + LOG(0) = 5
      expect(spirit?.intu, 5, reason: "intuition should equal 5"); // force(5) + INT(2) = 7
      expect(spirit?.cha, 5, reason: "charisma should equal 5"); // force(5) + CHA(1) = 6
      expect(spirit?.edg, 2, reason: "edge should equal 2"); // force(5) + EDG(0) = 5
      expect(spirit?.powers, containsAll(['Accident', 'Confusion', 'Concealment', 'Elemental Attack', 'Engulf', 'Guard', 'Movement', 'Psychokinesis', 'Search']), reason: "powers should contain all expected powers");
      //expect(spirit?.optionalPowers, containsAll(['Astral Form', 'Materialization', 'Sapience']));
      expect(spirit?.baseSkills.keys, containsAll(['Assensing', 'Astral Combat', 'Perception', 'Running', 'Unarmed Combat']), reason: "base skills should contain all expected skills");
      expect(spirit?.special, 'Immune to gases, +2 dice vs. ranged attacks', reason: "special should match expected text");
    });

    test('Should generate Earth Spirit with correct attributes', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Earth', 4);
      expect(spirit?.name, 'Spirit of Earth', reason: "name should equal 'Spirit of Earth'");
      expect(spirit?.type, CritterType.spirit, reason: "type should equal CritterType.spirit");
      expect(spirit?.force, 4, reason: "force should equal 4");
      expect(spirit?.bod, 8, reason: "body should equal 8"); // force(4) + BOD(4) = 8
      expect(spirit?.agi, 2, reason: "agility should equal 2"); // force(4) + AGI(-2) = 2
      expect(spirit?.rea, 3, reason: "reaction should equal 3"); // force(4) + REA(-1) = 3
      expect(spirit?.str, 8, reason: "strength should equal 8"); // force(4) + STR(4) = 8
      expect(spirit?.wil, 4, reason: "will should equal 4"); // force(4) + WIL(3) = 7
      expect(spirit?.log, 3, reason: "logic should equal 3"); // force(4) + LOG(-1) = 3
      expect(spirit?.intu, 4, reason: "intuition should equal 4"); // force(4) + INT(0) = 4
      expect(spirit?.cha, 3, reason: "charisma should equal 3"); // force(4) + CHA(-1) = 3
      expect(spirit?.edg, 2, reason: "edge should equal 2"); // force(4) + EDG(0) = 4
      expect(spirit?.powers, containsAll(['Binding', 'Concealment', 'Elemental Attack', 'Guard', 'Hardened Armor', 'Movement', 'Search']), reason: "powers should contain all expected powers");
      expect(spirit?.special, 'Immune to petrification, +2 dice vs. spells', reason: "special should match expected text");
    });

    test('Should generate Fire Spirit with correct attributes', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Fire', 6);
      expect(spirit?.name, 'Spirit of Fire', reason: "name should equal 'Spirit of Fire'");
      expect(spirit?.type, CritterType.spirit, reason: "type should equal CritterType.spirit");
      expect(spirit?.force, 6, reason: "force should equal 6");
      expect(spirit?.bod, 7, reason: "body should equal 7"); // force(6) + BOD(1) = 7
      expect(spirit?.agi, 8, reason: "agility should equal 8"); // force(6) + AGI(2) = 8
      expect(spirit?.rea, 8, reason: "reaction should equal 8"); // force(6) + REA(2) = 8
      expect(spirit?.str, 8, reason: "strength should equal 8"); // force(6) + STR(2) = 8
      expect(spirit?.wil, 6, reason: "will should equal 6"); // force(6) + WIL(0) = 6
      expect(spirit?.log, 5, reason: "logic should equal 5"); // force(6) + LOG(-1) = 5
      expect(spirit?.intu, 7, reason: "intuition should equal 7"); // force(6) + INT(1) = 7
      expect(spirit?.cha, 6, reason: "charisma should equal 6"); // force(6) + CHA(0) = 6
      expect(spirit?.edg, 3, reason: "edge should equal 3"); // force(6) + EDG(0) = 6
      expect(spirit?.powers, containsAll(['Accident', 'Confusion', 'Elemental Attack', 'Engulf', 'Guard', 'Noxious Breath', 'Search']), reason: "powers should contain all expected powers");
      expect(spirit?.special, 'Immune to fire, vulnerable to water', reason: "special should match expected text");
    });

    test('Should generate Water Spirit with correct attributes', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Water', 3);
      expect(spirit?.name, 'Spirit of Water', reason: "name should equal 'Spirit of Water'");
      expect(spirit?.type, CritterType.spirit, reason: "type should equal CritterType.spirit");
      expect(spirit?.force, 3, reason: "force should equal 3");
      expect(spirit?.bod, 3, reason: "body should equal 3"); // force(3) + BOD(0) = 3
      expect(spirit?.agi, 4, reason: "agility should equal 4"); // force(3) + AGI(1) = 4
      expect(spirit?.rea, 5, reason: "reaction should equal 5"); // force(3) + REA(2) = 5
      expect(spirit?.str, 3, reason: "strength should equal 3"); // force(3) + STR(0) = 3
      expect(spirit?.wil, 5, reason: "will should equal 5"); // force(3) + WIL(2) = 5
      expect(spirit?.log, 3, reason: "logic should equal 3"); // force(3) + LOG(0) = 3
      expect(spirit?.intu, 4, reason: "intuition should equal 4"); // force(3) + INT(1) = 4
      expect(spirit?.cha, 5, reason: "charisma should equal 5"); // force(3) + CHA(2) = 5
      expect(spirit?.edg, 1, reason: "edge should equal 1"); // force(3) + EDG(0) = 1
      expect(spirit?.powers, containsAll(['Binding', 'Concealment', 'Confusion', 'Elemental Attack', 'Engulf', 'Guard', 'Movement', 'Weather Control']), reason: "powers should contain all expected powers");
      expect(spirit?.special, 'Vulnerable to fire, immune to drowning', reason: "special should match expected text");
    });

    test('Should generate Man Spirit with correct attributes', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Man', 5);
      expect(spirit?.name, 'Spirit of Man', reason: "name should equal 'Spirit of Man'");
      expect(spirit?.type, CritterType.spirit, reason: "type should equal CritterType.spirit");
      expect(spirit?.force, 5, reason: "force should equal 5");
      expect(spirit?.bod, 6, reason: "body should equal 6"); // force(5) + BOD(1) = 6
      expect(spirit?.agi, 5, reason: "agility should equal 5"); // force(5) + AGI(0) = 5
      expect(spirit?.rea, 5, reason: "reaction should equal 5"); // force(5) + REA(0) = 5
      expect(spirit?.str, 4, reason: "strength should equal 4"); // force(5) + STR(-1) = 4
      expect(spirit?.wil, 6, reason: "will should equal 6"); // force(5) + WIL(1) = 6
      expect(spirit?.log, 6, reason: "logic should equal 6"); // force(5) + LOG(1) = 6
      expect(spirit?.intu, 7, reason: "intuition should equal 7"); // force(5) + INT(2) = 7
      expect(spirit?.cha, 7, reason: "charisma should equal 7"); // force(5) + CHA(2) = 7
      expect(spirit?.edg, 2, reason: "edge should equal 2"); // force(5) + EDG(0) = 2
      expect(spirit?.powers, containsAll(['Accident', 'Confusion', 'Concealment', 'Guard', 'Influence', 'Search']), reason: "powers should contain all expected powers");
      expect(spirit?.special, 'Enhanced social interactions in urban areas', reason: "special should match expected text");
    });

    test('Should generate Beast Spirit with correct attributes', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Beasts', 4);
      expect(spirit?.name, 'Spirit of Beasts', reason: "name should equal 'Spirit of Beasts'");
      expect(spirit?.type, CritterType.spirit, reason: "type should equal CritterType.spirit");
      expect(spirit?.force, 4, reason: "force should equal 4");
      expect(spirit?.bod, 6, reason: "body should equal 6"); // force(4) + BOD(2) = 6
      expect(spirit?.agi, 5, reason: "agility should equal 5"); // force(4) + AGI(1) = 5
      expect(spirit?.rea, 6, reason: "reaction should equal 6"); // force(4) + REA(2) = 6
      expect(spirit?.str, 6, reason: "strength should equal 6"); // force(4) + STR(2) = 6
      expect(spirit?.wil, 4, reason: "will should equal 4"); // force(4) + WIL(0) = 4
      expect(spirit?.log, 3, reason: "logic should equal 3"); // force(4) + LOG(-1) = 3
      expect(spirit?.intu, 5, reason: "intuition should equal 5"); // force(4) + INT(1) = 5
      expect(spirit?.cha, 4, reason: "charisma should equal 4"); // force(4) + CHA(0) = 4
      expect(spirit?.edg, 2, reason: "edge should equal 2"); // force(4) + EDG(0) = 2
      expect(spirit?.powers, containsAll(['Animal Control', 'Concealment', 'Enhanced Senses', 'Fear', 'Guard', 'Movement', 'Track']), reason: "powers should contain all expected powers");
      expect(spirit?.special, 'Enhanced tracking and animal handling', reason: "special should match expected text");
    });

    test('Should generate Plant Spirit with correct attributes', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Plants', 2);
      expect(spirit?.name, 'Spirit of Plants', reason: "name should equal 'Spirit of Plants'");
      expect(spirit?.type, CritterType.spirit, reason: "type should equal CritterType.spirit");
      expect(spirit?.force, 2, reason: "force should equal 2");
      expect(spirit?.bod, 3, reason: "body should equal 3"); // force(2) + BOD(1) = 3
      expect(spirit?.agi, 1, reason: "agility should equal 1"); // force(2) + AGI(-1) = 1 (clamped to 1)
      expect(spirit?.rea, 1, reason: "reaction should equal 1"); // force(2) + REA(-1) = 1 (clamped to 1)
      expect(spirit?.str, 3, reason: "strength should equal 3"); // force(2) + STR(1) = 3
      expect(spirit?.wil, 4, reason: "will should equal 4"); // force(2) + WIL(2) = 4
      expect(spirit?.log, 2, reason: "logic should equal 2"); // force(2) + LOG(0) = 2
      expect(spirit?.intu, 3, reason: "intuition should equal 3"); // force(2) + INT(1) = 3
      expect(spirit?.cha, 2, reason: "charisma should equal 2"); // force(2) + CHA(0) = 2
      expect(spirit?.edg, 1, reason: "edge should equal 1"); // force(2) + EDG(0) = 1

      expect(spirit?.powers, containsAll(['Concealment', 'Engulf', 'Entanglement', 'Guard', 'Search']), reason: "powers should contain all expected powers");
      expect(spirit?.special, 'Enhanced abilities in natural environments', reason: "special should match expected text");
    });

    test('Should generate Guidance Spirit with correct attributes', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Guidance', 7);
      expect(spirit?.name, 'Spirit of Guidance', reason: "name should equal 'Spirit of Guidance'");
      expect(spirit?.type, CritterType.spirit, reason: "type should equal CritterType.spirit");
      expect(spirit?.force, 7, reason: "force should equal 7");
      expect(spirit?.bod, 7, reason: "body should equal 7"); // force(7) + BOD(0) = 7
      expect(spirit?.agi, 7, reason: "agility should equal 7"); // force(7) + AGI(0) = 7
      expect(spirit?.rea, 8, reason: "reaction should equal 8"); // force(7) + REA(1) = 8
      expect(spirit?.str, 5, reason: "strength should equal 5"); // force(7) + STR(-2) = 5
      expect(spirit?.wil, 9, reason: "will should equal 9"); // force(7) + WIL(2) = 9
      expect(spirit?.log, 10, reason: "logic should equal 10"); // force(7) + LOG(3) = 10
      expect(spirit?.intu, 10, reason: "intuition should equal 10"); // force(7) + INT(3) = 10
      expect(spirit?.cha, 8, reason: "charisma should equal 8"); // force(7) + CHA(1) = 8
      expect(spirit?.edg, 3, reason: "edge should equal 3"); // force(7) + EDG(0) = 3
      expect(spirit?.powers, containsAll(['Accident', 'Confusion', 'Guard', 'Influence', 'Search']), reason: "powers should contain all expected powers");
      expect(spirit?.special, 'Provides guidance and insight', reason: "special should match expected text");
    });

    test('Should generate Task Spirit with correct attributes', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Tasks', 5);
      expect(spirit?.name, 'Spirit of Tasks', reason: "name should equal 'Spirit of Tasks'");
      expect(spirit?.type, CritterType.spirit, reason: "type should equal CritterType.spirit");
      expect(spirit?.force, 5, reason: "force should equal 5");
      expect(spirit?.bod, 7, reason: "body should equal 7"); // force(5) + BOD(2) = 7
      expect(spirit?.agi, 7, reason: "agility should equal 7"); // force(5) + AGI(2) = 7
      expect(spirit?.rea, 6, reason: "reaction should equal 6"); // force(5) + REA(1) = 6
      expect(spirit?.str, 7, reason: "strength should equal 7"); // force(5) + STR(2) = 7
      expect(spirit?.wil, 6, reason: "will should equal 6"); // force(5) + WIL(1) = 6
      expect(spirit?.log, 5, reason: "logic should equal 5"); // force(5) + LOG(0) = 5
      expect(spirit?.intu, 6, reason: "intuition should equal 6"); // force(5) + INT(1) = 6
      expect(spirit?.cha, 5, reason: "charisma should equal 5"); // force(5) + CHA(0) = 5
      expect(spirit?.edg, 2, reason: "edge should equal 2"); // force(5) + EDG(0) = 2
      expect(spirit?.powers, containsAll(['Accident', 'Binding', 'Concealment', 'Guard', 'Movement', 'Psychokinesis', 'Search']), reason: "powers should contain all expected powers");
      expect(spirit?.special, 'Skilled at specific tasks and crafts', reason: "special should match expected text");
    });

    test('Should handle custom name override for spirits', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Air', 3, nameOverride: 'Zephyr');
      expect(spirit?.name, 'Zephyr', reason: "name should equal 'Zephyr'");
      expect(spirit?.type, CritterType.spirit, reason: "type should equal CritterType.spirit");
      expect(spirit?.force, 3, reason: "force should equal 3");
    });

    test('Should return null for invalid spirit type', () {
      final spirit = CritterFactory.generateSpirit('Invalid Spirit', 5);
      expect(spirit, isNull, reason: "should return null for invalid spirit type");
    });

    test('Should handle edge cases with force 1', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Air', 1);
      expect(spirit?.name, 'Spirit of Air', reason: "name should equal 'Spirit of Air'");
      expect(spirit?.force, 1, reason: "force should equal 1");
      expect(spirit?.bod, 1, reason: "body should equal 1"); // force(1) + BOD(-2) = -1, clamped to 1
      expect(spirit?.agi, 4, reason: "agility should equal 4"); // force(1) + AGI(3) = 4
      expect(spirit?.rea, 5, reason: "reaction should equal 5"); // force(1) + REA(4) = 5
      expect(spirit?.str, 1, reason: "strength should equal 1"); // force(1) + STR(-3) = -2, clamped to 1
    });

    test('Should handle high force values with proper clamping', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Earth', 15);
      expect(spirit?.name, 'Spirit of Earth', reason: "name should equal 'Spirit of Earth'");
      expect(spirit?.force, 15, reason: "force should equal 15");
      expect(spirit?.bod, 19, reason: "body should equal 19"); // force(15) + BOD(4) = 19
      expect(spirit?.agi, 13, reason: "agility should equal 13"); // force(15) + AGI(-2) = 13
      expect(spirit?.rea, 14, reason: "reaction should equal 14"); // force(15) + REA(-1) = 14
      expect(spirit?.str, 19, reason: "strength should equal 19"); // force(15) + STR(4) = 19
      // Verify attributes don't exceed max value of 20
      expect(spirit?.bod, lessThanOrEqualTo(20), reason: "body should not exceed 20");
      expect(spirit?.agi, lessThanOrEqualTo(20), reason: "agility should not exceed 20");
      expect(spirit?.rea, lessThanOrEqualTo(20), reason: "reaction should not exceed 20");
      expect(spirit?.str, lessThanOrEqualTo(20), reason: "strength should not exceed 20");
    });

    test('Should calculate initiative correctly for spirits', () {
      final spirit = CritterFactory.generateSpirit('Spirit of Air', 5);
      expect(spirit!.initiative, '14 + 2D6', reason: "initiative should be calculated correctly"); // rea(9) + intu(7) = 16, dice = 4
      expect(spirit.astralInitiative, '10 + 3D6', reason: "astral initiative should be calculated correctly");
    });
  });

  group('CritterFactory Utility Tests', () {
    test('Should provide list of available sprite types', () {
      final types = CritterFactory.availableSpriteTypes;
      expect(types, containsAll(['Courier Sprite', 'Crack Sprite', 'Data Sprite', 'Fault Sprite', 'Machine Sprite', 'Companion Sprite', 'Generalist Sprite']), reason: "should contain all expected sprite types");
      expect(types.length, 7, reason: "should have exactly 7 sprite types");
    });

    test('Should provide list of available spirit types', () {
      final types = CritterFactory.availableSpiritTypes;
      expect(types, containsAll(['Spirit of Air', 'Spirit of Earth', 'Spirit of Fire', 'Spirit of Water', 'Spirit of Man', 'Spirit of Beasts', 'Spirit of Plants', 'Spirit of Guidance', 'Spirit of Tasks']), reason: "should contain all expected spirit types");
      expect(types.length, 9, reason: "should have exactly 9 spirit types");
    });

    test('Should provide sprite template for valid type', () {
      final template = CritterFactory.getSpriteTemplate('Crack Sprite');
      expect(template, isNotNull, reason: "should return a valid template for Crack Sprite");
      expect(template?.typeName, 'Crack Sprite', reason: "template should have correct type name");
      expect(template?.powers, contains('Suppression'), reason: "template should contain expected powers");
    });

    test('Should provide spirit template for valid type', () {
      final template = CritterFactory.getSpiritTemplate('Spirit of Air');
      expect(template, isNotNull, reason: "should return a valid template for Spirit of Air");
      expect(template?.typeName, 'Spirit of Air', reason: "template should have correct type name");
      expect(template?.powers, containsAll(['Accident', 'Confusion', 'Concealment']), reason: "template should contain expected powers");
    });

    test('Should return null for invalid sprite template', () {
      final template = CritterFactory.getSpriteTemplate('Invalid Sprite');
      expect(template, isNull, reason: "should return null for invalid sprite type");
    });

    test('Should return null for invalid spirit template', () {
      final template = CritterFactory.getSpiritTemplate('Invalid Sprite');
      expect(template, isNull, reason: "should return null for invalid spirit type");
    });
  });
});
}