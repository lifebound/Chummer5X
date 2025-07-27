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
        avail: '—',
      );

      // Assert
      expect(gear.name, 'Commlink', reason: 'Name should match the value provided in constructor');
      expect(gear.category, 'Electronics', reason: 'Category should match the value provided in constructor');
      expect(gear.source, 'Core', reason: 'Source should match the value provided in constructor');
      expect(gear.page, '438', reason: 'Page should match the value provided in constructor');
      expect(gear.rating, 0, reason: 'Rating should default to 0 when not specified in constructor');
      expect(gear.qty, 1.0, reason: 'Quantity should default to 1.0 when not specified in constructor');
      expect(gear.avail, '—', reason: 'Availability should preserve the exact value provided in constructor without normalization');
      expect(gear.cost, 0, reason: 'Cost should default to 0 when not specified in constructor');
      expect(gear.bonded, false, reason: 'Bonded status should default to false when not specified in constructor');
      expect(gear.allowRename, false, reason: 'Allow rename should default to false when not specified in constructor');
      expect(gear.equipped, false, reason: 'Equipped status should default to false when not specified in constructor');
      expect(gear.wirelessOn, false, reason: 'Wireless status should default to false when not specified in constructor');
      expect(gear.stolen, false, reason: 'Stolen status should default to false when not specified in constructor');
      expect(gear.discountedCost, false, reason: 'Discounted cost status should default to false when not specified in constructor');
      expect(gear.sortOrder, 0, reason: 'Sort order should default to 0 when not specified in constructor');
    });

    test('should create Gear with all optional parameters', () {
      // Arrange
      final childGear = Gear(
        name: 'Child Gear',
        category: 'Accessory',
        source: 'Core',
        page: '1',
        avail: '—',
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
      expect(gear.sourceId, 'test-source', reason: 'Source ID should match the value provided in constructor');
      expect(gear.locationGuid, 'test-guid', reason: 'Location GUID should match the value provided in constructor');
      expect(gear.name, 'Advanced Commlink', reason: 'Name should match the value provided in constructor');
      expect(gear.category, 'Matrix', reason: 'Category should match the value provided in constructor');
      expect(gear.source, 'Data Trails', reason: 'Source should match the value provided in constructor');
      expect(gear.page, '234', reason: 'Page should match the value provided in constructor');
      expect(gear.equipped, true, reason: 'Equipped status should match the value provided in constructor');
      expect(gear.wirelessOn, true, reason: 'Wireless status should match the value provided in constructor');
      expect(gear.stolen, true, reason: 'Stolen status should match the value provided in constructor');
      expect(gear.capacity, '10', reason: 'Capacity should match the value provided in constructor');
      expect(gear.armorCapacity, '2', reason: 'Armor capacity should match the value provided in constructor');
      expect(gear.minRating, '1', reason: 'Min rating should match the value provided in constructor');
      expect(gear.maxRating, '6', reason: 'Max rating should match the value provided in constructor');
      expect(gear.rating, 4, reason: 'Rating should match the value provided in constructor');
      expect(gear.qty, 2.5, reason: 'Quantity should match the value provided in constructor');
      expect(gear.avail, '8R', reason: 'Availability should match the value provided in constructor');
      expect(gear.cost, 5000, reason: 'Cost should match the value provided in constructor');
      expect(gear.weight, '1.5', reason: 'Weight should match the value provided in constructor');
      expect(gear.extra, 'Custom modifications', reason: 'Extra field should match the value provided in constructor');
      expect(gear.bonded, true, reason: 'Bonded status should match the value provided in constructor');
      expect(gear.forcedValue, 'Forced', reason: 'Forced value should match the value provided in constructor');
      expect(gear.parentId, 'parent-123', reason: 'Parent ID should match the value provided in constructor');
      expect(gear.allowRename, true, reason: 'Allow rename should match the value provided in constructor');
      expect(gear.children, isNotEmpty, reason: 'Children should contain the gear list provided in constructor');
      expect(gear.children!.first.name, 'Child Gear', reason: 'First child gear name should match the child gear provided in constructor');
      expect(gear.location, 'Backpack', reason: 'Location should match the value provided in constructor');
      expect(gear.notes, 'Important gear', reason: 'Notes should match the value provided in constructor');
      expect(gear.notesColor, 'blue', reason: 'Notes color should match the value provided in constructor');
      expect(gear.discountedCost, true, reason: 'Discounted cost status should match the value provided in constructor');
      expect(gear.sortOrder, 5, reason: 'Sort order should match the value provided in constructor');
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
        expect(gear.name, 'Basic Gear', reason: 'Name should be parsed from XML name element');
        expect(gear.category, 'Electronics', reason: 'Category should be parsed from XML category element');
        expect(gear.source, 'Core', reason: 'Source should be parsed from XML source element');
        expect(gear.page, '438', reason: 'Page should be parsed from XML page element');
        expect(gear.rating, 0, reason: 'Rating should default to 0 when rating element is not present in XML');
        expect(gear.qty, 1.0, reason: 'Quantity should default to 1.0 when qty element is not present in XML');
        expect(gear.cost, 0, reason: 'Cost should default to 0 when cost element is not present in XML');
        expect(gear.equipped, false, reason: 'Equipped should default to false when equipped element is not present in XML');
        expect(gear.wirelessOn, false, reason: 'Wireless should default to false when wirelesson element is not present in XML');
        expect(gear.stolen, false, reason: 'Stolen should default to false when stolen element is not present in XML');
        expect(gear.bonded, false, reason: 'Bonded should default to false when bonded element is not present in XML');
        expect(gear.allowRename, false, reason: 'Allow rename should default to false when allowrename element is not present in XML');
        expect(gear.discountedCost, false, reason: 'Discounted cost should default to false when discountedcost element is not present in XML');
        expect(gear.sortOrder, 0, reason: 'Sort order should default to 0 when sortorder element is not present in XML');
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
        expect(gear.sourceId, 'test-source', reason: 'Source ID should be parsed from XML sourceid element');
        expect(gear.locationGuid, 'test-guid', reason: 'Location GUID should be parsed from XML guid element');
        expect(gear.name, 'Override Name', reason: 'Name should be parsed from XML extra element when present, overriding name element');
        expect(gear.category, 'Matrix', reason: 'Category should be parsed from XML category element');
        expect(gear.source, 'Data Trails', reason: 'Source should be parsed from XML source element');
        expect(gear.page, '234', reason: 'Page should be parsed from XML page element');
        expect(gear.equipped, true, reason: 'Equipped should be parsed as true from XML equipped element value "True"');
        expect(gear.wirelessOn, true, reason: 'Wireless should be parsed as true from XML wirelesson element value "True"');
        expect(gear.stolen, true, reason: 'Stolen should be parsed as true from XML stolen element value "True"');
        expect(gear.capacity, '10', reason: 'Capacity should be parsed from XML capacity element');
        expect(gear.armorCapacity, '2', reason: 'Armor capacity should be parsed from XML armorcapacity element');
        expect(gear.minRating, '1', reason: 'Min rating should be parsed from XML minrating element');
        expect(gear.maxRating, '6', reason: 'Max rating should be parsed from XML maxrating element');
        expect(gear.rating, 4, reason: 'Rating should be parsed from XML rating element');
        expect(gear.qty, 2.5, reason: 'Quantity should be parsed from XML qty element');
        expect(gear.cost, 5000, reason: 'Cost should be parsed from XML cost element');
        expect(gear.weight, '1.5', reason: 'Weight should be parsed from XML weight element');
        expect(gear.bonded, true, reason: 'Bonded should be parsed as true from XML bonded element value "True"');
        expect(gear.forcedValue, 'Forced', reason: 'Forced value should be parsed from XML forcedvalue element');
        expect(gear.parentId, 'parent-123', reason: 'Parent ID should be parsed from XML parentid element');
        expect(gear.allowRename, true, reason: 'Allow rename should be parsed as true from XML allowrename element value "True"');
        expect(gear.location, 'Backpack', reason: 'Location should be parsed from XML location element');
        expect(gear.notes, 'Important gear', reason: 'Notes should be parsed from XML notes element');
        expect(gear.notesColor, 'blue', reason: 'Notes color should be parsed from XML notesColor element');
        expect(gear.discountedCost, true, reason: 'Discounted cost should be parsed as true from XML discountedcost element value "True"');
        expect(gear.sortOrder, 5, reason: 'Sort order should be parsed from XML sortorder element');
        expect(gear.children, isNotEmpty, reason: 'Children should be parsed from XML children element and contain at least one gear');
        expect(gear.children!.first.name, 'Child Gear', reason: 'First child gear name should be parsed correctly from nested XML structure');
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
        expect(gear.name, 'Unnamed Gear', reason: 'Name should default to "Unnamed Gear" when XML name element is empty');
        expect(gear.category, 'Unknown', reason: 'Category should default to "Unknown" when XML category element is empty');
        expect(gear.source, 'Unknown', reason: 'Source should default to "Unknown" when XML source element is empty');
        expect(gear.page, '0', reason: 'Page should default to "0" when XML page element is empty');
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
        expect(gear.rating, 0, reason: 'Rating should default to 0 when XML rating element contains invalid numeric value');
        expect(gear.qty, 1.0, reason: 'Quantity should default to 1.0 when XML qty element contains invalid numeric value');
        expect(gear.cost, 0, reason: 'Cost should default to 0 when XML cost element contains invalid numeric value');
        expect(gear.sortOrder, 0, reason: 'Sort order should default to 0 when XML sortorder element contains invalid numeric value');
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
        expect(gear.equipped, false, reason: 'Equipped should be parsed as false from XML equipped element value "False"');
        expect(gear.wirelessOn, false, reason: 'Wireless should be parsed as false from XML wirelesson element value "False"');
        expect(gear.stolen, false, reason: 'Stolen should be parsed as false from XML stolen element value "False"');
        expect(gear.bonded, false, reason: 'Bonded should be parsed as false from XML bonded element value "False"');
        expect(gear.allowRename, false, reason: 'Allow rename should be parsed as false from XML allowrename element value "False"');
        expect(gear.discountedCost, false, reason: 'Discounted cost should be parsed as false from XML discountedcost element value "False"');
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
        expect(gear.name, 'Override Name', reason: 'Name should be set to extra element value when extra element is present, overriding name element');
        expect(gear.extra, 'Override Name', reason: 'Extra field should contain the value from XML extra element');
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
        expect(gear.children, hasLength(2), reason: 'Gear should have 2 child gears parsed from XML children element');
        expect(gear.children![0].name, 'Child 1', reason: 'First child gear name should be parsed correctly from nested gear XML element');
        expect(gear.children![1].name, 'Child 2', reason: 'Second child gear name should be parsed correctly from nested gear XML element');
        expect(gear.children![1].rating, 2, reason: 'Second child gear rating should be parsed correctly from nested gear XML element');
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
        expect(gear.children, isEmpty, reason: 'Children should be empty when XML children element contains no child gear elements');
      });
    });
  });
}
