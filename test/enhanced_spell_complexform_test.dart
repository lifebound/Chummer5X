import 'package:flutter_test/flutter_test.dart';
import '../lib/models/shadowrun_character.dart';
import '../lib/services/enhanced_chumer_xml_service.dart';
import 'package:xml/xml.dart';

void main() {
  group('Enhanced Spell and Complex Form Tests', () {
    group('Spell Model Tests', () {
      test('should create spell with all required fields', () {
        final spell = Spell(
          name: 'Manabolt',
          range: 'Line of Sight',
          duration: 'Instant',
          drain: 'Force - 3',
          source: 'SR5 283',
          page : '283',
          category: 'Combat',
        );

        expect(spell.name, equals('Manabolt'));
        expect(spell.range, equals('Line of Sight'));
        expect(spell.duration, equals('Instant'));
        expect(spell.drain, equals('Force - 3'));
        expect(spell.source, equals('SR5 283'));
        expect(spell.category, equals('Combat'));
        expect(spell.description, isEmpty); // Should default to empty
      });

      test('should create spell with optional description', () {
        final spell = Spell(
          name: 'Heal',
          range: 'Touch',
          duration: 'Permanent',
          drain: 'Force - 2',
          source: 'SR5 288',
          category: 'Health',
          description: 'Heals physical damage',
        );

        expect(spell.description, equals('Heals physical damage'));
      });

      test('should parse spell from JSON data', () {
        final jsonData = {
          'name': 'Fireball',
          'range': 'Line of Sight (Area)',
          'target': 'Area',
          'duration': 'Instant',
          'drain': 'Force - 1',
          'source': 'SR5 284',
          'category': 'Combat',
        };

        final spell = Spell.fromJson(jsonData);
        
        expect(spell.name, equals('Fireball'));
        expect(spell.range, equals('Line of Sight (Area)'));
        expect(spell.duration, equals('Instant'));
        expect(spell.drain, equals('Force - 1'));
        expect(spell.source, equals('SR5 284'));
        expect(spell.category, equals('Combat'));
      });
    });
    test('should parse spell from XML data', () {
        const xmlData = '''<?xml version="1.0" encoding="utf-8"?>
          "<character>
          <spells>
            <spell>
              <sourceid>37b3d6ac-624a-42d4-bd6e-a12142dc5725</sourceid>
              <guid>263bfdeb-75ef-4f0f-874d-5a1f92dca45b</guid>
              <name>Increase Reflexes</name>
              <descriptors>Essence</descriptors>
              <category>Health</category>
              <type>P</type>
              <range>T</range>
              <damage>0</damage>
              <duration>S</duration>
              <dv>F</dv>
              <limited>False</limited>
              <extended>False</extended>
              <customextended>False</customextended>
              <alchemical>False</alchemical>
              <source>SR5</source>
              <page>288</page>
              <extra />
              <notes />
              <notesColor>Chocolate</notesColor>
              <freebonus>False</freebonus>
              <barehandedadept>False</barehandedadept>
              <improvementsource>Spell</improvementsource>
              <grade>0</grade>
            </spell>
          </spells>
          </character>'''
        ;
        final xmlElement = XmlDocument.parse(xmlData).rootElement;
        final spell = EnhancedChumerXmlService.parseSpells(xmlElement).first;

        expect(spell.name, equals('Increase Reflexes'));
        expect(spell.range, equals('T'));
        expect(spell.duration, equals('S'));
        expect(spell.drain, equals('F'));
        expect(spell.source, equals('SR5'));
        expect(spell.category, equals('Health'));
        expect(spell.hasCompleteInfo, isTrue);
      });

    group('Complex Form Model Tests', () {
      test('should create complex form with all required fields', () {
        const complexForm = ComplexForm(
          name: 'Browse',
          target: 'File',
          duration: 'Sustained',
          fading: 'Level - 1',
          source: 'SR5',
          page: '251',
        );

        expect(complexForm.name, equals('Browse'));
        expect(complexForm.target, equals('File'));
        expect(complexForm.duration, equals('Sustained'));
        expect(complexForm.fading, equals('Level - 1'));
        expect(complexForm.source, equals('SR5'));
        expect(complexForm.page, equals('251'));
        expect(complexForm.description, isEmpty); // Should default to empty
      });

      test('should create complex form with optional description', () {
        final complexForm = ComplexForm(
          name: 'Command',
          target: 'Device',
          duration: 'Instant',
          fading: 'Level - 2',
          source: 'SR5 252',
          description: 'Issues commands to devices',
        );

        expect(complexForm.description, equals('Issues commands to devices'));
      });

      test('should parse complex form from JSON/XML data', () {
        final jsonData = {
          'name': 'Pulse Storm',
          'target': 'Persona',
          'duration': 'Instant',
          'fading': 'Level + 1',
          'source': 'SR5 255',
        };

        final complexForm = ComplexForm.fromJson(jsonData);
        
        expect(complexForm.name, equals('Pulse Storm'));
        expect(complexForm.target, equals('Persona'));
        expect(complexForm.duration, equals('Instant'));
        expect(complexForm.fading, equals('Level + 1'));
        expect(complexForm.source, equals('SR5 255'));
      });
    });

    group('Model Compatibility Tests', () {
      test('should maintain backwards compatibility for existing spell data', () {
        // Test that existing simple spell data still works
        final oldData = {
          'name': 'Light',
          'category': 'Manipulation',
        };

        final spell = Spell.fromJson(oldData);
        expect(spell.name, equals('Light'));
        expect(spell.category, equals('Manipulation'));
        // New fields should have sensible defaults
        expect(spell.range, isEmpty);
        expect(spell.duration, isEmpty);
        expect(spell.drain, isEmpty);
        expect(spell.source, isEmpty);
      });

      test('should maintain backwards compatibility for existing complex form data', () {
        // Test that existing simple complex form data still works
        final oldData = {
          'name': 'Decrypt',
        };

        final complexForm = ComplexForm.fromJson(oldData);
        expect(complexForm.name, equals('Decrypt'));
        // New fields should have sensible defaults
        expect(complexForm.target, isEmpty);
        expect(complexForm.duration, isEmpty);
        expect(complexForm.fading, isEmpty);
        expect(complexForm.source, isEmpty);
      });
    });

    group('Display and Utility Tests', () {
      test('should format spell display information correctly', () {
        final spell = Spell(
          name: 'Stunbolt',
          range: 'Line of Sight',
          duration: 'Instant',
          drain: 'Force - 3',
          source: 'SR5 283',
          category: 'Combat',
        );

        expect(spell.hasCompleteInfo, isTrue);
        expect(spell.displayName, equals('Stunbolt'));
      });

      test('should format complex form display information correctly', () {
        final complexForm = ComplexForm(
          name: 'Analyze',
          target: 'File',
          duration: 'Sustained',
          fading: 'Level - 1',
          source: 'SR5 250',
        );

        expect(complexForm.hasCompleteInfo, isTrue);
        expect(complexForm.displayName, equals('Analyze'));
      });

      test('should identify incomplete spell information', () {
        final incompleteSpell = Spell(
          name: 'Mystery Spell',
          category: 'Unknown',
        );

        expect(incompleteSpell.hasCompleteInfo, isFalse);
      });

      test('should identify incomplete complex form information', () {
        final incompleteForm = ComplexForm(
          name: 'Mystery Form',
        );

        expect(incompleteForm.hasCompleteInfo, isFalse);
      });
    });
  });
}
