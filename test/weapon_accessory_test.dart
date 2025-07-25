import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/weapon_accessory.dart';

void main() {
  group('WeaponAccessory', () {
    test('should create WeaponAccessory with required parameters', () {
      // Test: Verify WeaponAccessory constructor works with minimal required fields and sets default values correctly
      // Arrange & Act
      final accessory = WeaponAccessory(
        name: 'Smartgun System',
        category: 'Weapon Accessory',
        mount: 'Internal',
        extraMount: 'None',
        avail: '8R',
        cost: 2000,
        source: 'Core',
        page: '431',
        equipped: false,
        discountedCost: false,
        wirelessOn: false,
        stolen: false,
        sortOrder: 0,
      );

      // Assert
      expect(accessory.name, 'Smartgun System', reason: 'Name should match constructor input');
      expect(accessory.mount, 'Internal', reason: 'Mount should match constructor input');
      expect(accessory.extraMount, 'None', reason: 'ExtraMount should match constructor input');
      expect(accessory.avail, '8R', reason: 'Avail should match constructor input');
      expect(accessory.cost, 2000, reason: 'Cost should match constructor input');
      expect(accessory.source, 'Core', reason: 'Source should match constructor input');
      expect(accessory.page, '431', reason: 'Page should match constructor input');
      
      // Check defaults
      expect(accessory.sourceId, null, reason: 'SourceId should default to null when not provided');
      expect(accessory.guid, null, reason: 'GUID should default to null when not provided');
      expect(accessory.rc, null, reason: 'RC should default to null when not provided');
      expect(accessory.maxRating, 0, reason: 'MaxRating should default to 0 when not provided');
      expect(accessory.rating, 0, reason: 'Rating should default to 0 when not provided');
      expect(accessory.ratingLabel, 'String_Rating', reason: 'RatingLabel should default to String_Rating when not provided');
      expect(accessory.rcGroup, 0, reason: 'RcGroup should default to 0 when not provided');
      expect(accessory.rcDeployable, false, reason: 'RcDeployable should default to false when not provided');
      expect(accessory.specialModification, false, reason: 'SpecialModification should default to false when not provided');
      expect(accessory.conceal, null, reason: 'Conceal should default to null when not provided');
      expect(accessory.weight, null, reason: 'Weight should default to null when not provided');
      expect(accessory.included, false, reason: 'Included should default to false when not provided');
      expect(accessory.equipped, false, reason: 'Equipped should match constructor input');
      expect(accessory.accuracy, null, reason: 'Accuracy should default to null when not provided');
      expect(accessory.gears, null, reason: 'Gears should default to null when not provided');
      expect(accessory.ammoReplace, null, reason: 'AmmoReplace should default to null when not provided');
      expect(accessory.ammoSlots, 0, reason: 'AmmoSlots should default to 0 when not provided');
      expect(accessory.modifyAmmoCapacity, null, reason: 'ModifyAmmoCapacity should default to null when not provided');
      expect(accessory.damageType, null, reason: 'DamageType should default to null when not provided');
      expect(accessory.damage, null, reason: 'Damage should default to null when not provided');
      expect(accessory.reach, null, reason: 'Reach should default to null when not provided');
      expect(accessory.damageReplace, null, reason: 'DamageReplace should default to null when not provided');
      expect(accessory.fireMode, null, reason: 'FireMode should default to null when not provided');
      expect(accessory.fireModeReplace, null, reason: 'FireModeReplace should default to null when not provided');
      expect(accessory.ap, null, reason: 'AP should default to null when not provided');
      expect(accessory.apReplace, null, reason: 'APReplace should default to null when not provided');
      expect(accessory.notes, null, reason: 'Notes should default to null when not provided');
      expect(accessory.notesColor, null, reason: 'NotesColor should default to null when not provided');
      expect(accessory.discountedCost, false, reason: 'DiscountedCost should match constructor input');
      expect(accessory.singleShot, 0, reason: 'SingleShot should default to 0 when not provided');
      expect(accessory.shortBurst, 0, reason: 'ShortBurst should default to 0 when not provided');
      expect(accessory.longBurst, 0, reason: 'LongBurst should default to 0 when not provided');
      expect(accessory.fullBurst, 0, reason: 'FullBurst should default to 0 when not provided');
      expect(accessory.suppressive, 0, reason: 'Suppressive should default to 0 when not provided');
      expect(accessory.rangeBonus, 0, reason: 'RangeBonus should default to 0 when not provided');
      expect(accessory.rangeModifier, 0, reason: 'RangeModifier should default to 0 when not provided');
      expect(accessory.extra, null, reason: 'Extra should default to null when not provided');
      expect(accessory.ammoBonus, null, reason: 'AmmoBonus should default to null when not provided');
      expect(accessory.wirelessOn, false, reason: 'WirelessOn should match constructor input');
      expect(accessory.stolen, false, reason: 'Stolen should match constructor input');
      expect(accessory.sortOrder, 0, reason: 'SortOrder should match constructor input');
      expect(accessory.parentId, null, reason: 'ParentId should default to null when not provided');
    });

    test('should create WeaponAccessory with all optional parameters', () {
      // Test: Verify WeaponAccessory constructor accepts and correctly stores all optional parameters
      // Arrange & Act
      final accessory = WeaponAccessory(
        name: 'Advanced Scope',
        category: 'Weapon Accessory',
        mount: 'Top',
        extraMount: 'Barrel',
        rc: '2',
        maxRating: 6,
        rating: 4,
        ratingLabel: 'Rating',
        rcGroup: 3,
        rcDeployable: true,
        specialModification: true,
        conceal: '+2',
        avail: '12F',
        cost: 15000,
        weight: '1.5',
        included: true,
        equipped: true,
        source: 'Run & Gun',
        page: '200',
        accuracy: '+1',
        gears: [],
        ammoReplace: 'APDS',
        ammoSlots: 2,
        modifyAmmoCapacity: '+10',
        damageType: 'Physical',
        damage: '+2P',
        reach: '+1',
        damageReplace: '10P',
        fireMode: 'SA',
        fireModeReplace: 'BF',
        ap: '-1',
        apReplace: '-3',
        notes: 'Custom accessory',
        notesColor: 'red',
        discountedCost: true,
        singleShot: 1,
        shortBurst: 3,
        longBurst: 6,
        fullBurst: 10,
        suppressive: 20,
        rangeBonus: 50,
        rangeModifier: 2,
        extra: 'Thermographic',
        ammoBonus: '10',
        wirelessOn: true,
        stolen: true,
        sortOrder: 5,
        parentId: 'parent-123',
      );

      // Assert
      expect(accessory.name, 'Advanced Scope', reason: 'Name should match constructor input');
      expect(accessory.mount, 'Top', reason: 'Mount should match constructor input');
      expect(accessory.extraMount, 'Barrel', reason: 'ExtraMount should match constructor input');
      expect(accessory.rc, '2', reason: 'RC should match constructor input');
      expect(accessory.maxRating, 6, reason: 'MaxRating should match constructor input');
      expect(accessory.rating, 4, reason: 'Rating should match constructor input');
      expect(accessory.ratingLabel, 'Rating', reason: 'RatingLabel should match constructor input');
      expect(accessory.rcGroup, 3, reason: 'RcGroup should match constructor input');
      expect(accessory.rcDeployable, true, reason: 'RcDeployable should match constructor input');
      expect(accessory.specialModification, true, reason: 'SpecialModification should match constructor input');
      expect(accessory.conceal, '+2', reason: 'Conceal should match constructor input');
      expect(accessory.avail, '12F', reason: 'Avail should match constructor input');
      expect(accessory.cost, 15000, reason: 'Cost should match constructor input');
      expect(accessory.weight, '1.5', reason: 'Weight should match constructor input');
      expect(accessory.included, true, reason: 'Included should match constructor input');
      expect(accessory.equipped, true, reason: 'Equipped should match constructor input');
      expect(accessory.source, 'Run & Gun', reason: 'Source should match constructor input');
      expect(accessory.page, '200', reason: 'Page should match constructor input');
      expect(accessory.accuracy, '+1', reason: 'Accuracy should match constructor input');
      expect(accessory.gears, isEmpty, reason: 'Gears should match constructor input (empty list)');
      expect(accessory.ammoReplace, 'APDS', reason: 'AmmoReplace should match constructor input');
      expect(accessory.ammoSlots, 2, reason: 'AmmoSlots should match constructor input');
      expect(accessory.modifyAmmoCapacity, '+10', reason: 'ModifyAmmoCapacity should match constructor input');
      expect(accessory.damageType, 'Physical', reason: 'DamageType should match constructor input');
      expect(accessory.damage, '+2P', reason: 'Damage should match constructor input');
      expect(accessory.reach, '+1', reason: 'Reach should match constructor input');
      expect(accessory.damageReplace, '10P', reason: 'DamageReplace should match constructor input');
      expect(accessory.fireMode, 'SA', reason: 'FireMode should match constructor input');
      expect(accessory.fireModeReplace, 'BF', reason: 'FireModeReplace should match constructor input');
      expect(accessory.ap, '-1', reason: 'AP should match constructor input');
      expect(accessory.apReplace, '-3', reason: 'APReplace should match constructor input');
      expect(accessory.notes, 'Custom accessory', reason: 'Notes should match constructor input');
      expect(accessory.notesColor, 'red', reason: 'NotesColor should match constructor input');
      expect(accessory.discountedCost, true, reason: 'DiscountedCost should match constructor input');
      expect(accessory.singleShot, 1, reason: 'SingleShot should match constructor input');
      expect(accessory.shortBurst, 3, reason: 'ShortBurst should match constructor input');
      expect(accessory.longBurst, 6, reason: 'LongBurst should match constructor input');
      expect(accessory.fullBurst, 10, reason: 'FullBurst should match constructor input');
      expect(accessory.suppressive, 20, reason: 'Suppressive should match constructor input');
      expect(accessory.rangeBonus, 50, reason: 'RangeBonus should match constructor input');
      expect(accessory.rangeModifier, 2, reason: 'RangeModifier should match constructor input');
      expect(accessory.extra, 'Thermographic', reason: 'Extra should match constructor input');
      expect(accessory.ammoBonus, '10', reason: 'AmmoBonus should match constructor input');
      expect(accessory.wirelessOn, true, reason: 'WirelessOn should match constructor input');
      expect(accessory.stolen, true, reason: 'Stolen should match constructor input');
      expect(accessory.sortOrder, 5, reason: 'SortOrder should match constructor input');
      expect(accessory.parentId, 'parent-123', reason: 'ParentId should match constructor input');
    });

    group('fromXml', () {
      test('should parse minimal XML correctly', () {
        // Test: Verify fromXml can parse basic XML with minimal required fields and sets appropriate defaults
        // Arrange
        final xmlString = '''
          <accessory>
            <name>Basic Scope</name>
            <mount>Top</mount>
            <extramount>None</extramount>
            <avail>4R</avail>
            <cost>500</cost>
            <source>Core</source>
            <page>431</page>
          </accessory>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final accessory = WeaponAccessory.fromXml(xmlElement);

        // Assert
        expect(accessory.name, 'Basic Scope', reason: 'Name should be parsed from XML <name> element');
        expect(accessory.mount, 'Top', reason: 'Mount should be parsed from XML <mount> element');
        expect(accessory.extraMount, 'None', reason: 'ExtraMount should be parsed from XML <extramount> element');
        expect(accessory.avail, '4R', reason: 'Avail should be parsed from XML <avail> element');
        expect(accessory.cost, 500, reason: 'Cost should be parsed from XML <cost> element as integer');
        expect(accessory.source, 'Core', reason: 'Source should be parsed from XML <source> element');
        expect(accessory.page, '431', reason: 'Page should be parsed from XML <page> element');
        expect(accessory.sourceId, null, reason: 'SourceId should default to null when not in XML');
        expect(accessory.guid, null, reason: 'GUID should default to null when not in XML');
        expect(accessory.rc, null, reason: 'RC should default to null when not in XML');
        expect(accessory.maxRating, 0, reason: 'MaxRating should default to 0 when not in XML');
        expect(accessory.rating, 0, reason: 'Rating should default to 0 when not in XML');
        expect(accessory.ratingLabel, 'String_Rating', reason: 'RatingLabel should default to String_Rating when not in XML');
        expect(accessory.rcGroup, 0, reason: 'RcGroup should default to 0 when not in XML');
        expect(accessory.rcDeployable, false, reason: 'RcDeployable should default to false when not in XML');
        expect(accessory.specialModification, false, reason: 'SpecialModification should default to false when not in XML');
        expect(accessory.conceal, null, reason: 'Conceal should default to null when not in XML');
        expect(accessory.weight, null, reason: 'Weight should default to null when not in XML');
        expect(accessory.included, false, reason: 'Included should default to false when not in XML');
        expect(accessory.equipped, false, reason: 'Equipped should default to false when not in XML');
        expect(accessory.accuracy, null, reason: 'Accuracy should default to null when not in XML');
        expect(accessory.gears, isEmpty, reason: 'Gears should default to empty list when not in XML');
        expect(accessory.discountedCost, false, reason: 'DiscountedCost should default to false when not in XML');
        expect(accessory.wirelessOn, false, reason: 'WirelessOn should default to false when not in XML');
        expect(accessory.stolen, false, reason: 'Stolen should default to false when not in XML');
        expect(accessory.sortOrder, 0, reason: 'SortOrder should default to 0 when not in XML');
      });

      test('should parse complete XML correctly', () {
        // Test: Verify fromXml can parse complex XML with all possible fields
        // Arrange
        final xmlString = '''
          <accessory>
            <sourceid>complete-source</sourceid>
            <guid>complete-guid</guid>
            <name>Complete Accessory</name>
            <mount>Internal</mount>
            <extramount>Barrel</extramount>
            <rc>3</rc>
            <maxrating>8</maxrating>
            <rating>5</rating>
            <ratinglabel>Rating</ratinglabel>
            <rcgroup>2</rcgroup>
            <rcdeployable>True</rcdeployable>
            <specialmodification>True</specialmodification>
            <conceal>+3</conceal>
            <avail>15F</avail>
            <cost>25000</cost>
            <weight>2.0</weight>
            <included>True</included>
            <equipped>True</equipped>
            <source>Chrome Flesh</source>
            <page>300</page>
            <accuracy>+2</accuracy>
            <gears></gears>
            <ammoreplace>Gel</ammoreplace>
            <ammoslots>3</ammoslots>
            <modifyammocapacity>+15</modifyammocapacity>
            <damagetype>Stun</damagetype>
            <damage>+3S</damage>
            <reach>+2</reach>
            <damagereplace>12S</damagereplace>
            <firemode>BF</firemode>
            <firemodereplace>FA</firemodereplace>
            <ap>-2</ap>
            <apreplace>-4</apreplace>
            <notes>Ultimate accessory</notes>
            <notesColor>green</notesColor>
            <discountedcost>True</discountedcost>
            <singleshot>2</singleshot>
            <shortburst>4</shortburst>
            <longburst>8</longburst>
            <fullburst>15</fullburst>
            <suppressive>25</suppressive>
            <rangebonus>100</rangebonus>
            <rangemodifier>3</rangemodifier>
            <extra>Low-Light</extra>
            <ammobonus>20</ammobonus>
            <wirelesson>True</wirelesson>
            <stolen>True</stolen>
            <sortorder>7</sortorder>
            <parentid>parent-456</parentid>
          </accessory>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final accessory = WeaponAccessory.fromXml(xmlElement);

        // Assert
        expect(accessory.name, 'Complete Accessory');
        expect(accessory.mount, 'Internal');
        expect(accessory.extraMount, 'Barrel');
        expect(accessory.rc, '3');
        expect(accessory.maxRating, 8);
        expect(accessory.rating, 5);
        expect(accessory.ratingLabel, 'Rating');
        expect(accessory.rcGroup, 2);
        expect(accessory.rcDeployable, true);
        expect(accessory.specialModification, true);
        expect(accessory.conceal, '+3');
        expect(accessory.avail, '15F');
        expect(accessory.cost, 25000, reason: 'Cost should be parsed from XML <cost> element as integer');
        expect(accessory.weight, '2.0');
        expect(accessory.included, true);
        expect(accessory.equipped, true);
        expect(accessory.source, 'Chrome Flesh');
        expect(accessory.page, '300');
        expect(accessory.accuracy, '+2');
        expect(accessory.gears, isEmpty);
        expect(accessory.ammoReplace, 'Gel');
        expect(accessory.ammoSlots, 3);
        expect(accessory.modifyAmmoCapacity, '+15');
        expect(accessory.damageType, 'Stun');
        expect(accessory.damage, '+3S');
        expect(accessory.reach, '+2');
        expect(accessory.damageReplace, '12S');
        expect(accessory.fireMode, 'BF');
        expect(accessory.fireModeReplace, 'FA');
        expect(accessory.ap, '-2');
        expect(accessory.apReplace, '-4');
        expect(accessory.notes, 'Ultimate accessory');
        expect(accessory.notesColor, 'green');
        expect(accessory.discountedCost, true);
        expect(accessory.singleShot, 2);
        expect(accessory.shortBurst, 4);
        expect(accessory.longBurst, 8);
        expect(accessory.fullBurst, 15);
        expect(accessory.suppressive, 25);
        expect(accessory.rangeBonus, 100);
        expect(accessory.rangeModifier, 3);
        expect(accessory.extra, 'Low-Light');
        expect(accessory.ammoBonus, '20');
        expect(accessory.wirelessOn, true);
        expect(accessory.stolen, true);
        expect(accessory.sortOrder, 7);
        expect(accessory.parentId, 'parent-456');
      });

      test('should handle missing XML elements gracefully', () {
        // Test: Verify fromXml provides appropriate defaults when XML elements are missing
        // Arrange
        final xmlString = '''
          <accessory>
          </accessory>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final accessory = WeaponAccessory.fromXml(xmlElement);

        // Assert
        expect(accessory.name, 'Unnamed Accessory', reason: 'Missing name should default to "Unnamed Accessory"');
        expect(accessory.mount, 'None', reason: 'Missing mount should default to "None"');
        expect(accessory.extraMount, 'None', reason: 'Missing extramount should default to "None"');
        expect(accessory.avail, '', reason: 'Missing avail should default to empty string');
        expect(accessory.cost, 0, reason: 'Missing cost should default to 0');
        expect(accessory.source, 'Unknown', reason: 'Missing source should default to "Unknown"');
        expect(accessory.page, '0', reason: 'Missing page should default to "0"');
        expect(accessory.ratingLabel, 'String_Rating', reason: 'Missing ratinglabel should default to "String_Rating"');
        expect(accessory.maxRating, 0, reason: 'Missing maxrating should default to 0');
        expect(accessory.rating, 0, reason: 'Missing rating should default to 0');
        expect(accessory.rcGroup, 0, reason: 'Missing rcgroup should default to 0');
        expect(accessory.rcDeployable, false, reason: 'Missing rcdeployable should default to false');
        expect(accessory.specialModification, false, reason: 'Missing specialmodification should default to false');
        expect(accessory.included, false, reason: 'Missing included should default to false');
        expect(accessory.equipped, false, reason: 'Missing equipped should default to false');
        expect(accessory.discountedCost, false, reason: 'Missing discountedcost should default to false');
        expect(accessory.wirelessOn, false, reason: 'Missing wirelesson should default to false');
        expect(accessory.stolen, false, reason: 'Missing stolen should default to false');
        expect(accessory.sortOrder, 0, reason: 'Missing sortorder should default to 0');
      });

      test('should parse boolean values correctly', () {
        // Test: Verify fromXml correctly parses XML boolean values (True/False) to Dart booleans
        // Arrange
        final xmlString = '''
          <accessory>
            <name>Boolean Test</name>
            <mount>Test</mount>
            <extramount>Test</extramount>
            <avail>1</avail>
            <cost>1</cost>
            <source>Test</source>
            <page>1</page>
            <rcdeployable>True</rcdeployable>
            <specialmodification>False</specialmodification>
            <included>True</included>
            <equipped>False</equipped>
            <discountedcost>True</discountedcost>
            <wirelesson>False</wirelesson>
            <stolen>True</stolen>
          </accessory>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final accessory = WeaponAccessory.fromXml(xmlElement);

        // Assert
        expect(accessory.rcDeployable, true, reason: 'XML "True" should parse to boolean true');
        expect(accessory.specialModification, false, reason: 'XML "False" should parse to boolean false');
        expect(accessory.included, true, reason: 'XML "True" should parse to boolean true');
        expect(accessory.equipped, false, reason: 'XML "False" should parse to boolean false');
        expect(accessory.discountedCost, true, reason: 'XML "True" should parse to boolean true');
        expect(accessory.wirelessOn, false, reason: 'XML "False" should parse to boolean false');
        expect(accessory.stolen, true, reason: 'XML "True" should parse to boolean true');
      });

      test('should parse numeric values correctly with invalid input', () {
        // Test: Verify fromXml handles invalid numeric input gracefully by defaulting to 0
        // Arrange
        final xmlString = '''
          <accessory>
            <name>Numeric Test</name>
            <mount>Test</mount>
            <extramount>Test</extramount>
            <avail>1</avail>
            <cost>1</cost>
            <source>Test</source>
            <page>1</page>
            <maxrating>invalid</maxrating>
            <rating>invalid</rating>
            <rcgroup>invalid</rcgroup>
            <ammoslots>invalid</ammoslots>
            <singleshot>invalid</singleshot>
            <shortburst>invalid</shortburst>
            <longburst>invalid</longburst>
            <fullburst>invalid</fullburst>
            <suppressive>invalid</suppressive>
            <rangebonus>invalid</rangebonus>
            <rangemodifier>invalid</rangemodifier>
            <sortorder>invalid</sortorder>
          </accessory>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final accessory = WeaponAccessory.fromXml(xmlElement);

        // Assert
        expect(accessory.maxRating, 0, reason: 'Invalid numeric input should default to 0');
        expect(accessory.rating, 0, reason: 'Invalid numeric input should default to 0');
        expect(accessory.rcGroup, 0, reason: 'Invalid numeric input should default to 0');
        expect(accessory.ammoSlots, 0, reason: 'Invalid numeric input should default to 0');
        expect(accessory.singleShot, 0, reason: 'Invalid numeric input should default to 0');
        expect(accessory.shortBurst, 0, reason: 'Invalid numeric input should default to 0');
        expect(accessory.longBurst, 0, reason: 'Invalid numeric input should default to 0');
        expect(accessory.fullBurst, 0, reason: 'Invalid numeric input should default to 0');
        expect(accessory.suppressive, 0, reason: 'Invalid numeric input should default to 0');
        expect(accessory.rangeBonus, 0, reason: 'Invalid numeric input should default to 0');
        expect(accessory.rangeModifier, 0, reason: 'Invalid numeric input should default to 0');
        expect(accessory.sortOrder, 0, reason: 'Invalid numeric input should default to 0');
      });

      test('should parse gears correctly', () {
        // Test: Verify fromXml correctly parses nested gear elements
        // Arrange
        final xmlString = '''
          <accessory>
            <name>Accessory with Gears</name>
            <mount>Internal</mount>
            <extramount>None</extramount>
            <avail>6R</avail>
            <cost>3000</cost>
            <source>Core</source>
            <page>432</page>
            <gears>
              <gear>
                <sourceid>gear-source</sourceid>
                <name>Embedded Gear</name>
                <category>Electronics</category>
                <armorcapacity>1</armorcapacity>
                <maxrating>6</maxrating>
                <rating>3</rating>
                <qty>1</qty>
                <avail>4</avail>
                <cost>500</cost>
                <source>Core</source>
                <page>440</page>
              </gear>
            </gears>
          </accessory>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final accessory = WeaponAccessory.fromXml(xmlElement);

        // Assert
        expect(accessory.gears, hasLength(1), reason: 'Should parse exactly one gear from XML');
        expect(accessory.gears!.first.name, 'Embedded Gear', reason: 'Gear name should be parsed from nested XML');
        expect(accessory.gears!.first.category, 'Electronics', reason: 'Gear category should be parsed from nested XML');
        expect(accessory.gears!.first.rating, 3, reason: 'Gear rating should be parsed from nested XML');
      });
    });
  });
}
