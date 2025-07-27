import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/weapon.dart';

void main() {
  group('Weapon', () {
    test('should create Weapon with required parameters', () {
      // Arrange & Act
      final weapon = Weapon(
        name: 'Ares Predator V',
        category: 'Pistols',
        source: 'Core',
        page: '426',
        type: 'Ranged',
        damage: '8P',
        ap: '-1',
        mode: 'SA',
        ammo: '15(c)',
        firingMode: 'SA',
        accuracy: '5',
        avail: '5R',
      );

      // Assert
      expect(weapon.name, 'Ares Predator V');
      expect(weapon.category, 'Pistols');
      expect(weapon.source, 'Core');
      expect(weapon.page, '426');
      expect(weapon.type, 'Ranged');
      expect(weapon.damage, '8P');
      expect(weapon.ap, '-1');
      expect(weapon.mode, 'SA');
      expect(weapon.ammo, '15(c)');
      expect(weapon.firingMode, 'SA');
      expect(weapon.accuracy, '5');
      expect(weapon.avail, '5R');
      
      // Check defaults
      expect(weapon.reach, 0);
      expect(weapon.rc, 0);
      expect(weapon.cyberware, false);
      expect(weapon.ammoSlots, 1);
      expect(weapon.rating, 0);
      expect(weapon.activeAmmoSlot, 1);
      expect(weapon.conceal, '0');
      expect(weapon.cost, 0);
      expect(weapon.rangeMultiply, 1);
      expect(weapon.singleShot, 1);
      expect(weapon.shortBurst, 3);
      expect(weapon.longBurst, 6);
      expect(weapon.fullBurst, 10);
      expect(weapon.suppressive, 20);
      expect(weapon.allowSingleShot, true);
      expect(weapon.allowShortBurst, true);
      expect(weapon.allowLongBurst, true);
      expect(weapon.allowFullBurst, true);
      expect(weapon.allowSuppressive, true);
      expect(weapon.allowAccessory, false);
      expect(weapon.included, false);
      expect(weapon.requireAmmo, true);
    });

    test('should create Weapon with all optional parameters', () {
      // Arrange & Act
      final weapon = Weapon(
        sourceId: 'test-source',
        locationGuid: 'test-guid',
        name: 'Custom Rifle',
        category: 'Assault Rifles',
        source: 'Run & Gun',
        page: '123',
        equipped: true,
        active: true,
        homeNode: true,
        wirelessOn: true,
        stolen: true,
        deviceRating: '3',
        programLimit: '2',
        overclocked: '1',
        attack: '4',
        sleaze: '3',
        dataProcessing: '5',
        firewall: '4',
        attributeArray: ['A', 'S', 'D', 'F'],
        modAttack: '1',
        modSleaze: '1',
        modDataProcessing: '1',
        modFirewall: '1',
        modAttributeArray: ['MA', 'MS', 'MD', 'MF'],
        canSwapAttributes: true,
        matrixCmFilled: 2,
        matrixCmBonus: 1,
        notes: 'Custom weapon',
        notesColor: 'red',
        discountedCost: true,
        sortOrder: 5,
        type: 'Ranged',
        spec: 'Assault Rifle',
        spec2: 'Military Grade',
        reach: 1,
        damage: '10P',
        ap: '-2',
        mode: 'SA/BF/FA',
        rc: 2,
        ammo: '30(c)',
        cyberware: false,
        ammoCategory: 'Standard',
        ammoSlots: 2,
        sizeCategory: 'Medium',
        firingMode: 'FA',
        minRating: '1',
        maxRating: '6',
        rating: 4,
        accuracy: '6',
        activeAmmoSlot: 2,
        conceal: '-2',
        cost: 8500,
        weight: '4.5',
        useSkill: 'Automatics',
        useSkillSpec: 'Assault Rifles',
        range: '150/350/550/750',
        alternateRange: '75/175/350/550',
        rangeMultiply: 2,
        singleShot: 1,
        shortBurst: 3,
        longBurst: 6,
        fullBurst: 10,
        suppressive: 20,
        allowSingleShot: true,
        allowShortBurst: true,
        allowLongBurst: true,
        allowFullBurst: true,
        allowSuppressive: true,
        parentId: 'parent-123',
        allowAccessory: true,
        included: false,
        requireAmmo: true,
        mount: 'External',
        extraMount: 'Barrel',
        accessories: [],
        location: 'Shoulder Holster',
        weaponType: 'Firearm',
        avail: '12F',
      );

      // Assert
      expect(weapon.sourceId, 'test-source');
      expect(weapon.locationGuid, 'test-guid');
      expect(weapon.name, 'Custom Rifle');
      expect(weapon.category, 'Assault Rifles');
      expect(weapon.source, 'Run & Gun');
      expect(weapon.page, '123');
      expect(weapon.equipped, true);
      expect(weapon.active, true);
      expect(weapon.homeNode, true);
      expect(weapon.wirelessOn, true);
      expect(weapon.stolen, true);
      expect(weapon.type, 'Ranged');
      expect(weapon.spec, 'Assault Rifle');
      expect(weapon.spec2, 'Military Grade');
      expect(weapon.reach, 1);
      expect(weapon.damage, '10P');
      expect(weapon.ap, '-2');
      expect(weapon.mode, 'SA/BF/FA');
      expect(weapon.rc, 2);
      expect(weapon.ammo, '30(c)');
      expect(weapon.cyberware, false);
      expect(weapon.ammoCategory, 'Standard');
      expect(weapon.ammoSlots, 2);
      expect(weapon.sizeCategory, 'Medium');
      expect(weapon.firingMode, 'FA');
      expect(weapon.minRating, '1');
      expect(weapon.maxRating, '6');
      expect(weapon.rating, 4);
      expect(weapon.accuracy, '6');
      expect(weapon.activeAmmoSlot, 2);
      expect(weapon.conceal, '-2');
      expect(weapon.cost, 8500);
      expect(weapon.weight, '4.5');
      expect(weapon.useSkill, 'Automatics');
      expect(weapon.useSkillSpec, 'Assault Rifles');
      expect(weapon.range, '150/350/550/750');
      expect(weapon.alternateRange, '75/175/350/550');
      expect(weapon.rangeMultiply, 2);
      expect(weapon.allowAccessory, true);
      expect(weapon.parentId, 'parent-123');
      expect(weapon.mount, 'External');
      expect(weapon.extraMount, 'Barrel');
      expect(weapon.accessories, isEmpty);
      expect(weapon.location, 'Shoulder Holster');
      expect(weapon.weaponType, 'Firearm');
      expect(weapon.avail, '12F');
    });

    group('fromXml', () {
      test('should parse minimal XML correctly', () {
        // Arrange
        final xmlString = '''
          <weapon>
            <name>Basic Weapon</name>
            <category>Pistols</category>
            <type>Ranged</type>
            <damage>6P</damage>
            <ap>0</ap>
            <mode>SA</mode>
            <ammo>10(c)</ammo>
            <firingmode>SA</firingmode>
            <accuracy>5</accuracy>
            <source>Core</source>
            <page>420</page>
            <avail>4R</avail>
          </weapon>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final weapon = Weapon.fromXml(xmlElement);

        // Assert
        expect(weapon.name, 'Basic Weapon');
        expect(weapon.category, 'Pistols');
        expect(weapon.type, 'Ranged');
        expect(weapon.damage, '6P');
        expect(weapon.ap, '0');
        expect(weapon.mode, 'SA');
        expect(weapon.ammo, '10(c)');
        expect(weapon.firingMode, 'SA');
        expect(weapon.accuracy, '5');
        expect(weapon.source, 'Core');
        expect(weapon.page, '420');
        expect(weapon.reach, 0);
        expect(weapon.rc, 0);
        expect(weapon.cyberware, false);
        expect(weapon.rating, 0);
        expect(weapon.activeAmmoSlot, 1);
        expect(weapon.cost, 0);
        expect(weapon.rangeMultiply, 1);
        expect(weapon.allowAccessory, false);
        expect(weapon.included, false);
        expect(weapon.requireAmmo, true);
      });

      test('should parse complete XML correctly', () {
        // Arrange
        final xmlString = '''
          <weapon>
            <sourceid>test-source</sourceid>
            <guid>test-guid</guid>
            <name>Advanced Weapon</name>
            <category>Assault Rifles</category>
            <type>Ranged</type>
            <spec>Assault Rifle</spec>
            <spec2>Military</spec2>
            <reach>1</reach>
            <damage>10P</damage>
            <ap>-2</ap>
            <mode>SA/BF/FA</mode>
            <rc>2</rc>
            <ammo>30(c)</ammo>
            <cyberware>False</cyberware>
            <ammocategory>Standard</ammocategory>
            <ammoslots>2</ammoslots>
            <sizecategory>Medium</sizecategory>
            <firingmode>FA</firingmode>
            <minrating>1</minrating>
            <maxrating>6</maxrating>
            <rating>4</rating>
            <accuracy>6</accuracy>
            <activeammoslot>2</activeammoslot>
            <conceal>-2</conceal>
            <cost>8500</cost>
            <weight>4.5</weight>
            <useskill>Automatics</useskill>
            <useskillspec>Assault Rifles</useskillspec>
            <range>150/350/550/750</range>
            <alternaterange>75/175/350/550</alternaterange>
            <rangemultiply>2</rangemultiply>
            <singleshot>1</singleshot>
            <shortburst>3</shortburst>
            <longburst>6</longburst>
            <fullburst>10</fullburst>
            <suppressive>20</suppressive>
            <allowsingleshot>True</allowsingleshot>
            <allowshortburst>True</allowshortburst>
            <allowlongburst>True</allowlongburst>
            <allowfullburst>True</allowfullburst>
            <allowsuppressive>True</allowsuppressive>
            <parentid>parent-123</parentid>
            <allowaccessory>True</allowaccessory>
            <weaponname>My Weapon</weaponname>
            <included>True</included>
            <requireammo>True</requireammo>
            <mount>External</mount>
            <extramount>Barrel</extramount>
            <location>Holster</location>
            <weapontype>Firearm</weapontype>
            <source>Run &amp; Gun</source>
            <page>123</page>
            <avail>12F</avail>
            <equipped>True</equipped>
            <active>True</active>
            <homenode>True</homenode>
            <wirelesson>True</wirelesson>
            <stolen>True</stolen>
            <devicerating>3</devicerating>
            <notes>Test weapon</notes>
            <notesColor>blue</notesColor>
            <discountedcost>True</discountedcost>
            <sortorder>5</sortorder>
          </weapon>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final weapon = Weapon.fromXml(xmlElement);

        // Assert
        expect(weapon.sourceId, 'test-source', reason: 'sourceId should be parsed correctly');
        expect(weapon.locationGuid, 'Holster', reason: 'locationGuid should be parsed correctly');
        expect(weapon.name, 'Advanced Weapon', reason: 'name should be parsed correctly');
        expect(weapon.category, 'Assault Rifles', reason: 'category should be parsed correctly');
        expect(weapon.type, 'Ranged', reason: 'type should be parsed correctly');
        expect(weapon.spec, 'Assault Rifle', reason: 'spec should be parsed correctly');
        expect(weapon.spec2, 'Military', reason: 'spec2 should be parsed correctly');
        expect(weapon.reach, 1, reason: 'reach should be parsed correctly');
        expect(weapon.damage, '10P', reason: 'damage should be parsed correctly');
        expect(weapon.ap, '-2', reason: 'ap should be parsed correctly');
        expect(weapon.mode, 'SA/BF/FA', reason: 'mode should be parsed correctly');
        expect(weapon.rc, 2, reason: 'rc should be parsed correctly');
        expect(weapon.ammo, '30(c)', reason: 'ammo should be parsed correctly');
        expect(weapon.cyberware, false, reason: 'cyberware should be parsed correctly');
        expect(weapon.ammoCategory, 'Standard', reason: 'ammoCategory should be parsed correctly');
        expect(weapon.ammoSlots, 2, reason: 'ammoSlots should be parsed correctly');
        expect(weapon.sizeCategory, 'Medium', reason: 'sizeCategory should be parsed correctly');
        expect(weapon.firingMode, 'FA', reason: 'firingMode should be parsed correctly');
        expect(weapon.minRating, '1', reason: 'minRating should be parsed correctly');
        expect(weapon.maxRating, '6', reason: 'maxRating should be parsed correctly');
        expect(weapon.rating, 4, reason: 'rating should be parsed correctly');
        expect(weapon.accuracy, '6', reason: 'accuracy should be parsed correctly');
        expect(weapon.activeAmmoSlot, 2, reason: 'activeAmmoSlot should be parsed correctly');
        expect(weapon.conceal, '-2', reason: 'conceal should be parsed correctly');
        expect(weapon.cost, 8500, reason: 'cost should be parsed correctly');
        expect(weapon.weight, '4.5', reason: 'weight should be parsed correctly');
        expect(weapon.useSkill, 'Automatics', reason: 'useSkill should be parsed correctly');
        expect(weapon.useSkillSpec, 'Assault Rifles', reason: 'useSkillSpec should be parsed correctly');
        expect(weapon.range, '150/350/550/750', reason: 'range should be parsed correctly');
        expect(weapon.alternateRange, '75/175/350/550', reason: 'alternateRange should be parsed correctly');
        expect(weapon.rangeMultiply, 2, reason: 'rangeMultiply should be parsed correctly');
        expect(weapon.allowAccessory, true, reason: 'allowAccessory should be parsed correctly');
        expect(weapon.included, true, reason: 'included should be parsed correctly');
        expect(weapon.parentId, 'parent-123', reason: 'parentId should be parsed correctly');
        expect(weapon.mount, 'External', reason: 'mount should be parsed correctly');
        expect(weapon.extraMount, 'Barrel', reason: 'extraMount should be parsed correctly');
        expect(weapon.location, 'Holster', reason: 'location should be parsed correctly');
        expect(weapon.weaponType, 'Firearm', reason: 'weaponType should be parsed correctly');
        expect(weapon.source, 'Run & Gun', reason: 'source should be parsed correctly');
        expect(weapon.page, '123', reason: 'page should be parsed correctly');
        expect(weapon.equipped, true, reason: 'equipped should be parsed correctly');
        expect(weapon.active, true, reason: 'active should be parsed correctly');
        expect(weapon.homeNode, true, reason: 'homeNode should be parsed correctly');
        expect(weapon.wirelessOn, true, reason: 'wirelessOn should be parsed correctly');
        expect(weapon.stolen, true, reason: 'stolen should be parsed correctly');
        expect(weapon.deviceRating, '3', reason: 'deviceRating should be parsed correctly');
        expect(weapon.notes, 'Test weapon', reason: 'notes should be parsed correctly');
        expect(weapon.notesColor, 'blue', reason: 'notesColor should be parsed correctly');
        expect(weapon.discountedCost, true, reason: 'discountedCost should be parsed correctly');
        expect(weapon.sortOrder, 5, reason: 'sortOrder should be parsed correctly');
      });

      test('should handle missing XML elements gracefully', () {
        // Arrange
        final xmlString = '''
          <weapon>
            <name></name>
            <category></category>
            <source></source>
            <page></page>
          </weapon>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final weapon = Weapon.fromXml(xmlElement);

        // Assert
        expect(weapon.name, 'Unnamed Weapon');
        expect(weapon.category, 'Unknown');
        expect(weapon.type, 'Unknown');
        expect(weapon.source, 'Unknown');
        expect(weapon.page, '0');
        expect(weapon.damage, '0');
        expect(weapon.ap, '-');
        expect(weapon.mode, 'Unknown');
        expect(weapon.ammo, 'Unknown');
        expect(weapon.firingMode, 'Unknown');
        expect(weapon.accuracy, '0');
      });

      test('should parse boolean values correctly', () {
        // Arrange
        final xmlString = '''
          <weapon>
            <name>Test</name>
            <category>Test</category>
            <type>Test</type>
            <damage>1</damage>
            <ap>0</ap>
            <mode>Test</mode>
            <ammo>Test</ammo>
            <firingmode>Test</firingmode>
            <accuracy>1</accuracy>
            <source>Test</source>
            <page>1</page>
            <avail>1</avail>
            <cyberware>True</cyberware>
            <allowsingleshot>False</allowsingleshot>
            <allowshortburst>False</allowshortburst>
            <allowlongburst>False</allowlongburst>
            <allowfullburst>False</allowfullburst>
            <allowsuppressive>False</allowsuppressive>
            <allowaccessory>True</allowaccessory>
            <included>True</included>
            <requireammo>False</requireammo>
            <equipped>True</equipped>
            <active>True</active>
            <homenode>True</homenode>
            <wirelesson>True</wirelesson>
            <stolen>True</stolen>
            <discountedcost>True</discountedcost>
          </weapon>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final weapon = Weapon.fromXml(xmlElement);

        // Assert
        expect(weapon.cyberware, true, reason: 'cyberware should be parsed as true');
        expect(weapon.allowSingleShot, false, reason: 'allowSingleShot should be parsed as false');
        expect(weapon.allowShortBurst, false, reason: 'allowShortBurst should be parsed as false');
        expect(weapon.allowLongBurst, false, reason: 'allowLongBurst should be parsed as false');
        expect(weapon.allowFullBurst, false, reason: 'allowFullBurst should be parsed as false');
        expect(weapon.allowSuppressive, false, reason: 'allowSuppressive should be parsed as false');
        expect(weapon.allowAccessory, true, reason: 'allowAccessory should be parsed as true');
        expect(weapon.included, true, reason: 'included should be parsed as true');
        expect(weapon.requireAmmo, false, reason: 'requireAmmo should be parsed as false');
        expect(weapon.equipped, true, reason: 'equipped should be parsed as true');
        expect(weapon.active, true, reason: 'active should be parsed as true');
        expect(weapon.homeNode, true, reason: 'homeNode should be parsed as true');
        expect(weapon.wirelessOn, true, reason: 'wirelessOn should be parsed as true');
        expect(weapon.stolen, true, reason: 'stolen should be parsed as true');
        expect(weapon.discountedCost, true, reason: 'discountedCost should be parsed as true');
      });

      test('should parse numeric values correctly with invalid input', () {
        // Arrange
        final xmlString = '''
          <weapon>
            <name>Test</name>
            <category>Test</category>
            <type>Test</type>
            <damage>1</damage>
            <ap>0</ap>
            <mode>Test</mode>
            <ammo>Test</ammo>
            <firingmode>Test</firingmode>
            <accuracy>1</accuracy>
            <source>Test</source>
            <page>1</page>
            <avail>1</avail>
            <reach>invalid</reach>
            <rc>invalid</rc>
            <ammoslots>invalid</ammoslots>
            <rating>invalid</rating>
            <activeammoslot>invalid</activeammoslot>
            <cost>invalid</cost>
            <rangemultiply>invalid</rangemultiply>
            <singleshot>invalid</singleshot>
            <shortburst>invalid</shortburst>
            <longburst>invalid</longburst>
            <fullburst>invalid</fullburst>
            <suppressive>invalid</suppressive>
            <sortorder>invalid</sortorder>
          </weapon>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final weapon = Weapon.fromXml(xmlElement);

        // Assert
        expect(weapon.reach, 0);
        expect(weapon.rc, 0);
        expect(weapon.ammoSlots, 1);
        expect(weapon.rating, 0);
        expect(weapon.activeAmmoSlot, 1);
        expect(weapon.cost, 0);
        expect(weapon.rangeMultiply, 1);
        expect(weapon.singleShot, 1);
        expect(weapon.shortBurst, 3);
        expect(weapon.longBurst, 6);
        expect(weapon.fullBurst, 10);
        expect(weapon.suppressive, 20);
        expect(weapon.sortOrder, 0);
      });
    });
  });
}
