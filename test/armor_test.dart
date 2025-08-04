import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/armor.dart';
import 'package:chummer5x/models/items/armor_mod.dart';
import 'package:chummer5x/utils/xml_element_extensions.dart';

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
      expect(armor.name, 'Armor Jacket',
          reason: 'Name should match the value provided in constructor');
      expect(armor.category, 'Armor',
          reason: 'Category should match the value provided in constructor');
      expect(armor.source, 'Core',
          reason: 'Source should match the value provided in constructor');
      expect(armor.page, '436',
          reason: 'Page should match the value provided in constructor');
      expect(armor.armorValue, '12',
          reason: 'Armor value should match the value provided in constructor');
      expect(armor.armorCapacity, '6',
          reason:
              'Armor capacity should match the value provided in constructor');
      expect(armor.cost, 0,
          reason: 'Cost should default to 0 when not specified in constructor');
      expect(armor.damage, 0,
          reason:
              'Damage should default to 0 when not specified in constructor');
      expect(armor.rating, 0,
          reason:
              'Rating should default to 0 when not specified in constructor');
      expect(armor.maxRating, 0,
          reason:
              'Max rating should default to 0 when not specified in constructor');
      expect(armor.ratingLabel, 'String_Rating',
          reason:
              'Rating label should use default value when not specified in constructor');
      expect(armor.encumbrance, false,
          reason:
              'Encumbrance should default to false when not specified in constructor');
      expect(armor.equipped, false,
          reason:
              'Equipped status should default to false when not specified in constructor');
      expect(armor.active, false,
          reason:
              'Active status should default to false when not specified in constructor');
      expect(armor.homeNode, false,
          reason:
              'Home node status should default to false when not specified in constructor');
      expect(armor.wirelessOn, false,
          reason:
              'Wireless status should default to false when not specified in constructor');
      expect(armor.stolen, false,
          reason:
              'Stolen status should default to false when not specified in constructor');
      expect(armor.discountedCost, false,
          reason:
              'Discounted cost status should default to false when not specified in constructor');
      expect(armor.sortOrder, 0,
          reason:
              'Sort order should default to 0 when not specified in constructor');
      expect(armor.matrixCmFilled, 0,
          reason:
              'Matrix CM filled should default to 0 when not specified in constructor');
      expect(armor.matrixCmBonus, 0,
          reason:
              'Matrix CM bonus should default to 0 when not specified in constructor');
      expect(armor.canSwapAttributes, false,
          reason:
              'Can swap attributes should default to false when not specified in constructor');
      expect(armor.avail, '—',
          reason:
              'Availability should preserve the exact value provided in constructor without normalization');
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
      expect(armor.sourceId, 'test-source',
          reason: 'Source ID should match the value provided in constructor');
      expect(armor.locationGuid, 'test-guid',
          reason:
              'Location GUID should match the value provided in constructor');
      expect(armor.name, 'Full Body Armor',
          reason: 'Name should match the value provided in constructor');
      expect(armor.category, 'Heavy Armor',
          reason: 'Category should match the value provided in constructor');
      expect(armor.source, 'Run & Gun',
          reason: 'Source should match the value provided in constructor');
      expect(armor.page, '789',
          reason: 'Page should match the value provided in constructor');
      expect(armor.armorValue, '18',
          reason: 'Armor value should match the value provided in constructor');
      expect(armor.armorOverride, '20',
          reason:
              'Armor override should match the value provided in constructor');
      expect(armor.armorCapacity, '10',
          reason:
              'Armor capacity should match the value provided in constructor');
      expect(armor.cost, 15000,
          reason: 'Cost should match the value provided in constructor');
      expect(armor.weight, '8',
          reason: 'Weight should match the value provided in constructor');
      expect(armor.armorName, 'Custom Name',
          reason: 'Armor name should match the value provided in constructor');
      expect(armor.extra, 'Special features',
          reason: 'Extra field should match the value provided in constructor');
      expect(armor.damage, 2,
          reason: 'Damage should match the value provided in constructor');
      expect(armor.rating, 5,
          reason: 'Rating should match the value provided in constructor');
      expect(armor.maxRating, 6,
          reason: 'Max rating should match the value provided in constructor');
      expect(armor.ratingLabel, 'Armor Rating',
          reason:
              'Rating label should match the value provided in constructor');
      expect(armor.encumbrance, true,
          reason: 'Encumbrance should match the value provided in constructor');
      expect(armor.armorMods, armorMods,
          reason: 'Armor mods should match the list provided in constructor');
      expect(armor.location, 'Torso',
          reason: 'Location should match the value provided in constructor');
      expect(armor.equipped, true,
          reason:
              'Equipped status should match the value provided in constructor');
      expect(armor.active, true,
          reason:
              'Active status should match the value provided in constructor');
      expect(armor.homeNode, true,
          reason:
              'Home node status should match the value provided in constructor');
      expect(armor.wirelessOn, true,
          reason:
              'Wireless status should match the value provided in constructor');
      expect(armor.stolen, true,
          reason:
              'Stolen status should match the value provided in constructor');
      expect(armor.deviceRating, '4',
          reason:
              'Device rating should match the value provided in constructor');
      expect(armor.programLimit, '3',
          reason:
              'Program limit should match the value provided in constructor');
      expect(armor.overclocked, '1',
          reason:
              'Overclocked value should match the value provided in constructor');
      expect(armor.attack, '5',
          reason:
              'Attack value should match the value provided in constructor');
      expect(armor.sleaze, '6',
          reason:
              'Sleaze value should match the value provided in constructor');
      expect(armor.dataProcessing, '7',
          reason:
              'Data processing value should match the value provided in constructor');
      expect(armor.firewall, '8',
          reason:
              'Firewall value should match the value provided in constructor');
      expect(armor.attributeArray, ['A', 'B', 'C'],
          reason:
              'Attribute array should match the list provided in constructor');
      expect(armor.modAttack, '1',
          reason:
              'Mod attack value should match the value provided in constructor');
      expect(armor.modSleaze, '2',
          reason:
              'Mod sleaze value should match the value provided in constructor');
      expect(armor.modDataProcessing, '3',
          reason:
              'Mod data processing value should match the value provided in constructor');
      expect(armor.modFirewall, '4',
          reason:
              'Mod firewall value should match the value provided in constructor');
      expect(armor.modAttributeArray, ['D', 'E', 'F'],
          reason:
              'Mod attribute array should match the list provided in constructor');
      expect(armor.canSwapAttributes, true,
          reason:
              'Can swap attributes should match the value provided in constructor');
      expect(armor.matrixCmFilled, 3,
          reason:
              'Matrix CM filled should match the value provided in constructor');
      expect(armor.matrixCmBonus, 2,
          reason:
              'Matrix CM bonus should match the value provided in constructor');
      expect(armor.canFormPersona, true,
          reason:
              'Can form persona should match the value provided in constructor');
      expect(armor.notes, 'Test notes',
          reason: 'Notes should match the value provided in constructor');
      expect(armor.notesColor, 'blue',
          reason: 'Notes color should match the value provided in constructor');
      expect(armor.discountedCost, true,
          reason:
              'Discounted cost status should match the value provided in constructor');
      expect(armor.sortOrder, 15,
          reason: 'Sort order should match the value provided in constructor');
      expect(armor.avail, '12F',
          reason:
              'Availability should match the value provided in constructor');
    });

    test('XmlElement.parseList parses multiple Armor items from <armors>', () {
      // Arrange
      final xmlString = '''
        <root>
          <armors>
            <armor>
              <name>Armor One</name>
              <category>Light Armor</category>
              <armor>8</armor>
              <armorcapacity>4</armorcapacity>
              <source>Core</source>
              <page>430</page>
            </armor>
            <armor>
              <name>Armor Two</name>
              <category>Heavy Armor</category>
              <armor>16</armor>
              <armorcapacity>8</armorcapacity>
              <source>Run & Gun</source>
              <page>440</page>
            </armor>
          </armors>
        </root>
      ''';
      final document = XmlDocument.parse(xmlString);
      final root = document.rootElement;

      // Act
      final armors = root.parseList<Armor>(
        collectionTagName: 'armors',
        itemTagName: 'armor',
        fromXml: Armor.fromXml,
      );

      // Assert
      expect(armors, hasLength(2),
          reason: 'Should parse two Armor items from <armors>');
      expect(armors[0].name, 'Armor One',
          reason: 'First armor name should be Armor One');
      expect(armors[1].name, 'Armor Two',
          reason: 'Second armor name should be Armor Two');
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
        expect(armor.name, 'Basic Armor',
            reason: 'Name should be parsed from XML name element');
        expect(armor.category, 'Armor',
            reason: 'Category should be parsed from XML category element');
        expect(armor.armorValue, '10',
            reason: 'Armor value should be parsed from XML armor element');
        expect(armor.source, 'Core',
            reason: 'Source should be parsed from XML source element');
        expect(armor.page, '436',
            reason: 'Page should be parsed from XML page element');
        expect(armor.rating, 10,
            reason:
                'Rating should be derived from armor value when rating element is not present');
        expect(armor.cost, 0,
            reason:
                'Cost should default to 0 when cost element is not present in XML');
        expect(armor.armorCapacity, '0',
            reason:
                'Armor capacity should default to "0" when armorcapacity element is not present in XML');
        expect(armor.equipped, false,
            reason:
                'Equipped should default to false when equipped element is not present in XML');
        expect(armor.active, false,
            reason:
                'Active should default to false when active element is not present in XML');
        expect(armor.homeNode, false,
            reason:
                'Home node should default to false when homenode element is not present in XML');
        expect(armor.wirelessOn, false,
            reason:
                'Wireless should default to false when wirelesson element is not present in XML');
        expect(armor.stolen, false,
            reason:
                'Stolen should default to false when stolen element is not present in XML');
        expect(armor.encumbrance, false,
            reason:
                'Encumbrance should default to false when emcumbrance element is not present in XML');
        expect(armor.discountedCost, false,
            reason:
                'Discounted cost should default to false when discountedcost element is not present in XML');
        expect(armor.sortOrder, 0,
            reason:
                'Sort order should default to 0 when sortorder element is not present in XML');
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
        expect(armor.sourceId, 'test-source',
            reason: 'Source ID should be parsed from XML sourceid element');
        expect(armor.locationGuid, 'Torso',
            reason: 'Location GUID should be parsed from XML guid element');
        expect(armor.name, 'Advanced Armor',
            reason: 'Name should be parsed from XML name element');
        expect(armor.category, 'Heavy Armor',
            reason: 'Category should be parsed from XML category element');
        expect(armor.armorValue, '18',
            reason: 'Armor value should be parsed from XML armor element');
        expect(armor.armorOverride, '20',
            reason:
                'Armor override should be parsed from XML armoroverride element');
        expect(armor.armorCapacity, '10',
            reason:
                'Armor capacity should be parsed from XML armorcapacity element');
        expect(armor.cost, 15000,
            reason: 'Cost should be parsed from XML cost element');
        expect(armor.weight, '8',
            reason: 'Weight should be parsed from XML weight element');
        expect(armor.source, 'Run & Gun',
            reason:
                'Source should be parsed from XML source element with ampersands decoded');
        expect(armor.page, '789',
            reason: 'Page should be parsed from XML page element');
        expect(armor.armorName, 'Custom Name',
            reason: 'Armor name should be parsed from XML armorname element');
        expect(armor.equipped, true,
            reason:
                'Equipped should be parsed as true from XML equipped element value "True"');
        expect(armor.active, true,
            reason:
                'Active should be parsed as true from XML active element value "True"');
        expect(armor.homeNode, true,
            reason:
                'Home node should be parsed as true from XML homenode element value "True"');
        expect(armor.deviceRating, '4',
            reason:
                'Device rating should be parsed from XML devicerating element');
        expect(armor.programLimit, '3',
            reason:
                'Program limit should be parsed from XML programlimit element');
        expect(armor.overclocked, '1',
            reason:
                'Overclocked should be parsed from XML overclocked element');
        expect(armor.attack, '5',
            reason: 'Attack should be parsed from XML attack element');
        expect(armor.sleaze, '6',
            reason: 'Sleaze should be parsed from XML sleaze element');
        expect(armor.dataProcessing, '7',
            reason:
                'Data processing should be parsed from XML dataprocessing element');
        expect(armor.firewall, '8',
            reason: 'Firewall should be parsed from XML firewall element');
        expect(armor.wirelessOn, true,
            reason:
                'Wireless should be parsed as true from XML wirelesson element value "True"');
        expect(armor.canFormPersona, true,
            reason:
                'Can form persona should be parsed as true from XML canformpersona element value "True"');
        expect(armor.extra, 'Special features',
            reason: 'Extra should be parsed from XML extra element');
        expect(armor.damage, 2,
            reason: 'Damage should be parsed from XML damage element');
        expect(armor.rating, 18,
            reason:
                'Rating should be derived from armor value when rating element is not present');
        expect(armor.maxRating, 6,
            reason: 'Max rating should be parsed from XML maxrating element');
        expect(armor.ratingLabel, 'Armor Rating',
            reason:
                'Rating label should be parsed from XML ratinglabel element');
        expect(armor.stolen, true,
            reason:
                'Stolen should be parsed as true from XML stolen element value "True"');
        expect(armor.encumbrance, true,
            reason:
                'Encumbrance should be parsed as true from XML emcumbrance element value "True"');
        expect(armor.location, 'Torso',
            reason: 'Location should be parsed from XML location element');
        expect(armor.notes, 'Test notes',
            reason: 'Notes should be parsed from XML notes element');
        expect(armor.notesColor, 'blue',
            reason: 'Notes color should be parsed from XML notesColor element');
        expect(armor.discountedCost, true,
            reason:
                'Discounted cost should be parsed as true from XML discountedcost element value "True"');
        expect(armor.sortOrder, 15,
            reason: 'Sort order should be parsed from XML sortorder element');
        expect(armor.armorMods, isNotEmpty,
            reason:
                'Armor mods should be parsed from XML armormods element and contain at least one mod');
        expect(armor.armorMods?.first.name, 'Test Mod',
            reason:
                'First armor mod name should be parsed correctly from nested XML structure');
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
        expect(armor.name, 'Unnamed Armor',
            reason:
                'Name should default to "Unnamed Armor" when XML name element is empty');
        expect(armor.category, 'Unknown',
            reason:
                'Category should default to "Unknown" when XML category element is empty');
        expect(armor.source, 'Unknown',
            reason:
                'Source should default to "Unknown" when XML source element is empty');
        expect(armor.page, '0',
            reason:
                'Page should default to "0" when XML page element is empty');
        expect(armor.armorValue, '0',
            reason:
                'Armor value should default to "0" when XML armor element is missing');
        expect(armor.armorCapacity, '0',
            reason:
                'Armor capacity should default to "0" when XML armorcapacity element is missing');
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
        expect(armor.rating, 0,
            reason:
                'Rating should default to 0 when XML armor element contains invalid numeric value');
        expect(armor.cost, 0,
            reason:
                'Cost should default to 0 when XML cost element contains invalid numeric value');
        expect(armor.damage, 0,
            reason:
                'Damage should default to 0 when XML damage element contains invalid numeric value');
        expect(armor.maxRating, 0,
            reason:
                'Max rating should default to 0 when XML maxrating element contains invalid numeric value');
        expect(armor.sortOrder, 0,
            reason:
                'Sort order should default to 0 when XML sortorder element contains invalid numeric value');
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
        expect(armor.equipped, false,
            reason:
                'Equipped should be parsed as false from XML equipped element value "False"');
        expect(armor.active, false,
            reason:
                'Active should be parsed as false from XML active element value "False"');
        expect(armor.homeNode, false,
            reason:
                'Home node should be parsed as false from XML homenode element value "False"');
        expect(armor.wirelessOn, false,
            reason:
                'Wireless should be parsed as false from XML wirelesson element value "False"');
        expect(armor.canFormPersona, false,
            reason:
                'Can form persona should be parsed as false from XML canformpersona element value "False"');
        expect(armor.stolen, false,
            reason:
                'Stolen should be parsed as false from XML stolen element value "False"');
        expect(armor.encumbrance, false,
            reason:
                'Encumbrance should be parsed as false from XML emcumbrance element value "False"');
        expect(armor.discountedCost, false,
            reason:
                'Discounted cost should be parsed as false from XML discountedcost element value "False"');
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
        expect(armor.armorMods, hasLength(2),
            reason:
                'Armor should have 2 armor mods parsed from XML armormods element');
        expect(armor.armorMods![0].name, 'Mod 1',
            reason:
                'First armor mod name should be parsed correctly from nested armormod XML element');
        expect(armor.armorMods![0].rating, 2,
            reason:
                'First armor mod rating should be parsed correctly from nested armormod XML element');
        expect(armor.armorMods![1].name, 'Mod 2',
            reason:
                'Second armor mod name should be parsed correctly from nested armormod XML element');
        expect(armor.armorMods![1].armor, 1,
            reason:
                'Second armor mod armor value should be parsed correctly from nested armormod XML element');
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
        expect(armor.armorMods, isEmpty,
            reason:
                'Armor mods should be empty when XML armormods element contains no child elements');
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
        expect(armor.name, 'Unnamed Armor',
            reason:
                'Name should default to "Unnamed Armor" when XML element is completely empty');
        expect(armor.category, 'Unknown',
            reason:
                'Category should default to "Unknown" when XML element is completely empty');
        expect(armor.source, 'Unknown',
            reason:
                'Source should default to "Unknown" when XML element is completely empty');
        expect(armor.page, '0',
            reason:
                'Page should default to "0" when XML element is completely empty');
        expect(armor.armorValue, '0',
            reason:
                'Armor value should default to "0" when XML element is completely empty');
        expect(armor.armorCapacity, '0',
            reason:
                'Armor capacity should default to "0" when XML element is completely empty');
        expect(armor.rating, 0,
            reason:
                'Rating should default to 0 when XML element is completely empty');
        expect(armor.ratingLabel, 'String_Rating',
            reason:
                'Rating label should use default value when XML element is completely empty');
      });
    });
  });
}
