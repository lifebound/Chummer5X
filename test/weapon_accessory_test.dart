import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/weapon_accessory.dart';

void main() {
  group('WeaponAccessory', () {
    test('should create WeaponAccessory with required parameters', () {
      // Arrange & Act
      final accessory = WeaponAccessory(
        name: 'Smartgun System',
        mount: 'Internal',
        extraMount: 'None',
        avail: '8R',
        cost: '2000',
        source: 'Core',
        page: '431',
      );

      // Assert
      expect(accessory.name, 'Smartgun System');
      expect(accessory.mount, 'Internal');
      expect(accessory.extraMount, 'None');
      expect(accessory.avail, '8R');
      expect(accessory.cost, '2000');
      expect(accessory.source, 'Core');
      expect(accessory.page, '431');
      
      // Check defaults
      expect(accessory.sourceId, null);
      expect(accessory.guid, null);
      expect(accessory.rc, null);
      expect(accessory.maxRating, 0);
      expect(accessory.rating, 0);
      expect(accessory.ratingLabel, 'String_Rating');
      expect(accessory.rcGroup, 0);
      expect(accessory.rcDeployable, false);
      expect(accessory.specialModification, false);
      expect(accessory.conceal, null);
      expect(accessory.weight, null);
      expect(accessory.included, false);
      expect(accessory.equipped, false);
      expect(accessory.accuracy, null);
      expect(accessory.gears, null);
      expect(accessory.ammoReplace, null);
      expect(accessory.ammoSlots, 0);
      expect(accessory.modifyAmmoCapacity, null);
      expect(accessory.damageType, null);
      expect(accessory.damage, null);
      expect(accessory.reach, null);
      expect(accessory.damageReplace, null);
      expect(accessory.fireMode, null);
      expect(accessory.fireModeReplace, null);
      expect(accessory.ap, null);
      expect(accessory.apReplace, null);
      expect(accessory.notes, null);
      expect(accessory.notesColor, null);
      expect(accessory.discountedCost, false);
      expect(accessory.singleShot, 0);
      expect(accessory.shortBurst, 0);
      expect(accessory.longBurst, 0);
      expect(accessory.fullBurst, 0);
      expect(accessory.suppressive, 0);
      expect(accessory.rangeBonus, 0);
      expect(accessory.rangeModifier, 0);
      expect(accessory.extra, null);
      expect(accessory.ammoBonus, null);
      expect(accessory.wirelessOn, false);
      expect(accessory.stolen, false);
      expect(accessory.sortOrder, 0);
      expect(accessory.parentId, null);
    });

    test('should create WeaponAccessory with all optional parameters', () {
      // Arrange & Act
      final accessory = WeaponAccessory(
        sourceId: 'test-source',
        guid: 'test-guid',
        name: 'Advanced Scope',
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
        cost: '15000',
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
      expect(accessory.sourceId, 'test-source');
      expect(accessory.guid, 'test-guid');
      expect(accessory.name, 'Advanced Scope');
      expect(accessory.mount, 'Top');
      expect(accessory.extraMount, 'Barrel');
      expect(accessory.rc, '2');
      expect(accessory.maxRating, 6);
      expect(accessory.rating, 4);
      expect(accessory.ratingLabel, 'Rating');
      expect(accessory.rcGroup, 3);
      expect(accessory.rcDeployable, true);
      expect(accessory.specialModification, true);
      expect(accessory.conceal, '+2');
      expect(accessory.avail, '12F');
      expect(accessory.cost, '15000');
      expect(accessory.weight, '1.5');
      expect(accessory.included, true);
      expect(accessory.equipped, true);
      expect(accessory.source, 'Run & Gun');
      expect(accessory.page, '200');
      expect(accessory.accuracy, '+1');
      expect(accessory.gears, isEmpty);
      expect(accessory.ammoReplace, 'APDS');
      expect(accessory.ammoSlots, 2);
      expect(accessory.modifyAmmoCapacity, '+10');
      expect(accessory.damageType, 'Physical');
      expect(accessory.damage, '+2P');
      expect(accessory.reach, '+1');
      expect(accessory.damageReplace, '10P');
      expect(accessory.fireMode, 'SA');
      expect(accessory.fireModeReplace, 'BF');
      expect(accessory.ap, '-1');
      expect(accessory.apReplace, '-3');
      expect(accessory.notes, 'Custom accessory');
      expect(accessory.notesColor, 'red');
      expect(accessory.discountedCost, true);
      expect(accessory.singleShot, 1);
      expect(accessory.shortBurst, 3);
      expect(accessory.longBurst, 6);
      expect(accessory.fullBurst, 10);
      expect(accessory.suppressive, 20);
      expect(accessory.rangeBonus, 50);
      expect(accessory.rangeModifier, 2);
      expect(accessory.extra, 'Thermographic');
      expect(accessory.ammoBonus, '10');
      expect(accessory.wirelessOn, true);
      expect(accessory.stolen, true);
      expect(accessory.sortOrder, 5);
      expect(accessory.parentId, 'parent-123');
    });

    group('fromXml', () {
      test('should parse minimal XML correctly', () {
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
        expect(accessory.name, 'Basic Scope');
        expect(accessory.mount, 'Top');
        expect(accessory.extraMount, 'None');
        expect(accessory.avail, '4R');
        expect(accessory.cost, '500');
        expect(accessory.source, 'Core');
        expect(accessory.page, '431');
        expect(accessory.sourceId, null);
        expect(accessory.guid, null);
        expect(accessory.rc, null);
        expect(accessory.maxRating, 0);
        expect(accessory.rating, 0);
        expect(accessory.ratingLabel, 'String_Rating');
        expect(accessory.rcGroup, 0);
        expect(accessory.rcDeployable, false);
        expect(accessory.specialModification, false);
        expect(accessory.conceal, null);
        expect(accessory.weight, null);
        expect(accessory.included, false);
        expect(accessory.equipped, false);
        expect(accessory.accuracy, null);
        expect(accessory.gears, isEmpty);
        expect(accessory.discountedCost, false);
        expect(accessory.wirelessOn, false);
        expect(accessory.stolen, false);
        expect(accessory.sortOrder, 0);
      });

      test('should parse complete XML correctly', () {
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
        expect(accessory.sourceId, 'complete-source');
        expect(accessory.guid, 'complete-guid');
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
        expect(accessory.cost, '25000');
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
        // Arrange
        final xmlString = '''
          <accessory>
          </accessory>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final accessory = WeaponAccessory.fromXml(xmlElement);

        // Assert
        expect(accessory.name, 'Unnamed Accessory');
        expect(accessory.mount, 'None');
        expect(accessory.extraMount, 'None');
        expect(accessory.avail, '');
        expect(accessory.cost, '0');
        expect(accessory.source, 'Unknown');
        expect(accessory.page, '0');
        expect(accessory.ratingLabel, 'String_Rating');
        expect(accessory.maxRating, 0);
        expect(accessory.rating, 0);
        expect(accessory.rcGroup, 0);
        expect(accessory.rcDeployable, false);
        expect(accessory.specialModification, false);
        expect(accessory.included, false);
        expect(accessory.equipped, false);
        expect(accessory.discountedCost, false);
        expect(accessory.wirelessOn, false);
        expect(accessory.stolen, false);
        expect(accessory.sortOrder, 0);
      });

      test('should parse boolean values correctly', () {
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
        expect(accessory.rcDeployable, true);
        expect(accessory.specialModification, false);
        expect(accessory.included, true);
        expect(accessory.equipped, false);
        expect(accessory.discountedCost, true);
        expect(accessory.wirelessOn, false);
        expect(accessory.stolen, true);
      });

      test('should parse numeric values correctly with invalid input', () {
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
        expect(accessory.maxRating, 0);
        expect(accessory.rating, 0);
        expect(accessory.rcGroup, 0);
        expect(accessory.ammoSlots, 0);
        expect(accessory.singleShot, 0);
        expect(accessory.shortBurst, 0);
        expect(accessory.longBurst, 0);
        expect(accessory.fullBurst, 0);
        expect(accessory.suppressive, 0);
        expect(accessory.rangeBonus, 0);
        expect(accessory.rangeModifier, 0);
        expect(accessory.sortOrder, 0);
      });

      test('should parse gears correctly', () {
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
        expect(accessory.gears, hasLength(1));
        expect(accessory.gears!.first.name, 'Embedded Gear');
        expect(accessory.gears!.first.category, 'Electronics');
        expect(accessory.gears!.first.rating, 3);
      });
    });
  });
}
