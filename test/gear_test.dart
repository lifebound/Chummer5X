import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/gear.dart';

void main() {
  group('Gear', () {
    test('should create Gear with required parameters', () {
      // Arrange & Act
      final gear = Gear(
        name: 'Commlink',
        category: 'Electronics',
        source: 'Core',
        page: '438',
      );

      // Assert
      expect(gear.name, 'Commlink');
      expect(gear.category, 'Electronics');
      expect(gear.source, 'Core');
      expect(gear.page, '438');
      expect(gear.rating, 0);
      expect(gear.qty, 1.0);
      expect(gear.avail, '0');
      expect(gear.cost, 0);
      expect(gear.bonded, false);
      expect(gear.allowRename, false);
      expect(gear.equipped, false);
      expect(gear.wirelessOn, false);
      expect(gear.stolen, false);
      expect(gear.discountedCost, false);
      expect(gear.sortOrder, 0);
    });

    test('should create Gear with all optional parameters', () {
      // Arrange
      final childGear = Gear(
        name: 'Child Gear',
        category: 'Accessory',
        source: 'Core',
        page: '1',
      );

      // Act
      final gear = Gear(
        sourceId: 'test-source',
        locationGuid: 'test-guid',
        name: 'Advanced Commlink',
        category: 'Matrix',
        source: 'Data Trails',
        page: '234',
        equipped: true,
        wirelessOn: true,
        stolen: true,
        capacity: '10',
        armorCapacity: '2',
        minRating: '1',
        maxRating: '6',
        rating: 4,
        qty: 2.5,
        avail: '8R',
        cost: 5000,
        weight: '1.5',
        extra: 'Custom modifications',
        bonded: true,
        gearName: 'Custom Name',
        forcedValue: 'Forced',
        parentId: 'parent-123',
        allowRename: true,
        children: [childGear],
        location: 'Backpack',
        notes: 'Important gear',
        notesColor: 'blue',
        discountedCost: true,
        sortOrder: 5,
      );

      // Assert
      expect(gear.sourceId, 'test-source');
      expect(gear.locationGuid, 'test-guid');
      expect(gear.name, 'Advanced Commlink');
      expect(gear.category, 'Matrix');
      expect(gear.source, 'Data Trails');
      expect(gear.page, '234');
      expect(gear.equipped, true);
      expect(gear.wirelessOn, true);
      expect(gear.stolen, true);
      expect(gear.capacity, '10');
      expect(gear.armorCapacity, '2');
      expect(gear.minRating, '1');
      expect(gear.maxRating, '6');
      expect(gear.rating, 4);
      expect(gear.qty, 2.5);
      expect(gear.avail, '8R');
      expect(gear.cost, 5000);
      expect(gear.weight, '1.5');
      expect(gear.extra, 'Custom modifications');
      expect(gear.bonded, true);
      expect(gear.gearName, 'Custom Name');
      expect(gear.forcedValue, 'Forced');
      expect(gear.parentId, 'parent-123');
      expect(gear.allowRename, true);
      expect(gear.children, isNotEmpty);
      expect(gear.children!.first.name, 'Child Gear');
      expect(gear.location, 'Backpack');
      expect(gear.notes, 'Important gear');
      expect(gear.notesColor, 'blue');
      expect(gear.discountedCost, true);
      expect(gear.sortOrder, 5);
    });

    group('fromXml', () {
      test('should parse minimal XML correctly', () {
        // Arrange
        final xmlString = '''
          <gear>
            <name>Basic Gear</name>
            <category>Electronics</category>
            <source>Core</source>
            <page>438</page>
          </gear>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final gear = Gear.fromXml(xmlElement);

        // Assert
        expect(gear.name, 'Basic Gear');
        expect(gear.category, 'Electronics');
        expect(gear.source, 'Core');
        expect(gear.page, '438');
        expect(gear.rating, 0);
        expect(gear.qty, 1.0);
        expect(gear.cost, 0);
        expect(gear.equipped, false);
        expect(gear.wirelessOn, false);
        expect(gear.stolen, false);
        expect(gear.bonded, false);
        expect(gear.allowRename, false);
        expect(gear.discountedCost, false);
        expect(gear.sortOrder, 0);
      });

      test('should parse complete XML correctly', () {
        // Arrange
        final xmlString = '''
          <gear>
            <sourceid>test-source</sourceid>
            <guid>test-guid</guid>
            <name>Advanced Gear</name>
            <extra>Override Name</extra>
            <category>Matrix</category>
            <source>Data Trails</source>
            <page>234</page>
            <equipped>True</equipped>
            <wirelesson>True</wirelesson>
            <stolen>True</stolen>
            <capacity>10</capacity>
            <armorcapacity>2</armorcapacity>
            <minrating>1</minrating>
            <maxrating>6</maxrating>
            <rating>4</rating>
            <qty>2.5</qty>
            <avail>8R</avail>
            <cost>5000</cost>
            <weight>1.5</weight>
            <bonded>True</bonded>
            <gearname>Custom Name</gearname>
            <forcedvalue>Forced</forcedvalue>
            <parentid>parent-123</parentid>
            <allowrename>True</allowrename>
            <location>Backpack</location>
            <notes>Important gear</notes>
            <notesColor>blue</notesColor>
            <discountedcost>True</discountedcost>
            <sortorder>5</sortorder>
            <children>
              <gear>
                <name>Child Gear</name>
                <category>Accessory</category>
                <source>Core</source>
                <page>1</page>
              </gear>
            </children>
          </gear>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final gear = Gear.fromXml(xmlElement);

        // Assert
        expect(gear.sourceId, 'test-source');
        expect(gear.locationGuid, 'test-guid');
        expect(gear.name, 'Override Name'); // Extra overrides name
        expect(gear.category, 'Matrix');
        expect(gear.source, 'Data Trails');
        expect(gear.page, '234');
        expect(gear.equipped, true);
        expect(gear.wirelessOn, true);
        expect(gear.stolen, true);
        expect(gear.capacity, '10');
        expect(gear.armorCapacity, '2');
        expect(gear.minRating, '1');
        expect(gear.maxRating, '6');
        expect(gear.rating, 4);
        expect(gear.qty, 2.5);
        expect(gear.cost, 5000);
        expect(gear.weight, '1.5');
        expect(gear.bonded, true);
        expect(gear.gearName, 'Custom Name');
        expect(gear.forcedValue, 'Forced');
        expect(gear.parentId, 'parent-123');
        expect(gear.allowRename, true);
        expect(gear.location, 'Backpack');
        expect(gear.notes, 'Important gear');
        expect(gear.notesColor, 'blue');
        expect(gear.discountedCost, true);
        expect(gear.sortOrder, 5);
        expect(gear.children, isNotEmpty);
        expect(gear.children!.first.name, 'Child Gear');
      });

      test('should handle missing XML elements gracefully', () {
        // Arrange
        final xmlString = '''
          <gear>
            <name></name>
            <category></category>
            <source></source>
            <page></page>
          </gear>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final gear = Gear.fromXml(xmlElement);

        // Assert
        expect(gear.name, 'Unnamed Gear');
        expect(gear.category, 'Unknown');
        expect(gear.source, 'Unknown');
        expect(gear.page, '0');
      });

      test('should parse numeric values correctly with invalid input', () {
        // Arrange
        final xmlString = '''
          <gear>
            <name>Test</name>
            <category>Test</category>
            <source>Test</source>
            <page>1</page>
            <rating>invalid</rating>
            <qty>invalid</qty>
            <cost>invalid</cost>
            <sortorder>invalid</sortorder>
          </gear>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final gear = Gear.fromXml(xmlElement);

        // Assert
        expect(gear.rating, 0);
        expect(gear.qty, 1.0);
        expect(gear.cost, 0);
        expect(gear.sortOrder, 0);
      });

      test('should parse boolean values correctly', () {
        // Arrange
        final xmlString = '''
          <gear>
            <name>Test</name>
            <category>Test</category>
            <source>Test</source>
            <page>1</page>
            <equipped>False</equipped>
            <wirelesson>False</wirelesson>
            <stolen>False</stolen>
            <bonded>False</bonded>
            <allowrename>False</allowrename>
            <discountedcost>False</discountedcost>
          </gear>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final gear = Gear.fromXml(xmlElement);

        // Assert
        expect(gear.equipped, false);
        expect(gear.wirelessOn, false);
        expect(gear.stolen, false);
        expect(gear.bonded, false);
        expect(gear.allowRename, false);
        expect(gear.discountedCost, false);
      });

      test('should prefer extra over name when both are present', () {
        // Arrange
        final xmlString = '''
          <gear>
            <name>Original Name</name>
            <extra>Override Name</extra>
            <category>Test</category>
            <source>Test</source>
            <page>1</page>
          </gear>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final gear = Gear.fromXml(xmlElement);

        // Assert
        expect(gear.name, 'Override Name');
        expect(gear.extra, 'Override Name');
      });

      test('should handle nested children gear correctly', () {
        // Arrange
        final xmlString = '''
          <gear>
            <name>Parent Gear</name>
            <category>Container</category>
            <source>Core</source>
            <page>1</page>
            <children>
              <gear>
                <name>Child 1</name>
                <category>Accessory</category>
                <source>Core</source>
                <page>2</page>
              </gear>
              <gear>
                <name>Child 2</name>
                <category>Accessory</category>
                <source>Core</source>
                <page>3</page>
                <rating>2</rating>
              </gear>
            </children>
          </gear>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final gear = Gear.fromXml(xmlElement);

        // Assert
        expect(gear.children, hasLength(2));
        expect(gear.children![0].name, 'Child 1');
        expect(gear.children![1].name, 'Child 2');
        expect(gear.children![1].rating, 2);
      });

      test('should handle empty children element', () {
        // Arrange
        final xmlString = '''
          <gear>
            <name>Parent Gear</name>
            <category>Container</category>
            <source>Core</source>
            <page>1</page>
            <children>
            </children>
          </gear>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final gear = Gear.fromXml(xmlElement);

        // Assert
        expect(gear.children, isEmpty);
      });
    });
  });
}
