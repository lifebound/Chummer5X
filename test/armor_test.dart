import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/armor.dart';
import 'package:chummer5x/models/items/armor_mod.dart';

void main() {
  group('Armor', () {
    test('should create Armor with required parameters', () {
      // Arrange & Act
      final armor = Armor(
        name: 'Armor Jacket',
        category: 'Armor',
        source: 'Core',
        page: '436',
        armorValue: '12',
        armorCapacity: '6',
        avail: '—',
      );

      // Assert
      expect(armor.name, 'Armor Jacket');
      expect(armor.category, 'Armor');
      expect(armor.source, 'Core');
      expect(armor.page, '436');
      expect(armor.armorValue, '12');
      expect(armor.armorCapacity, '6');
      expect(armor.cost, 0);
      expect(armor.damage, 0);
      expect(armor.rating, 0);
      expect(armor.maxRating, 0);
      expect(armor.ratingLabel, 'String_Rating');
      expect(armor.encumbrance, false);
      expect(armor.equipped, false);
      expect(armor.active, false);
      expect(armor.homeNode, false);
      expect(armor.wirelessOn, false);
      expect(armor.stolen, false);
      expect(armor.discountedCost, false);
      expect(armor.sortOrder, 0);
      expect(armor.matrixCmFilled, 0);
      expect(armor.matrixCmBonus, 0);
      expect(armor.canSwapAttributes, false);
      expect(armor.avail, '0');
    });

    test('should create Armor with all optional parameters', () {
      // Arrange
      final armorMods = [
        ArmorMod(
          name: 'Test Mod',
          category: 'Electronics',
          armorCapacity: '1',
          source: 'Core',
          page: '123',
        ),
      ];

      // Act
      final armor = Armor(
        sourceId: 'test-source',
        locationGuid: 'test-guid',
        name: 'Full Body Armor',
        category: 'Heavy Armor',
        source: 'Run & Gun',
        page: '789',
        armorValue: '18',
        armorOverride: '20',
        armorCapacity: '10',
        cost: 15000,
        weight: '8',
        armorName: 'Custom Name',
        extra: 'Special features',
        damage: 2,
        rating: 5,
        maxRating: 6,
        ratingLabel: 'Armor Rating',
        encumbrance: true,
        armorMods: armorMods,
        location: 'Torso',
        equipped: true,
        active: true,
        homeNode: true,
        wirelessOn: true,
        stolen: true,
        deviceRating: '4',
        programLimit: '3',
        overclocked: '1',
        attack: '5',
        sleaze: '6',
        dataProcessing: '7',
        firewall: '8',
        attributeArray: ['A', 'B', 'C'],
        modAttack: '1',
        modSleaze: '2',
        modDataProcessing: '3',
        modFirewall: '4',
        modAttributeArray: ['D', 'E', 'F'],
        canSwapAttributes: true,
        matrixCmFilled: 3,
        matrixCmBonus: 2,
        canFormPersona: true,
        notes: 'Test notes',
        notesColor: 'blue',
        discountedCost: true,
        sortOrder: 15,
        avail: '12F',
      );

      // Assert
      expect(armor.sourceId, 'test-source');
      expect(armor.locationGuid, 'test-guid');
      expect(armor.name, 'Full Body Armor');
      expect(armor.category, 'Heavy Armor');
      expect(armor.source, 'Run & Gun');
      expect(armor.page, '789');
      expect(armor.armorValue, '18');
      expect(armor.armorOverride, '20');
      expect(armor.armorCapacity, '10');
      expect(armor.cost, 15000);
      expect(armor.weight, '8');
      expect(armor.armorName, 'Custom Name');
      expect(armor.extra, 'Special features');
      expect(armor.damage, 2);
      expect(armor.rating, 5);
      expect(armor.maxRating, 6);
      expect(armor.ratingLabel, 'Armor Rating');
      expect(armor.encumbrance, true);
      expect(armor.armorMods, armorMods);
      expect(armor.location, 'Torso');
      expect(armor.equipped, true);
      expect(armor.active, true);
      expect(armor.homeNode, true);
      expect(armor.wirelessOn, true);
      expect(armor.stolen, true);
      expect(armor.deviceRating, '4');
      expect(armor.programLimit, '3');
      expect(armor.overclocked, '1');
      expect(armor.attack, '5');
      expect(armor.sleaze, '6');
      expect(armor.dataProcessing, '7');
      expect(armor.firewall, '8');
      expect(armor.attributeArray, ['A', 'B', 'C']);
      expect(armor.modAttack, '1');
      expect(armor.modSleaze, '2');
      expect(armor.modDataProcessing, '3');
      expect(armor.modFirewall, '4');
      expect(armor.modAttributeArray, ['D', 'E', 'F']);
      expect(armor.canSwapAttributes, true);
      expect(armor.matrixCmFilled, 3);
      expect(armor.matrixCmBonus, 2);
      expect(armor.canFormPersona, true);
      expect(armor.notes, 'Test notes');
      expect(armor.notesColor, 'blue');
      expect(armor.discountedCost, true);
      expect(armor.sortOrder, 15);
      expect(armor.avail, '12F');
    });

    group('fromXml', () {
      test('should parse minimal XML correctly', () {
        // Arrange
        final xmlString = '''
          <armor>
            <name>Basic Armor</name>
            <category>Armor</category>
            <armor>10</armor>
            <source>Core</source>
            <page>436</page>
          </armor>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armor = Armor.fromXml(xmlElement);

        // Assert
        expect(armor.name, 'Basic Armor');
        expect(armor.category, 'Armor');
        expect(armor.armorValue, '10');
        expect(armor.source, 'Core');
        expect(armor.page, '436');
        expect(armor.rating, 10); // Should use armor value as rating
        expect(armor.cost, 0);
        expect(armor.armorCapacity, '0');
        expect(armor.equipped, false);
        expect(armor.active, false);
        expect(armor.homeNode, false);
        expect(armor.wirelessOn, false);
        expect(armor.stolen, false);
        expect(armor.encumbrance, false);
        expect(armor.discountedCost, false);
        expect(armor.sortOrder, 0);
      });

      test('should parse complete XML correctly', () {
        // Arrange
        final xmlString = '''
          <armor>
            <sourceid>test-source</sourceid>
            <guid>test-guid</guid>
            <name>Advanced Armor</name>
            <category>Heavy Armor</category>
            <armor>18</armor>
            <armoroverride>20</armoroverride>
            <armorcapacity>10</armorcapacity>
            <avail>12F</avail>
            <cost>15000</cost>
            <weight>8</weight>
            <source>Run &amp; Gun</source>
            <page>789</page>
            <armorname>Custom Name</armorname>
            <equipped>True</equipped>
            <active>True</active>
            <homenode>True</homenode>
            <devicerating>4</devicerating>
            <programlimit>3</programlimit>
            <overclocked>1</overclocked>
            <attack>5</attack>
            <sleaze>6</sleaze>
            <dataprocessing>7</dataprocessing>
            <firewall>8</firewall>
            <wirelesson>True</wirelesson>
            <canformpersona>True</canformpersona>
            <extra>Special features</extra>
            <damage>2</damage>
            <maxrating>6</maxrating>
            <ratinglabel>Armor Rating</ratinglabel>
            <stolen>True</stolen>
            <emcumbrance>True</emcumbrance>
            <location>Torso</location>
            <notes>Test notes</notes>
            <notesColor>blue</notesColor>
            <discountedcost>True</discountedcost>
            <sortorder>15</sortorder>
            <armormods>
              <armormod>
                <name>Test Mod</name>
                <category>Electronics</category>
                <source>Core</source>
                <page>123</page>
              </armormod>
            </armormods>
          </armor>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armor = Armor.fromXml(xmlElement);

        // Assert
        expect(armor.sourceId, 'test-source');
        expect(armor.locationGuid, 'test-guid');
        expect(armor.name, 'Advanced Armor');
        expect(armor.category, 'Heavy Armor');
        expect(armor.armorValue, '18');
        expect(armor.armorOverride, '20');
        expect(armor.armorCapacity, '10');
        expect(armor.cost, 15000);
        expect(armor.weight, '8');
        expect(armor.source, 'Run & Gun');
        expect(armor.page, '789');
        expect(armor.armorName, 'Custom Name');
        expect(armor.equipped, true);
        expect(armor.active, true);
        expect(armor.homeNode, true);
        expect(armor.deviceRating, '4');
        expect(armor.programLimit, '3');
        expect(armor.overclocked, '1');
        expect(armor.attack, '5');
        expect(armor.sleaze, '6');
        expect(armor.dataProcessing, '7');
        expect(armor.firewall, '8');
        expect(armor.wirelessOn, true);
        expect(armor.canFormPersona, true);
        expect(armor.extra, 'Special features');
        expect(armor.damage, 2);
        expect(armor.rating, 18);
        expect(armor.maxRating, 6);
        expect(armor.ratingLabel, 'Armor Rating');
        expect(armor.stolen, true);
        expect(armor.encumbrance, true);
        expect(armor.location, 'Torso');
        expect(armor.notes, 'Test notes');
        expect(armor.notesColor, 'blue');
        expect(armor.discountedCost, true);
        expect(armor.sortOrder, 15);
        expect(armor.armorMods, isNotEmpty);
        expect(armor.armorMods?.first.name, 'Test Mod');
      });

      test('should handle missing XML elements gracefully', () {
        // Arrange
        final xmlString = '''
          <armor>
            <name></name>
            <category></category>
            <source></source>
            <page></page>
          </armor>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armor = Armor.fromXml(xmlElement);

        // Assert
        expect(armor.name, 'Unnamed Armor');
        expect(armor.category, 'Unknown');
        expect(armor.source, 'Unknown');
        expect(armor.page, '0');
        expect(armor.armorValue, '0');
        expect(armor.armorCapacity, '0');
      });

      test('should parse numeric values correctly with invalid input', () {
        // Arrange
        final xmlString = '''
          <armor>
            <name>Test</name>
            <category>Test</category>
            <source>Test</source>
            <page>1</page>
            <armor>invalid</armor>
            <cost>invalid</cost>
            <damage>invalid</damage>
            <maxrating>invalid</maxrating>
            <sortorder>invalid</sortorder>
          </armor>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armor = Armor.fromXml(xmlElement);

        // Assert
        expect(armor.rating, 0);
        expect(armor.cost, 0);
        expect(armor.damage, 0);
        expect(armor.maxRating, 0);
        expect(armor.sortOrder, 0);
      });

      test('should parse boolean values correctly', () {
        // Arrange
        final xmlString = '''
          <armor>
            <name>Test</name>
            <category>Test</category>
            <source>Test</source>
            <page>1</page>
            <equipped>False</equipped>
            <active>False</active>
            <homenode>False</homenode>
            <wirelesson>False</wirelesson>
            <canformpersona>False</canformpersona>
            <stolen>False</stolen>
            <emcumbrance>False</emcumbrance>
            <discountedcost>False</discountedcost>
          </armor>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armor = Armor.fromXml(xmlElement);

        // Assert
        expect(armor.equipped, false);
        expect(armor.active, false);
        expect(armor.homeNode, false);
        expect(armor.wirelessOn, false);
        expect(armor.canFormPersona, false);
        expect(armor.stolen, false);
        expect(armor.encumbrance, false);
        expect(armor.discountedCost, false);
      });

      test('should handle nested armor mods correctly', () {
        // Arrange
        final xmlString = '''
          <armor>
            <name>Test Armor</name>
            <category>Armor</category>
            <source>Core</source>
            <page>1</page>
            <armor>10</armor>
            <armormods>
              <armormod>
                <name>Mod 1</name>
                <category>Electronics</category>
                <source>Core</source>
                <page>2</page>
                <rating>2</rating>
              </armormod>
              <armormod>
                <name>Mod 2</name>
                <category>Physical</category>
                <source>Core</source>
                <page>3</page>
                <armor>1</armor>
              </armormod>
            </armormods>
          </armor>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armor = Armor.fromXml(xmlElement);

        // Assert
        expect(armor.armorMods, hasLength(2));
        expect(armor.armorMods![0].name, 'Mod 1');
        expect(armor.armorMods![0].rating, 2);
        expect(armor.armorMods![1].name, 'Mod 2');
        expect(armor.armorMods![1].armor, 1);
      });

      test('should handle empty armor mods element', () {
        // Arrange
        final xmlString = '''
          <armor>
            <name>Test Armor</name>
            <category>Armor</category>
            <source>Core</source>
            <page>1</page>
            <armor>10</armor>
            <armormods>
            </armormods>
          </armor>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armor = Armor.fromXml(xmlElement);

        // Assert
        expect(armor.armorMods, isEmpty);
      });

      test('should handle null XML element', () {
        // Arrange
        final xmlString = '''
          <armor>
          </armor>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final armor = Armor.fromXml(xmlElement);

        // Assert
        expect(armor.name, 'Unnamed Armor');
        expect(armor.category, 'Unknown');
        expect(armor.source, 'Unknown');
        expect(armor.page, '0');
        expect(armor.armorValue, '0');
        expect(armor.armorCapacity, '0');
        expect(armor.rating, 0);
        expect(armor.ratingLabel, 'String_Rating');
      });
    });
  });
}
