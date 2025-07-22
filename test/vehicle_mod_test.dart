import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/vehicle_mod.dart';

void main() {
  group('VehicleMod', () {
    test('should create VehicleMod with required parameters', () {
      // Arrange & Act
      final vehicleMod = VehicleMod(
        sourceId: 'test-source',
        guid: 'test-guid',
        name: 'Armor Plating',
        category: 'Body',
        slots: '2',
        rating: '3',
        maxRating: '6',
        ratingLabel: 'Rating',
        conditionMonitor: '2',
        avail: '8R',
        cost: '5000',
        markup: '0',
        source: 'Core',
        page: '460',
        included: false,
        equipped: true,
        wirelessOn: false,
        ammoBonus: '0',
        ammoBonusPercent: '0',
        discountedCost: false,
        sortOrder: '0',
        stolen: false,
      );

      // Assert
      expect(vehicleMod.sourceId, 'test-source');
      expect(vehicleMod.guid, 'test-guid');
      expect(vehicleMod.name, 'Armor Plating');
      expect(vehicleMod.category, 'Body');
      expect(vehicleMod.slots, '2');
      expect(vehicleMod.rating, '3');
      expect(vehicleMod.maxRating, '6');
      expect(vehicleMod.ratingLabel, 'Rating');
      expect(vehicleMod.conditionMonitor, '2');
      expect(vehicleMod.avail, '8R');
      expect(vehicleMod.cost, '5000');
      expect(vehicleMod.markup, '0');
      expect(vehicleMod.source, 'Core');
      expect(vehicleMod.page, '460');
      expect(vehicleMod.included, false);
      expect(vehicleMod.equipped, true);
      expect(vehicleMod.wirelessOn, false);
      expect(vehicleMod.ammoBonus, '0');
      expect(vehicleMod.ammoBonusPercent, '0');
      expect(vehicleMod.discountedCost, false);
      expect(vehicleMod.sortOrder, '0');
      expect(vehicleMod.stolen, false);
      
      // Check optional defaults
      expect(vehicleMod.limit, null);
      expect(vehicleMod.capacity, null);
      expect(vehicleMod.extra, null);
      expect(vehicleMod.subsystems, null);
      expect(vehicleMod.weaponMountCategories, null);
      expect(vehicleMod.ammoReplace, null);
      expect(vehicleMod.weapons, null);
      expect(vehicleMod.notes, null);
      expect(vehicleMod.notesColor, null);
    });

    test('should create VehicleMod with all optional parameters', () {
      // Arrange & Act
      final vehicleMod = VehicleMod(
        sourceId: 'advanced-source',
        guid: 'advanced-guid',
        name: 'Advanced Sensor Array',
        category: 'Sensor',
        limit: 'Physical',
        slots: '4',
        capacity: '8',
        rating: '5',
        maxRating: '6',
        ratingLabel: 'Rating',
        conditionMonitor: '4',
        avail: '12F',
        cost: '25000',
        markup: '10',
        extra: 'Cybereyes',
        source: 'Run & Gun',
        page: '123',
        included: true,
        equipped: true,
        wirelessOn: true,
        subsystems: 'Camera, Microphone',
        weaponMountCategories: 'Light Weapons',
        ammoBonus: '10',
        ammoBonusPercent: '25',
        ammoReplace: 'APDS',
        weapons: [],
        notes: 'Advanced modification',
        notesColor: 'green',
        discountedCost: true,
        sortOrder: '5',
        stolen: true,
      );

      // Assert
      expect(vehicleMod.sourceId, 'advanced-source');
      expect(vehicleMod.guid, 'advanced-guid');
      expect(vehicleMod.name, 'Advanced Sensor Array');
      expect(vehicleMod.category, 'Sensor');
      expect(vehicleMod.limit, 'Physical');
      expect(vehicleMod.slots, '4');
      expect(vehicleMod.capacity, '8');
      expect(vehicleMod.rating, '5');
      expect(vehicleMod.maxRating, '6');
      expect(vehicleMod.ratingLabel, 'Rating');
      expect(vehicleMod.conditionMonitor, '4');
      expect(vehicleMod.avail, '12F');
      expect(vehicleMod.cost, '25000');
      expect(vehicleMod.markup, '10');
      expect(vehicleMod.extra, 'Cybereyes');
      expect(vehicleMod.source, 'Run & Gun');
      expect(vehicleMod.page, '123');
      expect(vehicleMod.included, true);
      expect(vehicleMod.equipped, true);
      expect(vehicleMod.wirelessOn, true);
      expect(vehicleMod.subsystems, 'Camera, Microphone');
      expect(vehicleMod.weaponMountCategories, 'Light Weapons');
      expect(vehicleMod.ammoBonus, '10');
      expect(vehicleMod.ammoBonusPercent, '25');
      expect(vehicleMod.ammoReplace, 'APDS');
      expect(vehicleMod.weapons, isEmpty);
      expect(vehicleMod.notes, 'Advanced modification');
      expect(vehicleMod.notesColor, 'green');
      expect(vehicleMod.discountedCost, true);
      expect(vehicleMod.sortOrder, '5');
      expect(vehicleMod.stolen, true);
    });

    group('fromXmlElement', () {
      test('should parse minimal XML correctly', () {
        // Arrange
        final xmlString = '''
          <vehiclemod>
            <sourceid>basic-source</sourceid>
            <guid>basic-guid</guid>
            <name>Basic Mod</name>
            <category>Body</category>
            <slots>1</slots>
            <rating>2</rating>
            <maxrating>4</maxrating>
            <ratinglabel>Rating</ratinglabel>
            <conditionmonitor>1</conditionmonitor>
            <avail>4R</avail>
            <cost>2000</cost>
            <markup>0</markup>
            <source>Core</source>
            <page>450</page>
            <included>False</included>
            <equipped>True</equipped>
            <wirelesson>False</wirelesson>
            <ammobonus>0</ammobonus>
            <ammobonuspercent>0</ammobonuspercent>
            <discountedcost>False</discountedcost>
            <sortorder>0</sortorder>
            <stolen>False</stolen>
          </vehiclemod>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final vehicleMod = VehicleMod.fromXmlElement(xmlElement);

        // Assert
        expect(vehicleMod.sourceId, 'basic-source');
        expect(vehicleMod.guid, 'basic-guid');
        expect(vehicleMod.name, 'Basic Mod');
        expect(vehicleMod.category, 'Body');
        expect(vehicleMod.slots, '1');
        expect(vehicleMod.rating, '2');
        expect(vehicleMod.maxRating, '4');
        expect(vehicleMod.ratingLabel, 'Rating');
        expect(vehicleMod.conditionMonitor, '1');
        expect(vehicleMod.avail, '4R');
        expect(vehicleMod.cost, '2000');
        expect(vehicleMod.markup, '0');
        expect(vehicleMod.source, 'Core');
        expect(vehicleMod.page, '450');
        expect(vehicleMod.included, false);
        expect(vehicleMod.equipped, true);
        expect(vehicleMod.wirelessOn, false);
        expect(vehicleMod.ammoBonus, '0');
        expect(vehicleMod.ammoBonusPercent, '0');
        expect(vehicleMod.discountedCost, false);
        expect(vehicleMod.sortOrder, '0');
        expect(vehicleMod.stolen, false);
        expect(vehicleMod.limit, null);
        expect(vehicleMod.capacity, null);
        expect(vehicleMod.extra, null);
        expect(vehicleMod.subsystems, null);
        expect(vehicleMod.weaponMountCategories, null);
        expect(vehicleMod.ammoReplace, null);
        expect(vehicleMod.weapons, isEmpty);
        expect(vehicleMod.notes, null);
        expect(vehicleMod.notesColor, null);
      });

      test('should parse complete XML correctly', () {
        // Arrange
        final xmlString = '''
          <vehiclemod>
            <sourceid>complete-source</sourceid>
            <guid>complete-guid</guid>
            <name>Complete Mod</name>
            <category>Sensor</category>
            <limit>Physical</limit>
            <slots>3</slots>
            <capacity>6</capacity>
            <rating>4</rating>
            <maxrating>6</maxrating>
            <ratinglabel>Rating</ratinglabel>
            <conditionmonitor>3</conditionmonitor>
            <avail>10F</avail>
            <cost>15000</cost>
            <markup>5</markup>
            <extra>Cybereyes</extra>
            <source>Chrome Flesh</source>
            <page>200</page>
            <included>True</included>
            <equipped>True</equipped>
            <wirelesson>True</wirelesson>
            <subsystems>Camera, Microphone</subsystems>
            <weaponmountcategories>Light Weapons</weaponmountcategories>
            <ammobonus>5</ammobonus>
            <ammobonuspercent>15</ammobonuspercent>
            <ammoreplace>APDS</ammoreplace>
            <weapons></weapons>
            <notes>Custom modification</notes>
            <notesColor>blue</notesColor>
            <discountedcost>True</discountedcost>
            <sortorder>3</sortorder>
            <stolen>True</stolen>
          </vehiclemod>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final vehicleMod = VehicleMod.fromXmlElement(xmlElement);

        // Assert
        expect(vehicleMod.sourceId, 'complete-source');
        expect(vehicleMod.guid, 'complete-guid');
        expect(vehicleMod.name, 'Complete Mod');
        expect(vehicleMod.category, 'Sensor');
        expect(vehicleMod.limit, 'Physical');
        expect(vehicleMod.slots, '3');
        expect(vehicleMod.capacity, '6');
        expect(vehicleMod.rating, '4');
        expect(vehicleMod.maxRating, '6');
        expect(vehicleMod.ratingLabel, 'Rating');
        expect(vehicleMod.conditionMonitor, '3');
        expect(vehicleMod.avail, '10F');
        expect(vehicleMod.cost, '15000');
        expect(vehicleMod.markup, '5');
        expect(vehicleMod.extra, 'Cybereyes');
        expect(vehicleMod.source, 'Chrome Flesh');
        expect(vehicleMod.page, '200');
        expect(vehicleMod.included, true);
        expect(vehicleMod.equipped, true);
        expect(vehicleMod.wirelessOn, true);
        expect(vehicleMod.subsystems, 'Camera, Microphone');
        expect(vehicleMod.weaponMountCategories, 'Light Weapons');
        expect(vehicleMod.ammoBonus, '5');
        expect(vehicleMod.ammoBonusPercent, '15');
        expect(vehicleMod.ammoReplace, 'APDS');
        expect(vehicleMod.weapons, isEmpty);
        expect(vehicleMod.notes, 'Custom modification');
        expect(vehicleMod.notesColor, 'blue');
        expect(vehicleMod.discountedCost, true);
        expect(vehicleMod.sortOrder, '3');
        expect(vehicleMod.stolen, true);
      });

      test('should handle missing XML elements gracefully', () {
        // Arrange
        final xmlString = '''
          <vehiclemod>
          </vehiclemod>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final vehicleMod = VehicleMod.fromXmlElement(xmlElement);

        // Assert
        expect(vehicleMod.sourceId, '');
        expect(vehicleMod.guid, '');
        expect(vehicleMod.name, '');
        expect(vehicleMod.category, '');
        expect(vehicleMod.slots, '');
        expect(vehicleMod.rating, '0');
        expect(vehicleMod.maxRating, '0');
        expect(vehicleMod.ratingLabel, '');
        expect(vehicleMod.conditionMonitor, '0');
        expect(vehicleMod.avail, '');
        expect(vehicleMod.cost, '');
        expect(vehicleMod.markup, '0');
        expect(vehicleMod.source, '');
        expect(vehicleMod.page, '');
        expect(vehicleMod.included, false);
        expect(vehicleMod.equipped, false);
        expect(vehicleMod.wirelessOn, false);
        expect(vehicleMod.ammoBonus, '0');
        expect(vehicleMod.ammoBonusPercent, '0');
        expect(vehicleMod.discountedCost, false);
        expect(vehicleMod.sortOrder, '0');
        expect(vehicleMod.stolen, false);
      });

      test('should parse boolean values correctly', () {
        // Arrange
        final xmlString = '''
          <vehiclemod>
            <sourceid>bool-test</sourceid>
            <guid>bool-guid</guid>
            <name>Boolean Test</name>
            <category>Test</category>
            <slots>1</slots>
            <rating>1</rating>
            <maxrating>1</maxrating>
            <ratinglabel>Test</ratinglabel>
            <conditionmonitor>1</conditionmonitor>
            <avail>1</avail>
            <cost>1</cost>
            <markup>1</markup>
            <source>Test</source>
            <page>1</page>
            <included>True</included>
            <equipped>False</equipped>
            <wirelesson>True</wirelesson>
            <ammobonus>1</ammobonus>
            <ammobonuspercent>1</ammobonuspercent>
            <discountedcost>True</discountedcost>
            <sortorder>1</sortorder>
            <stolen>False</stolen>
          </vehiclemod>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final vehicleMod = VehicleMod.fromXmlElement(xmlElement);

        // Assert
        expect(vehicleMod.included, true);
        expect(vehicleMod.equipped, false);
        expect(vehicleMod.wirelessOn, true);
        expect(vehicleMod.discountedCost, true);
        expect(vehicleMod.stolen, false);
      });

      test('should parse weapons correctly', () {
        // Arrange
        final xmlString = '''
          <vehiclemod>
            <sourceid>weapon-test</sourceid>
            <guid>weapon-guid</guid>
            <name>Weapon Mount</name>
            <category>Weapon</category>
            <slots>2</slots>
            <rating>1</rating>
            <maxrating>1</maxrating>
            <ratinglabel>Fixed</ratinglabel>
            <conditionmonitor>1</conditionmonitor>
            <avail>6R</avail>
            <cost>5000</cost>
            <markup>0</markup>
            <source>Core</source>
            <page>462</page>
            <included>False</included>
            <equipped>True</equipped>
            <wirelesson>False</wirelesson>
            <ammobonus>0</ammobonus>
            <ammobonuspercent>0</ammobonuspercent>
            <discountedcost>False</discountedcost>
            <sortorder>0</sortorder>
            <stolen>False</stolen>
            <weapons>
              <weapon>
                <name>Mounted Gun</name>
                <category>Assault Rifles</category>
                <type>Ranged</type>
                <damage>8P</damage>
                <ap>-2</ap>
                <mode>SA/BF/FA</mode>
                <ammo>30(c)</ammo>
                <firingmode>FA</firingmode>
                <accuracy>5</accuracy>
                <source>Core</source>
                <page>430</page>
                <avail>8F</avail>
              </weapon>
            </weapons>
          </vehiclemod>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final vehicleMod = VehicleMod.fromXmlElement(xmlElement);

        // Assert
        expect(vehicleMod.weapons, hasLength(1));
        expect(vehicleMod.weapons!.first.name, 'Mounted Gun');
        expect(vehicleMod.weapons!.first.category, 'Assault Rifles');
        expect(vehicleMod.weapons!.first.damage, '8P');
      });
    });
  });
}
