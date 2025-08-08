import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/utils/xml_element_extensions.dart';
import 'package:chummer5x/models/items/weapon.dart';
import 'package:chummer5x/models/items/weapon_mount.dart';

void main() {
  group('WeaponMount', () {
    test('should create WeaponMount with required parameters', () {
      // Arrange & Act
      final weaponMount = WeaponMount(
        sourceId: 'test-source',
        guid: 'test-guid',
        name: 'Standard Weapon Mount',
        category: 'Weapon Mounts',
        slots: '2',
        avail: '6R',
        cost: 5000,
        freeCost: false,
        markup: '0',
        source: 'Core',
        page: '462',
        included: false,
        equipped: true,
        weaponMountCategories: 'Light Weapons',
        weaponCapacity: '1',
        weapons: [],
        weaponMountOptions: [],
        mods: [],
        discountedCost: false,
        sortOrder: 0,
        stolen: false,
      );

      // Assert
      expect(weaponMount.sourceId, 'test-source');
      expect(weaponMount.guid, 'test-guid');
      expect(weaponMount.name, 'Standard Weapon Mount');
      expect(weaponMount.category, 'Weapon Mounts');
      expect(weaponMount.slots, '2');
      expect(weaponMount.avail, '6R');
      expect(weaponMount.cost, 5000);
      expect(weaponMount.freeCost, false);
      expect(weaponMount.markup, '0');
      expect(weaponMount.source, 'Core');
      expect(weaponMount.page, '462');
      expect(weaponMount.included, false);
      expect(weaponMount.equipped, true);
      expect(weaponMount.weaponMountCategories, 'Light Weapons');
      expect(weaponMount.weaponCapacity, '1');
      expect(weaponMount.weapons, isEmpty);
      expect(weaponMount.weaponMountOptions, isEmpty);
      expect(weaponMount.mods, isEmpty);
      expect(weaponMount.discountedCost, false);
      expect(weaponMount.sortOrder, 0);
      expect(weaponMount.stolen, false);

      // Check optional defaults
      expect(weaponMount.limit, null);
      expect(weaponMount.extra, null);
      expect(weaponMount.notes, null);
      expect(weaponMount.notesColor, null);
    });

    test('should create WeaponMount with all optional parameters', () {
      // Arrange & Act
      final weaponMount = WeaponMount(
        sourceId: 'advanced-source',
        guid: 'advanced-guid',
        name: 'Heavy Weapon Mount',
        category: 'Heavy Weapon Mounts',
        limit: 'Physical',
        slots: '4',
        avail: '12F',
        cost: 25000,
        freeCost: true,
        markup: '10',
        extra: 'Gyroscopic',
        source: 'Rigger 5.0',
        page: '180',
        included: true,
        equipped: true,
        weaponMountCategories: 'Heavy Weapons',
        weaponCapacity: '3',
        weapons: [],
        weaponMountOptions: [],
        mods: [],
        notes: 'Custom weapon mount',
        notesColor: 'blue',
        discountedCost: true,
        sortOrder: 5,
        stolen: true,
      );

      // Assert
      expect(weaponMount.sourceId, 'advanced-source');
      expect(weaponMount.guid, 'advanced-guid');
      expect(weaponMount.name, 'Heavy Weapon Mount');
      expect(weaponMount.category, 'Heavy Weapon Mounts');
      expect(weaponMount.limit, 'Physical');
      expect(weaponMount.slots, '4');
      expect(weaponMount.avail, '12F');
      expect(weaponMount.cost, 25000);
      expect(weaponMount.freeCost, true);
      expect(weaponMount.markup, '10');
      expect(weaponMount.extra, 'Gyroscopic');
      expect(weaponMount.source, 'Rigger 5.0');
      expect(weaponMount.page, '180');
      expect(weaponMount.included, true);
      expect(weaponMount.equipped, true);
      expect(weaponMount.weaponMountCategories, 'Heavy Weapons');
      expect(weaponMount.weaponCapacity, '3');
      expect(weaponMount.weapons, isEmpty);
      expect(weaponMount.weaponMountOptions, isEmpty);
      expect(weaponMount.mods, isEmpty);
      expect(weaponMount.notes, 'Custom weapon mount');
      expect(weaponMount.notesColor, 'blue');
      expect(weaponMount.discountedCost, true);
      expect(weaponMount.sortOrder, 5);
      expect(weaponMount.stolen, true);
    });

    group('fromXml', () {
      test('should parse minimal XML correctly', () {
        // Arrange
        final xmlString = '''
          <weaponmount>
            <sourceid>basic-source</sourceid>
            <guid>basic-guid</guid>
            <name>Basic Mount</name>
            <category>Weapon Mounts</category>
            <slots>1</slots>
            <avail>4R</avail>
            <cost>2000</cost>
            <freecost>False</freecost>
            <markup>0</markup>
            <source>Core</source>
            <page>460</page>
            <included>False</included>
            <equipped>True</equipped>
            <weaponmountcategories>Light Weapons</weaponmountcategories>
            <weaponcapacity>1</weaponcapacity>
            <weapons></weapons>
            <weaponmountoptions></weaponmountoptions>
            <mods></mods>
            <discountedcost>False</discountedcost>
            <sortorder>0</sortorder>
            <stolen>False</stolen>
          </weaponmount>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final weaponMount = WeaponMount.fromXml(xmlElement);

        // Assert
        expect(weaponMount.sourceId, 'basic-source');
        expect(weaponMount.guid, 'basic-guid');
        expect(weaponMount.name, 'Basic Mount');
        expect(weaponMount.category, 'Weapon Mounts');
        expect(weaponMount.slots, '1');
        expect(weaponMount.avail, '4R');
        expect(weaponMount.cost, 2000.0);
        expect(weaponMount.freeCost, false);
        expect(weaponMount.markup, '0');
        expect(weaponMount.source, 'Core');
        expect(weaponMount.page, '460');
        expect(weaponMount.included, false);
        expect(weaponMount.equipped, true);
        expect(weaponMount.weaponMountCategories, 'Light Weapons');
        expect(weaponMount.weaponCapacity, '1');
        expect(weaponMount.weapons, isEmpty);
        expect(weaponMount.weaponMountOptions, isEmpty);
        expect(weaponMount.mods, isEmpty);
        expect(weaponMount.discountedCost, false);
        expect(weaponMount.sortOrder, 0);
        expect(weaponMount.stolen, false);
        expect(weaponMount.limit, null);
        expect(weaponMount.extra, null);
        expect(weaponMount.notes, null);
        expect(weaponMount.notesColor, null);
      });

      test(
          'XmlElement.parseList parses multiple Weapon items from <weapons> in WeaponMount',
          () {
        // Arrange
        final xmlString = '''
          <weaponmount>
            <weapons>
              <weapon>
                <name>Mount Weapon One</name>
                <category>Heavy</category>
                <type>Ranged</type>
                <damage>8P</damage>
                <ap>-1</ap>
                <mode>SA/BF</mode>
                <ammo>20(c)</ammo>
                <firingmode>BF</firingmode>
                <accuracy>5</accuracy>
                <source>Core</source>
                <page>428</page>
                <avail>6F</avail>
              </weapon>
              <weapon>
                <name>Mount Weapon Two</name>
                <category>Light</category>
                <type>Ranged</type>
                <damage>6P</damage>
                <ap>0</ap>
                <mode>SA</mode>
                <ammo>10(c)</ammo>
                <firingmode>SA</firingmode>
                <accuracy>4</accuracy>
                <source>Core</source>
                <page>429</page>
                <avail>4R</avail>
              </weapon>
            </weapons>
          </weaponmount>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final weapons = xmlElement.parseList<Weapon>(
          collectionTagName: 'weapons',
          itemTagName: 'weapon',
          fromXml: Weapon.fromXml,
        );

        // Assert
        expect(weapons, hasLength(2),
            reason: 'Should parse two Weapon items from <weapons>');
        expect(weapons[0].name, 'Mount Weapon One',
            reason: 'First weapon name should be Mount Weapon One');
        expect(weapons[1].name, 'Mount Weapon Two',
            reason: 'Second weapon name should be Mount Weapon Two');
      });

      test('should parse complete XML correctly', () {
        // Arrange
        final xmlString = '''
          <weaponmount>
            <sourceid>complete-source</sourceid>
            <guid>complete-guid</guid>
            <name>Complete Mount</name>
            <category>Heavy Weapon Mounts</category>
            <limit>Physical</limit>
            <slots>3</slots>
            <avail>10F</avail>
            <cost>15000</cost>
            <freecost>True</freecost>
            <markup>5</markup>
            <extra>Stabilized</extra>
            <source>Rigger 5.0</source>
            <page>175</page>
            <included>True</included>
            <equipped>True</equipped>
            <weaponmountcategories>Heavy Weapons</weaponmountcategories>
            <weaponcapacity>2</weaponcapacity>
            <weapons>
              <weapon>
                <name>Mounted Rifle</name>
                <category>Assault Rifles</category>
                <type>Ranged</type>
                <damage>8P</damage>
                <ap>-1</ap>
                <mode>SA/BF</mode>
                <ammo>20(c)</ammo>
                <firingmode>BF</firingmode>
                <accuracy>5</accuracy>
                <source>Core</source>
                <page>428</page>
                <avail>6F</avail>
              </weapon>
            </weapons>
            <weaponmountoptions>
              <weaponmountoption>
                <sourceid>option-source</sourceid>
                <guid>option-guid</guid>
                <name>Gyroscopic Stabilization</name>
                <category>Weapon Mount Options</category>
                <slots>1</slots>
                <avail>8R</avail>
                <cost>5000</cost>
                <includedinparent>False</includedinparent>
              </weaponmountoption>
            </weaponmountoptions>
            <mods>
              <mod>
                <sourceid>mod-source</sourceid>
                <guid>mod-guid</guid>
                <name>Reinforced Mount</name>
                <category>Body</category>
                <slots>1</slots>
                <rating>2</rating>
                <maxrating>4</maxrating>
                <ratinglabel>Rating</ratinglabel>
                <conditionmonitor>1</conditionmonitor>
                <avail>6R</avail>
                <cost>3000</cost>
                <markup>0</markup>
                <source>Core</source>
                <page>465</page>
                <included>False</included>
                <equipped>True</equipped>
                <wirelesson>False</wirelesson>
                <ammobonus>0</ammobonus>
                <ammobonuspercent>0</ammobonuspercent>
                <discountedcost>False</discountedcost>
                <sortorder>0</sortorder>
                <stolen>False</stolen>
              </mod>
            </mods>
            <notes>Advanced mount system</notes>
            <notesColor>green</notesColor>
            <discountedcost>True</discountedcost>
            <sortorder>3</sortorder>
            <stolen>True</stolen>
          </weaponmount>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final weaponMount = WeaponMount.fromXml(xmlElement);

        // Assert
        expect(weaponMount.sourceId, 'complete-source');
        expect(weaponMount.guid, 'complete-guid');
        expect(weaponMount.name, 'Complete Mount');
        expect(weaponMount.category, 'Heavy Weapon Mounts');
        expect(weaponMount.limit, 'Physical');
        expect(weaponMount.slots, '3');
        expect(weaponMount.avail, '10F');
        expect(weaponMount.cost, 15000.0);
        expect(weaponMount.freeCost, true);
        expect(weaponMount.markup, '5');
        expect(weaponMount.extra, 'Stabilized');
        expect(weaponMount.source, 'Rigger 5.0');
        expect(weaponMount.page, '175');
        expect(weaponMount.included, true);
        expect(weaponMount.equipped, true);
        expect(weaponMount.weaponMountCategories, 'Heavy Weapons');
        expect(weaponMount.weaponCapacity, '2');
        expect(weaponMount.weapons, hasLength(1));
        expect(weaponMount.weapons!.first.name, 'Mounted Rifle');
        expect(weaponMount.weaponMountOptions, hasLength(1));
        expect(weaponMount.weaponMountOptions.first.name,
            'Gyroscopic Stabilization');
        expect(weaponMount.mods, hasLength(1));
        expect(weaponMount.mods.first.name, 'Reinforced Mount');
        expect(weaponMount.notes, 'Advanced mount system');
        expect(weaponMount.notesColor, 'green');
        expect(weaponMount.discountedCost, true);
        expect(weaponMount.sortOrder, 3);
        expect(weaponMount.stolen, true);
      });

      test('should handle missing XML elements gracefully', () {
        // Arrange
        final xmlString = '''
          <weaponmount>
          </weaponmount>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final weaponMount = WeaponMount.fromXml(xmlElement);

        // Assert
        expect(weaponMount.sourceId, '');
        expect(weaponMount.guid, '');
        expect(weaponMount.name, '');
        expect(weaponMount.category, '');
        expect(weaponMount.slots, '');
        expect(weaponMount.avail, '');
        expect(weaponMount.cost, 0.0);
        expect(weaponMount.freeCost, false);
        expect(weaponMount.markup, '0');
        expect(weaponMount.source, '');
        expect(weaponMount.page, '');
        expect(weaponMount.included, false);
        expect(weaponMount.equipped, false);
        expect(weaponMount.weaponMountCategories, '');
        expect(weaponMount.weaponCapacity, '0');
        expect(weaponMount.weapons, isEmpty);
        expect(weaponMount.weaponMountOptions, isEmpty);
        expect(weaponMount.mods, isEmpty);
        expect(weaponMount.discountedCost, false);
        expect(weaponMount.sortOrder, 0);
        expect(weaponMount.stolen, false);
      });

      test('should parse boolean values correctly', () {
        // Arrange
        final xmlString = '''
          <weaponmount>
            <sourceid>bool-test</sourceid>
            <guid>bool-guid</guid>
            <name>Boolean Test</name>
            <category>Test</category>
            <slots>1</slots>
            <avail>1</avail>
            <cost>1</cost>
            <freecost>True</freecost>
            <markup>1</markup>
            <source>Test</source>
            <page>1</page>
            <included>True</included>
            <equipped>False</equipped>
            <weaponmountcategories>Test</weaponmountcategories>
            <weaponcapacity>1</weaponcapacity>
            <weapons></weapons>
            <weaponmountoptions></weaponmountoptions>
            <mods></mods>
            <discountedcost>True</discountedcost>
            <sortorder>1</sortorder>
            <stolen>False</stolen>
          </weaponmount>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final weaponMount = WeaponMount.fromXml(xmlElement);

        // Assert
        expect(weaponMount.freeCost, true);
        expect(weaponMount.included, true);
        expect(weaponMount.equipped, false);
        expect(weaponMount.discountedCost, true);
        expect(weaponMount.stolen, false);
      });
    });
  });
}
