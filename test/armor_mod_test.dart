import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/armor_mod.dart';

void main() {
  group('ArmorMod', () {
    test('should create ArmorMod with required parameters', () {
      // Arrange & Act
      final armorMod = ArmorMod(
        name: 'Test Mod',
        category: 'Electronics',
        armorCapacity: '2',
        source: 'Core',
        page: '123',
      );

      // Assert
      expect(armorMod.name, 'Test Mod');
      expect(armorMod.category, 'Electronics');
      expect(armorMod.armorCapacity, '2');
      expect(armorMod.source, 'Core');
      expect(armorMod.page, '123');
      expect(armorMod.armor, 0);
      expect(armorMod.rating, 0);
      expect(armorMod.maxRating, 0);
      expect(armorMod.included, false);
      expect(armorMod.equipped, false);
      expect(armorMod.stolen, false);
      expect(armorMod.discountedCost, false);
      expect(armorMod.sortOrder, 0);
      expect(armorMod.wirelessOn, false);
      expect(armorMod.cost, '0');
      expect(armorMod.ratingLabel, 'String_Rating');
    });

    test('should create ArmorMod with all optional parameters', () {
      // Arrange & Act
      final armorMod = ArmorMod(
        sourceId: 'test-source',
        guid: 'test-guid',
        name: 'Advanced Mod',
        category: 'Armor Enhancement',
        armor: 2,
        armorCapacity: '4',
        gearCapacity: '1',
        maxRating: 6,
        rating: 3,
        ratingLabel: 'Custom Rating',
        avail: '12F',
        cost: '5000',
        weight: '2',
        source: 'Run & Gun',
        page: '456',
        included: true,
        equipped: true,
        extra: 'Special notes',
        stolen: true,
        notes: 'Test notes',
        notesColor: 'red',
        discountedCost: true,
        sortOrder: 10,
        wirelessOn: true,
      );

      // Assert
      expect(armorMod.sourceId, 'test-source');
      expect(armorMod.guid, 'test-guid');
      expect(armorMod.name, 'Advanced Mod');
      expect(armorMod.category, 'Armor Enhancement');
      expect(armorMod.armor, 2);
      expect(armorMod.armorCapacity, '4');
      expect(armorMod.gearCapacity, '1');
      expect(armorMod.maxRating, 6);
      expect(armorMod.rating, 3);
      expect(armorMod.ratingLabel, 'Custom Rating');
      expect(armorMod.avail, '12F');
      expect(armorMod.cost, '5000');
      expect(armorMod.weight, '2');
      expect(armorMod.source, 'Run & Gun');
      expect(armorMod.page, '456');
      expect(armorMod.included, true);
      expect(armorMod.equipped, true);
      expect(armorMod.extra, 'Special notes');
      expect(armorMod.stolen, true);
      expect(armorMod.notes, 'Test notes');
      expect(armorMod.notesColor, 'red');
      expect(armorMod.discountedCost, true);
      expect(armorMod.sortOrder, 10);
      expect(armorMod.wirelessOn, true);
    });

    group('fromXml', () {
      test('should parse minimal XML correctly', () {
        // Arrange
        final xmlString = '''
          <armormod>
            <name>Basic Mod</name>
            <category>Electronics</category>
            <source>Core</source>
            <page>123</page>
          </armormod>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armorMod = ArmorMod.fromXml(xmlElement);

        // Assert
        expect(armorMod.name, 'Basic Mod');
        expect(armorMod.category, 'Electronics');
        expect(armorMod.source, 'Core');
        expect(armorMod.page, '123');
        expect(armorMod.armor, 0);
        expect(armorMod.armorCapacity, '0');
        expect(armorMod.rating, 0);
        expect(armorMod.maxRating, 0);
        expect(armorMod.included, false);
        expect(armorMod.equipped, false);
        expect(armorMod.stolen, false);
        expect(armorMod.discountedCost, false);
        expect(armorMod.wirelessOn, false);
        expect(armorMod.cost, '0');
        expect(armorMod.ratingLabel, 'String_Rating');
      });

      test('should parse complete XML correctly', () {
        // Arrange
        final xmlString = '''
          <armormod>
            <sourceid>test-source</sourceid>
            <guid>test-guid</guid>
            <name>Advanced Mod</name>
            <category>Armor Enhancement</category>
            <armor>2</armor>
            <armorcapacity>4</armorcapacity>
            <gearcapacity>1</gearcapacity>
            <maxrating>6</maxrating>
            <rating>3</rating>
            <ratinglabel>Custom Rating</ratinglabel>
            <avail>12F</avail>
            <cost>5000</cost>
            <weight>2</weight>
            <source>Run &amp; Gun</source>
            <page>456</page>
            <included>True</included>
            <equipped>True</equipped>
            <extra>Special notes</extra>
            <stolen>True</stolen>
            <notes>Test notes</notes>
            <notesColor>red</notesColor>
            <discountedcost>True</discountedcost>
            <sortorder>10</sortorder>
            <wirelesson>True</wirelesson>
          </armormod>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armorMod = ArmorMod.fromXml(xmlElement);

        // Assert
        expect(armorMod.sourceId, 'test-source');
        expect(armorMod.guid, 'test-guid');
        expect(armorMod.name, 'Advanced Mod');
        expect(armorMod.category, 'Armor Enhancement');
        expect(armorMod.armor, 2);
        expect(armorMod.armorCapacity, '4');
        expect(armorMod.gearCapacity, '1');
        expect(armorMod.maxRating, 6);
        expect(armorMod.rating, 3);
        expect(armorMod.ratingLabel, 'Custom Rating');
        expect(armorMod.avail, '12F');
        expect(armorMod.cost, '5000');
        expect(armorMod.weight, '2');
        expect(armorMod.source, 'Run & Gun');
        expect(armorMod.page, '456');
        expect(armorMod.included, true);
        expect(armorMod.equipped, true);
        expect(armorMod.extra, 'Special notes');
        expect(armorMod.stolen, true);
        expect(armorMod.notes, 'Test notes');
        expect(armorMod.notesColor, 'red');
        expect(armorMod.discountedCost, true);
        expect(armorMod.sortOrder, 10);
        expect(armorMod.wirelessOn, true);
      });

      test('should handle missing XML elements gracefully', () {
        // Arrange
        final xmlString = '''
          <armormod>
            <name></name>
            <category></category>
            <source></source>
            <page></page>
          </armormod>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armorMod = ArmorMod.fromXml(xmlElement);

        // Assert
        expect(armorMod.name, 'Unnamed Armor Mod');
        expect(armorMod.category, 'Unknown');
        expect(armorMod.source, 'Unknown');
        expect(armorMod.page, '0');
      });

      test('should parse boolean values correctly', () {
        // Arrange
        final xmlString = '''
          <armormod>
            <name>Test</name>
            <category>Test</category>
            <source>Test</source>
            <page>1</page>
            <included>False</included>
            <equipped>False</equipped>
            <stolen>False</stolen>
            <discountedcost>False</discountedcost>
            <wirelesson>False</wirelesson>
          </armormod>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armorMod = ArmorMod.fromXml(xmlElement);

        // Assert
        expect(armorMod.included, false);
        expect(armorMod.equipped, false);
        expect(armorMod.stolen, false);
        expect(armorMod.discountedCost, false);
        expect(armorMod.wirelessOn, false);
      });

      test('should parse numeric values correctly with invalid input', () {
        // Arrange
        final xmlString = '''
          <armormod>
            <name>Test</name>
            <category>Test</category>
            <source>Test</source>
            <page>1</page>
            <armor>invalid</armor>
            <maxrating>invalid</maxrating>
            <rating>invalid</rating>
            <sortorder>invalid</sortorder>
          </armormod>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armorMod = ArmorMod.fromXml(xmlElement);

        // Assert
        expect(armorMod.armor, 0);
        expect(armorMod.maxRating, 0);
        expect(armorMod.rating, 0);
        expect(armorMod.sortOrder, 0);
      });

      test('should handle null XML element', () {
        // Arrange
        final xmlString = '''
          <armormod>
          </armormod>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armorMod = ArmorMod.fromXml(xmlElement);

        // Assert
        expect(armorMod.name, 'Unnamed Armor Mod');
        expect(armorMod.category, 'Unknown');
        expect(armorMod.source, 'Unknown');
        expect(armorMod.page, '0');
        expect(armorMod.armorCapacity, '0');
        expect(armorMod.cost, '0');
        expect(armorMod.ratingLabel, 'String_Rating');
      });
    });
  });
}
