import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/vehicle_mod.dart';
import 'package:chummer5x/utils/xml_element_extensions.dart';

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
        cost: 5000,
        markup: '0',
        source: 'Core',
        page: '460',
        included: false,
        equipped: true,
        wirelessOn: false,
        ammoBonus: '0',
        ammoBonusPercent: '0',
        discountedCost: false,
        sortOrder: 0,
        stolen: false,
      );

      // Assert
      expect(vehicleMod.sourceId, 'test-source',
          reason: 'Source ID should match the value provided in constructor');
      expect(vehicleMod.guid, 'test-guid',
          reason: 'GUID should match the value provided in constructor');
      expect(vehicleMod.name, 'Armor Plating',
          reason: 'Name should match the value provided in constructor');
      expect(vehicleMod.category, 'Body',
          reason: 'Category should match the value provided in constructor');
      expect(vehicleMod.slots, '2',
          reason: 'Slots should match the value provided in constructor');
      expect(vehicleMod.rating, '3',
          reason: 'Rating should match the value provided in constructor');
      expect(vehicleMod.maxRating, '6',
          reason: 'Max rating should match the value provided in constructor');
      expect(vehicleMod.ratingLabel, 'Rating',
          reason:
              'Rating label should match the value provided in constructor');
      expect(vehicleMod.conditionMonitor, '2',
          reason:
              'Condition monitor should match the value provided in constructor');
      expect(vehicleMod.avail, '8R',
          reason:
              'Availability should match the value provided in constructor');
      expect(vehicleMod.cost, 5000,
          reason: 'Cost should match the value provided in constructor');
      expect(vehicleMod.markup, '0',
          reason: 'Markup should match the value provided in constructor');
      expect(vehicleMod.source, 'Core',
          reason: 'Source should match the value provided in constructor');
      expect(vehicleMod.page, '460',
          reason: 'Page should match the value provided in constructor');
      expect(vehicleMod.included, false,
          reason:
              'Included status should match the value provided in constructor');
      expect(vehicleMod.equipped, true,
          reason:
              'Equipped status should match the value provided in constructor');
      expect(vehicleMod.wirelessOn, false,
          reason:
              'Wireless status should match the value provided in constructor');
      expect(vehicleMod.ammoBonus, '0',
          reason: 'Ammo bonus should match the value provided in constructor');
      expect(vehicleMod.ammoBonusPercent, '0',
          reason:
              'Ammo bonus percent should match the value provided in constructor');
      expect(vehicleMod.discountedCost, false,
          reason:
              'Discounted cost should match the value provided in constructor');
      expect(vehicleMod.sortOrder, 0,
          reason: 'Sort order should match the value provided in constructor');
      expect(vehicleMod.stolen, false,
          reason:
              'Stolen status should match the value provided in constructor');

      // Check optional defaults
      expect(vehicleMod.limit, null,
          reason: 'Limit should be null when not provided in constructor');
      expect(vehicleMod.capacity, null,
          reason: 'Capacity should be null when not provided in constructor');
      expect(vehicleMod.extra, null,
          reason: 'Extra should be null when not provided in constructor');
      expect(vehicleMod.subsystems, null,
          reason: 'Subsystems should be null when not provided in constructor');
      expect(vehicleMod.weaponMountCategories, null,
          reason:
              'Weapon mount categories should be null when not provided in constructor');
      expect(vehicleMod.ammoReplace, null,
          reason:
              'Ammo replace should be null when not provided in constructor');
      expect(vehicleMod.weapons, null,
          reason: 'Weapons should be null when not provided in constructor');
      expect(vehicleMod.notes, null,
          reason: 'Notes should be null when not provided in constructor');
      expect(vehicleMod.notesColor, null,
          reason:
              'Notes color should be null when not provided in constructor');
    });

    test(
        'XmlElement.parseList parses multiple VehicleMod items from <vehiclemods>',
        () {
      // Arrange
      final xmlString = '''
        <root>
          <vehiclemods>
            <vehiclemod>
              <name>Mod One</name>
              <category>Body</category>
              <slots>2</slots>
              <rating>3</rating>
              <maxrating>6</maxrating>
              <ratinglabel>Rating</ratinglabel>
              <conditionmonitor>2</conditionmonitor>
              <avail>8R</avail>
              <cost>5000</cost>
              <markup>0</markup>
              <source>Core</source>
              <page>460</page>
            </vehiclemod>
            <vehiclemod>
              <name>Mod Two</name>
              <category>Body</category>
              <slots>3</slots>
              <rating>4</rating>
              <maxrating>8</maxrating>
              <ratinglabel>Rating</ratinglabel>
              <conditionmonitor>3</conditionmonitor>
              <avail>10F</avail>
              <cost>7000</cost>
              <markup>1</markup>
              <source>Run & Gun</source>
              <page>470</page>
            </vehiclemod>
          </vehiclemods>
        </root>
      ''';
      final document = XmlDocument.parse(xmlString);
      final root = document.rootElement;

      // Act
      final mods = root.parseList<VehicleMod>(
        collectionTagName: 'vehiclemods',
        itemTagName: 'vehiclemod',
        fromXml: VehicleMod.fromXml,
      );

      // Assert
      expect(mods, hasLength(2),
          reason: 'Should parse two VehicleMod items from <vehiclemods>');
      expect(mods[0].name, 'Mod One',
          reason: 'First mod name should be Mod One');
      expect(mods[1].name, 'Mod Two',
          reason: 'Second mod name should be Mod Two');
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
        cost: 25000,
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
        sortOrder: 5,
        stolen: true,
      );

      // Assert
      expect(vehicleMod.sourceId, 'advanced-source',
          reason: 'Source ID should match the value provided in constructor');
      expect(vehicleMod.guid, 'advanced-guid',
          reason: 'GUID should match the value provided in constructor');
      expect(vehicleMod.name, 'Advanced Sensor Array',
          reason: 'Name should match the value provided in constructor');
      expect(vehicleMod.category, 'Sensor',
          reason: 'Category should match the value provided in constructor');
      expect(vehicleMod.limit, 'Physical',
          reason: 'Limit should match the value provided in constructor');
      expect(vehicleMod.slots, '4',
          reason: 'Slots should match the value provided in constructor');
      expect(vehicleMod.capacity, '8',
          reason: 'Capacity should match the value provided in constructor');
      expect(vehicleMod.rating, '5',
          reason: 'Rating should match the value provided in constructor');
      expect(vehicleMod.maxRating, '6',
          reason: 'Max rating should match the value provided in constructor');
      expect(vehicleMod.ratingLabel, 'Rating',
          reason:
              'Rating label should match the value provided in constructor');
      expect(vehicleMod.conditionMonitor, '4',
          reason:
              'Condition monitor should match the value provided in constructor');
      expect(vehicleMod.avail, '12F',
          reason:
              'Availability should match the value provided in constructor');
      expect(vehicleMod.cost, 25000,
          reason: 'Cost should match the value provided in constructor');
      expect(vehicleMod.markup, '10',
          reason: 'Markup should match the value provided in constructor');
      expect(vehicleMod.extra, 'Cybereyes',
          reason: 'Extra should match the value provided in constructor');
      expect(vehicleMod.source, 'Run & Gun',
          reason: 'Source should match the value provided in constructor');
      expect(vehicleMod.page, '123',
          reason: 'Page should match the value provided in constructor');
      expect(vehicleMod.included, true,
          reason:
              'Included status should match the value provided in constructor');
      expect(vehicleMod.equipped, true,
          reason:
              'Equipped status should match the value provided in constructor');
      expect(vehicleMod.wirelessOn, true,
          reason:
              'Wireless status should match the value provided in constructor');
      expect(vehicleMod.subsystems, 'Camera, Microphone',
          reason: 'Subsystems should match the value provided in constructor');
      expect(vehicleMod.weaponMountCategories, 'Light Weapons',
          reason:
              'Weapon mount categories should match the value provided in constructor');
      expect(vehicleMod.ammoBonus, '10',
          reason: 'Ammo bonus should match the value provided in constructor');
      expect(vehicleMod.ammoBonusPercent, '25',
          reason:
              'Ammo bonus percent should match the value provided in constructor');
      expect(vehicleMod.ammoReplace, 'APDS',
          reason:
              'Ammo replace should match the value provided in constructor');
      expect(vehicleMod.weapons, isEmpty,
          reason: 'Weapons should be empty list as provided in constructor');
      expect(vehicleMod.notes, 'Advanced modification',
          reason: 'Notes should match the value provided in constructor');
      expect(vehicleMod.notesColor, 'green',
          reason: 'Notes color should match the value provided in constructor');
      expect(vehicleMod.discountedCost, true,
          reason:
              'Discounted cost should match the value provided in constructor');
      expect(vehicleMod.sortOrder, 5,
          reason: 'Sort order should match the value provided in constructor');
      expect(vehicleMod.stolen, true,
          reason:
              'Stolen status should match the value provided in constructor');
    });

    group('fromXml', () {
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
        final vehicleMod = VehicleMod.fromXml(xmlElement);

        // Assert
        expect(vehicleMod.sourceId, 'basic-source',
            reason: 'Source ID should be parsed from XML sourceid element');
        expect(vehicleMod.guid, 'basic-guid',
            reason: 'GUID should be parsed from XML guid element');
        expect(vehicleMod.name, 'Basic Mod',
            reason: 'Name should be parsed from XML name element');
        expect(vehicleMod.category, 'Body',
            reason: 'Category should be parsed from XML category element');
        expect(vehicleMod.slots, '1',
            reason: 'Slots should be parsed from XML slots element');
        expect(vehicleMod.rating, '2',
            reason: 'Rating should be parsed from XML rating element');
        expect(vehicleMod.maxRating, '4',
            reason: 'Max rating should be parsed from XML maxrating element');
        expect(vehicleMod.ratingLabel, 'Rating',
            reason:
                'Rating label should be parsed from XML ratinglabel element');
        expect(vehicleMod.conditionMonitor, '1',
            reason:
                'Condition monitor should be parsed from XML conditionmonitor element');
        expect(vehicleMod.avail, '4R',
            reason: 'Availability should be parsed from XML avail element');
        expect(vehicleMod.cost, 2000,
            reason: 'Cost should be parsed from XML cost element');
        expect(vehicleMod.markup, '0',
            reason: 'Markup should be parsed from XML markup element');
        expect(vehicleMod.source, 'Core',
            reason: 'Source should be parsed from XML source element');
        expect(vehicleMod.page, '450',
            reason: 'Page should be parsed from XML page element');
        expect(vehicleMod.included, false,
            reason:
                'Included should be parsed as false from XML included element value "False"');
        expect(vehicleMod.equipped, true,
            reason:
                'Equipped should be parsed as true from XML equipped element value "True"');
        expect(vehicleMod.wirelessOn, false,
            reason:
                'Wireless on should be parsed as false from XML wirelesson element value "False"');
        expect(vehicleMod.ammoBonus, '0',
            reason: 'Ammo bonus should be parsed from XML ammobonus element');
        expect(vehicleMod.ammoBonusPercent, '0',
            reason:
                'Ammo bonus percent should be parsed from XML ammobonuspercent element');
        expect(vehicleMod.discountedCost, false,
            reason:
                'Discounted cost should be parsed as false from XML discountedcost element value "False"');
        expect(vehicleMod.sortOrder, 0,
            reason: 'Sort order should be parsed from XML sortorder element');
        expect(vehicleMod.stolen, false,
            reason:
                'Stolen should be parsed as false from XML stolen element value "False"');
        expect(vehicleMod.limit, null,
            reason: 'Limit should be null when XML limit element is missing');
        expect(vehicleMod.capacity, null,
            reason:
                'Capacity should be null when XML capacity element is missing');
        expect(vehicleMod.extra, null,
            reason: 'Extra should be null when XML extra element is missing');
        expect(vehicleMod.subsystems, null,
            reason:
                'Subsystems should be null when XML subsystems element is missing');
        expect(vehicleMod.weaponMountCategories, null,
            reason:
                'Weapon mount categories should be null when XML weaponmountcategories element is missing');
        expect(vehicleMod.ammoReplace, null,
            reason:
                'Ammo replace should be null when XML ammoreplace element is missing');
        expect(vehicleMod.weapons, isEmpty,
            reason:
                'Weapons should be empty when XML weapons element is missing');
        expect(vehicleMod.notes, null,
            reason: 'Notes should be null when XML notes element is missing');
        expect(vehicleMod.notesColor, null,
            reason:
                'Notes color should be null when XML notesColor element is missing');
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
        final vehicleMod = VehicleMod.fromXml(xmlElement);

        // Assert
        expect(vehicleMod.sourceId, 'complete-source',
            reason: 'Source ID should be parsed from XML sourceid element');
        expect(vehicleMod.guid, 'complete-guid',
            reason: 'GUID should be parsed from XML guid element');
        expect(vehicleMod.name, 'Complete Mod',
            reason: 'Name should be parsed from XML name element');
        expect(vehicleMod.category, 'Sensor',
            reason: 'Category should be parsed from XML category element');
        expect(vehicleMod.limit, 'Physical',
            reason: 'Limit should be parsed from XML limit element');
        expect(vehicleMod.slots, '3',
            reason: 'Slots should be parsed from XML slots element');
        expect(vehicleMod.capacity, '6',
            reason: 'Capacity should be parsed from XML capacity element');
        expect(vehicleMod.rating, '4',
            reason: 'Rating should be parsed from XML rating element');
        expect(vehicleMod.maxRating, '6',
            reason: 'Max rating should be parsed from XML maxrating element');
        expect(vehicleMod.ratingLabel, 'Rating',
            reason:
                'Rating label should be parsed from XML ratinglabel element');
        expect(vehicleMod.conditionMonitor, '3',
            reason:
                'Condition monitor should be parsed from XML conditionmonitor element');
        expect(vehicleMod.avail, '10F',
            reason: 'Availability should be parsed from XML avail element');
        expect(vehicleMod.cost, 15000,
            reason: 'Cost should be parsed from XML cost element');
        expect(vehicleMod.markup, '5',
            reason: 'Markup should be parsed from XML markup element');
        expect(vehicleMod.extra, 'Cybereyes',
            reason: 'Extra should be parsed from XML extra element');
        expect(vehicleMod.source, 'Chrome Flesh',
            reason: 'Source should be parsed from XML source element');
        expect(vehicleMod.page, '200',
            reason: 'Page should be parsed from XML page element');
        expect(vehicleMod.included, true,
            reason:
                'Included should be parsed as true from XML included element value "True"');
        expect(vehicleMod.equipped, true,
            reason:
                'Equipped should be parsed as true from XML equipped element value "True"');
        expect(vehicleMod.wirelessOn, true,
            reason:
                'Wireless on should be parsed as true from XML wirelesson element value "True"');
        expect(vehicleMod.subsystems, 'Camera, Microphone',
            reason: 'Subsystems should be parsed from XML subsystems element');
        expect(vehicleMod.weaponMountCategories, 'Light Weapons',
            reason:
                'Weapon mount categories should be parsed from XML weaponmountcategories element');
        expect(vehicleMod.ammoBonus, '5',
            reason: 'Ammo bonus should be parsed from XML ammobonus element');
        expect(vehicleMod.ammoBonusPercent, '15',
            reason:
                'Ammo bonus percent should be parsed from XML ammobonuspercent element');
        expect(vehicleMod.ammoReplace, 'APDS',
            reason:
                'Ammo replace should be parsed from XML ammoreplace element');
        expect(vehicleMod.weapons, isEmpty,
            reason:
                'Weapons should be empty when XML weapons element is empty');
        expect(vehicleMod.notes, 'Custom modification',
            reason: 'Notes should be parsed from XML notes element');
        expect(vehicleMod.notesColor, 'blue',
            reason: 'Notes color should be parsed from XML notesColor element');
        expect(vehicleMod.discountedCost, true,
            reason:
                'Discounted cost should be parsed as true from XML discountedcost element value "True"');
        expect(vehicleMod.sortOrder, 3,
            reason: 'Sort order should be parsed from XML sortorder element');
        expect(vehicleMod.stolen, true,
            reason:
                'Stolen should be parsed as true from XML stolen element value "True"');
      });

      test('should handle missing XML elements gracefully', () {
        // Arrange
        final xmlString = '''
          <vehiclemod>
          </vehiclemod>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final vehicleMod = VehicleMod.fromXml(xmlElement);

        // Assert
        expect(vehicleMod.sourceId, '',
            reason:
                'Source ID should default to empty string when XML sourceid element is missing');
        expect(vehicleMod.guid, '',
            reason:
                'GUID should default to empty string when XML guid element is missing');
        expect(vehicleMod.name, '',
            reason:
                'Name should default to empty string when XML name element is missing');
        expect(vehicleMod.category, '',
            reason:
                'Category should default to empty string when XML category element is missing');
        expect(vehicleMod.slots, '',
            reason:
                'Slots should default to empty string when XML slots element is missing');
        expect(vehicleMod.rating, '0',
            reason:
                'Rating should default to "0" when XML rating element is missing');
        expect(vehicleMod.maxRating, '0',
            reason:
                'Max rating should default to "0" when XML maxrating element is missing');
        expect(vehicleMod.ratingLabel, '',
            reason:
                'Rating label should default to empty string when XML ratinglabel element is missing');
        expect(vehicleMod.conditionMonitor, '0',
            reason:
                'Condition monitor should default to "0" when XML conditionmonitor element is missing');
        expect(vehicleMod.avail, '',
            reason:
                'Availability should default to empty string when XML avail element is missing');
        expect(vehicleMod.cost, 0,
            reason:
                'Cost should default to 0 when XML cost element is missing');
        expect(vehicleMod.markup, '0',
            reason:
                'Markup should default to "0" when XML markup element is missing');
        expect(vehicleMod.source, '',
            reason:
                'Source should default to empty string when XML source element is missing');
        expect(vehicleMod.page, '',
            reason:
                'Page should default to empty string when XML page element is missing');
        expect(vehicleMod.included, false,
            reason:
                'Included should default to false when XML included element is missing');
        expect(vehicleMod.equipped, false,
            reason:
                'Equipped should default to false when XML equipped element is missing');
        expect(vehicleMod.wirelessOn, false,
            reason:
                'Wireless on should default to false when XML wirelesson element is missing');
        expect(vehicleMod.ammoBonus, '0',
            reason:
                'Ammo bonus should default to "0" when XML ammobonus element is missing');
        expect(vehicleMod.ammoBonusPercent, '0',
            reason:
                'Ammo bonus percent should default to "0" when XML ammobonuspercent element is missing');
        expect(vehicleMod.discountedCost, false,
            reason:
                'Discounted cost should default to false when XML discountedcost element is missing');
        expect(vehicleMod.sortOrder, 0,
            reason:
                'Sort order should default to 0 when XML sortorder element is missing');
        expect(vehicleMod.stolen, false,
            reason:
                'Stolen should default to false when XML stolen element is missing');
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
        final vehicleMod = VehicleMod.fromXml(xmlElement);

        // Assert
        expect(vehicleMod.included, true,
            reason:
                'Included should be parsed as true from XML included element value "True"');
        expect(vehicleMod.equipped, false,
            reason:
                'Equipped should be parsed as false from XML equipped element value "False"');
        expect(vehicleMod.wirelessOn, true,
            reason:
                'Wireless on should be parsed as true from XML wirelesson element value "True"');
        expect(vehicleMod.discountedCost, true,
            reason:
                'Discounted cost should be parsed as true from XML discountedcost element value "True"');
        expect(vehicleMod.stolen, false,
            reason:
                'Stolen should be parsed as false from XML stolen element value "False"');
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
        final vehicleMod = VehicleMod.fromXml(xmlElement);

        // Assert
        expect(vehicleMod.weapons, hasLength(1),
            reason:
                'Weapons should contain exactly one weapon parsed from XML');
        expect(vehicleMod.weapons!.first.name, 'Mounted Gun',
            reason:
                'First weapon name should be parsed from XML weapon element');
        expect(vehicleMod.weapons!.first.category, 'Assault Rifles',
            reason:
                'First weapon category should be parsed from XML weapon element');
        expect(vehicleMod.weapons!.first.damage, '8P',
            reason:
                'First weapon damage should be parsed from XML weapon element');
      });
    });
  });
}
