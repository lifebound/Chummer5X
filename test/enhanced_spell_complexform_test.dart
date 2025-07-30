import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/services/enhanced_chumer_xml_service.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/spells.dart';
import 'package:chummer5x/models/complex_forms.dart';
import 'package:chummer5x/models/adept_powers.dart';

void main() {
  group('Enhanced Spell and Complex Form Tests', () {
    group('Spell Model Tests', () {
      test('should create spell with all required fields', () {
        const spell = Spell(
          name: 'Manabolt',
          range: 'Line of Sight',
          duration: 'Instant',
          drain: 'Force - 3',
          source: 'SR5 283',
          page: '283',
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
        const spell = Spell(
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
        final spell = EnhancedChummerXmlService.parseSpells(xmlElement).first;

        expect(spell.name, equals('Increase Reflexes'));
        expect(spell.range, equals('T'));
        expect(spell.duration, equals('S'));
        expect(spell.drain, equals('F'));
        expect(spell.source, equals('SR5'));
        expect(spell.category, equals('Health'));
        expect(spell.hasCompleteInfo, isTrue);
      });
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
        const complexForm = ComplexForm(
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
    group('Adept Powers Model Tests', () {
      test('should create adept power with basic fields', () {
        const adeptPower = AdeptPower(
          name: 'Improved Reflexes',
          rating: '3',
          source: 'SR5',
          page: '290',
        );

        expect(adeptPower.name, equals('Improved Reflexes'));
        expect(adeptPower.rating, equals('3'));
        expect(adeptPower.extra, isNull);
      });

      test('should create adept power with extra specification', () {
        const adeptPower = AdeptPower(
          name: 'Critical Strike',
          rating: '1',
          extra: 'Blades',
          source: 'SR5',
          page: '291',
        );

        expect(adeptPower.name, equals('Critical Strike'));
        expect(adeptPower.rating, equals('1'));
        expect(adeptPower.extra, equals('Blades'));
      });

      test('should parse adept power from JSON data', () {
        final jsonData = {
          'name': 'Facial Sculpt',
          'rating': '1',
          'extra': 'Complex Action',
        };

        final adeptPower = AdeptPower.fromJson(jsonData);
        
        expect(adeptPower.name, equals('Facial Sculpt'));
        expect(adeptPower.rating, equals('1'));
        expect(adeptPower.extra, equals('Complex Action'));
      });

      test('should handle adept power with no rating', () {
        const adeptPower = AdeptPower(
          name: 'Enhanced Perception',
          page: '290',
          source: 'SR5',
        );

        expect(adeptPower.name, equals('Enhanced Perception'));
        expect(adeptPower.rating, isNull);
        expect(adeptPower.extra, isNull);
      });

      test('should parse rating as string from various input types', () {
        final jsonData1 = {
          'name': 'Test Power 1',
          'rating': 2, // int
        };
        final jsonData2 = {
          'name': 'Test Power 2',
          'rating': '3', // string
        };

        final adeptPower1 = AdeptPower.fromJson(jsonData1);
        final adeptPower2 = AdeptPower.fromJson(jsonData2);
        
        expect(adeptPower1.rating, equals('2'));
        expect(adeptPower2.rating, equals('3'));
      });

      test('should maintain backwards compatibility for simple adept power data', () {
        final oldData = {
          'name': 'Enhanced Perception',
          'source': 'SR5',
          'page': '290',
        };

        final adeptPower = AdeptPower.fromJson(oldData);
        expect(adeptPower.name, equals('Enhanced Perception'));
        expect(adeptPower.rating, isNull);
        expect(adeptPower.extra, isNull);
      });

      test('should parse adept power Cloak with bonus metadata', () {
        final jsonData = {
          'name': 'Cloak',
          'rating': '2',
          'extra': null,
          'pointsperlevel': 0.25,
          'extrapointcost': 0.0,
          'haslevels': true,
          'maxlevels': 0,
          'action': '',
          'discounted': false,
          'source': 'SG',
          'page': '169',
          'bonus': {
            'detectionspellresist': 'Rating',
          },
        };

        final power = AdeptPower.fromJson(jsonData);

        expect(power.name, equals('Cloak'));
        expect(power.rating, equals('2'));
        expect(power.pointsPerLevel, equals(0.25));
        expect(power.extraPointCost, equals(0.0));
        expect(power.hasLevels, isTrue);
        expect(power.maxLevels, equals(0));
        expect(power.action, isEmpty);
        expect(power.discounted, isFalse);
        expect(power.source, equals('SG'));
        expect(power.page, equals('169'));

        // Check bonus metadata
        expect(power.bonus, isNotNull);
        expect(power.bonus!.containsKey('detectionspellresist'), isTrue);
        expect(power.bonus!['detectionspellresist'], equals('Rating'));
      });

      test('should handle adept power from basic XML structure', () {
        // This test simulates the minimal XML we might encounter
        final jsonData = {
          'name': 'Cloak',
          'rating': '2',
          'extra': '',
        };

        final adeptPower = AdeptPower.fromJson(jsonData);
        
        expect(adeptPower.name, equals('Cloak'));
        expect(adeptPower.rating, equals('2'));
        expect(adeptPower.extra, equals(''));
      });

      test('should handle complex adept power names with parenthetical specifications', () {
        const adeptPower = AdeptPower(
          name: 'Improved Ability (skill)',
          rating: '1',
          extra: 'Blades',
          page: '291',
          source: 'SR5',
        );

        expect(adeptPower.name, equals('Improved Ability (skill)'));
        expect(adeptPower.extra, equals('Blades'));
      });

      test('should handle null and empty values gracefully', () {
        final jsonData = {
          'name': 'Test Power',
          'rating': null,
          'extra': '',
        };

        final adeptPower = AdeptPower.fromJson(jsonData);
        
        expect(adeptPower.name, equals('Test Power'));
        expect(adeptPower.rating, isNull);
        expect(adeptPower.extra, equals(''));
      });
      test('should parse adept power from XML data', () {
        const xmlData = '''<?xml version="1.0" encoding="utf-8"?>
        <character>
          <powers>
            <power>
              <sourceid>42baa818-50ca-4c6b-b316-780a51df9c97</sourceid>
              <guid>845dde49-72b8-4f92-86c2-9713541fe4ee</guid>
              <name>Cloak</name>
              <extra />
              <pointsperlevel>0.25</pointsperlevel>
              <adeptway>0</adeptway>
              <action />
              <rating>2</rating>
              <extrapointcost>0</extrapointcost>
              <levels>True</levels>
              <maxlevels>0</maxlevels>
              <discounted>False</discounted>
              <discountedgeas>False</discountedgeas>
              <bonussource />
              <freepoints>0</freepoints>
              <source>SG</source>
              <page>169</page>
              <bonus>
                <detectionspellresist>Rating</detectionspellresist>
              </bonus>
              <adeptwayrequires></adeptwayrequires>
              <enhancements />
              <notes />
              <notesColor>Chocolate</notesColor>
            </power>
          </powers>
        </character>''';

        final xmlElement = XmlDocument.parse(xmlData).rootElement;
        final powers = EnhancedChummerXmlService.parseAdeptPowers(xmlElement);
        final cloak = powers.firstWhere((p) => p.name == 'Cloak');
        expect(cloak.name, equals('Cloak'));
        expect(cloak.rating, equals('2'));
        expect(cloak.pointsPerLevel, equals(0.25));
        expect(cloak.extraPointCost, equals(0.0));
        expect(cloak.hasLevels, isTrue);
        expect(cloak.maxLevels, equals(0));
        expect(cloak.discounted, isFalse);
        expect(cloak.source, equals('SG'));
        expect(cloak.page, equals('169'));

        // Bonus section
        expect(cloak.bonus, isNotNull);
        expect(cloak.bonus!.containsKey('detectionspellresist'), isTrue);
        expect(cloak.bonus!['detectionspellresist'], equals('Rating'));
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
        const spell = Spell(
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
        const complexForm = ComplexForm(
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
        const incompleteSpell = Spell(
          name: 'Mystery Spell',
          category: 'Unknown',
        );

        expect(incompleteSpell.hasCompleteInfo, isFalse);
      });

      test('should identify incomplete complex form information', () {
        const incompleteForm = ComplexForm(
          name: 'Mystery Form',
        );

        expect(incompleteForm.hasCompleteInfo, isFalse);
      });
    });
  });
}
