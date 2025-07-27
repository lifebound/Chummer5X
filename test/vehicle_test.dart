import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/vehicle.dart';
import 'package:chummer5x/models/items/gear.dart';

void main() {
  group('Vehicle', () {
    test('should create Vehicle with required parameters', () {
      // Arrange & Act
      final vehicle = Vehicle(
        sourceId: 'test-id',
        locationGuid: 'test-guid',
        name: 'Ares Roadmaster',
        category: 'Truck',
        avail: '8R',
        cost: 45000,
        source: 'Core',
        page: '462',
        sortOrder: 1,
        stolen: false,
        discountedCost: false,
        active: false,
        homeNode: false,
        handling: '5',
        offRoadHandling: '4',
        accel: '2',
        offRoadAccel: '1',
        speed: '4',
        offRoadSpeed: '3',
        pilot: '1',
        body: '16',
        seats: '8',
        armor: '12',
        sensor: '2',
        addSlots: '0',
        modSlots: '3',
        powertrainModSlots: '1',
        protectionModSlots: '1',
        weaponModSlots: '1',
        bodyModSlots: '0',
        electromagneticModSlots: '0',
        cosmeticModSlots: '0',
        physicalCmFilled: '0',
        vehicleName: 'My Roadmaster',
        dealerConnection: false,
        mods: [],
        weaponMounts: [],
        gears: [],
      );

      // Assert
      expect(vehicle.name, 'Ares Roadmaster', reason: 'Name should match the value provided in constructor');
      expect(vehicle.category, 'Truck', reason: 'Category should match the value provided in constructor');
      expect(vehicle.source, 'Core', reason: 'Source should match the value provided in constructor');
      expect(vehicle.page, '462', reason: 'Page should match the value provided in constructor');
      expect(vehicle.handling, '5', reason: 'Handling should match the value provided in constructor');
      expect(vehicle.offRoadHandling, '4', reason: 'Off-road handling should match the value provided in constructor');
      expect(vehicle.accel, '2', reason: 'Acceleration should match the value provided in constructor');
      expect(vehicle.offRoadAccel, '1', reason: 'Off-road acceleration should match the value provided in constructor');
      expect(vehicle.speed, '4', reason: 'Speed should match the value provided in constructor');
      expect(vehicle.offRoadSpeed, '3', reason: 'Off-road speed should match the value provided in constructor');
      expect(vehicle.pilot, '1', reason: 'Pilot rating should match the value provided in constructor');
      expect(vehicle.body, '16', reason: 'Body should match the value provided in constructor');
      expect(vehicle.seats, '8', reason: 'Seats should match the value provided in constructor');
      expect(vehicle.armor, '12', reason: 'Armor should match the value provided in constructor');
      expect(vehicle.sensor, '2', reason: 'Sensor should match the value provided in constructor');
      expect(vehicle.addSlots, '0', reason: 'Add slots should match the value provided in constructor');
      expect(vehicle.modSlots, '3', reason: 'Mod slots should match the value provided in constructor');
      expect(vehicle.powertrainModSlots, '1', reason: 'Powertrain mod slots should match the value provided in constructor');
      expect(vehicle.protectionModSlots, '1', reason: 'Protection mod slots should match the value provided in constructor');
      expect(vehicle.weaponModSlots, '1', reason: 'Weapon mod slots should match the value provided in constructor');
      expect(vehicle.bodyModSlots, '0', reason: 'Body mod slots should match the value provided in constructor');
      expect(vehicle.electromagneticModSlots, '0', reason: 'Electromagnetic mod slots should match the value provided in constructor');
      expect(vehicle.cosmeticModSlots, '0', reason: 'Cosmetic mod slots should match the value provided in constructor');
      expect(vehicle.physicalCmFilled, '0', reason: 'Physical CM filled should match the value provided in constructor');
      expect(vehicle.vehicleName, 'My Roadmaster', reason: 'Vehicle name should match the value provided in constructor');
      expect(vehicle.dealerConnection, false, reason: 'Dealer connection should match the value provided in constructor');
      expect(vehicle.mods, isEmpty, reason: 'Mods should be empty as provided in constructor');
      expect(vehicle.weaponMounts, isEmpty, reason: 'Weapon mounts should be empty as provided in constructor');
      expect(vehicle.gears, isEmpty, reason: 'Gears should be empty as provided in constructor');
      expect(vehicle.weapons, isNull, reason: 'Weapons should be null when not specified in constructor');
      expect(vehicle.equipped, true, reason: 'Equipped should default to true when not specified in constructor');
      expect(vehicle.wirelessOn, false, reason: 'Wireless should default to false when not specified in constructor');
      expect(vehicle.canFormPersona, false, reason: 'Can form persona should default to false when not specified in constructor');
      expect(vehicle.matrixCmBonus, 0, reason: 'Matrix CM bonus should default to 0 when not specified in constructor');
    });

    test('should create Vehicle with optional parameters', () {
      // Arrange
      final mockGear = Gear(
        name: 'Test Gear',
        category: 'Electronics',
        source: 'Core',
        page: '1',
        avail: '—'
      );

      // Act
      final vehicle = Vehicle(
        sourceId: 'test-id',
        locationGuid: 'test-guid',
        name: 'Custom Vehicle',
        category: 'Car',
        avail: '12F',
        cost: 80000,
        source: 'Data Trails',
        page: '234',
        sortOrder: 5,
        stolen: true,
        discountedCost: true,
        active: true,
        homeNode: true,
        handling: '6',
        offRoadHandling: '3',
        accel: '3',
        offRoadAccel: '2',
        speed: '5',
        offRoadSpeed: '2',
        pilot: '3',
        body: '12',
        seats: '4',
        armor: '8',
        sensor: '3',
        addSlots: '2',
        modSlots: '5',
        powertrainModSlots: '2',
        protectionModSlots: '2',
        weaponModSlots: '2',
        bodyModSlots: '1',
        electromagneticModSlots: '1',
        cosmeticModSlots: '2',
        physicalCmFilled: '3',
        matrixCmFilled: 2,
        vehicleName: 'My Custom Ride',
        dealerConnection: true,
        programLimit: '5',
        overclocked: '1',
        attack: '4',
        sleaze: '5',
        dataProcessing: '6',
        firewall: '7',
        attributeArray: ['A', 'S', 'D', 'F'],
        modAttack: '1',
        modSleaze: '1',
        modDataProcessing: '1',
        modFirewall: '1',
        modAttributeArray: ['MA', 'MS', 'MD', 'MF'],
        canSwapAttributes: true,
        mods: [],
        weaponMounts: [],
        gears: [mockGear],
        weapons: [],
        notes: 'Custom notes',
        notesColor: 'red',
        deviceRating: '4',
      );

      // Assert
      expect(vehicle.name, 'Custom Vehicle', reason: 'Name should match the value provided in constructor');
      expect(vehicle.category, 'Car', reason: 'Category should match the value provided in constructor');
      expect(vehicle.source, 'Data Trails', reason: 'Source should match the value provided in constructor');
      expect(vehicle.page, '234', reason: 'Page should match the value provided in constructor');
      expect(vehicle.stolen, true, reason: 'Stolen status should match the value provided in constructor');
      expect(vehicle.discountedCost, true, reason: 'Discounted cost status should match the value provided in constructor');
      expect(vehicle.active, true, reason: 'Active status should match the value provided in constructor');
      expect(vehicle.homeNode, true, reason: 'Home node status should match the value provided in constructor');
      expect(vehicle.dealerConnection, true, reason: 'Dealer connection should match the value provided in constructor');
      expect(vehicle.programLimit, '5', reason: 'Program limit should match the value provided in constructor');
      expect(vehicle.overclocked, '1', reason: 'Overclocked should match the value provided in constructor');
      expect(vehicle.attack, '4', reason: 'Attack should match the value provided in constructor');
      expect(vehicle.sleaze, '5', reason: 'Sleaze should match the value provided in constructor');
      expect(vehicle.dataProcessing, '6', reason: 'Data processing should match the value provided in constructor');
      expect(vehicle.firewall, '7', reason: 'Firewall should match the value provided in constructor');
      expect(vehicle.attributeArray, ['A', 'S', 'D', 'F'], reason: 'Attribute array should match the list provided in constructor');
      expect(vehicle.modAttack, '1', reason: 'Mod attack should match the value provided in constructor');
      expect(vehicle.modSleaze, '1', reason: 'Mod sleaze should match the value provided in constructor');
      expect(vehicle.modDataProcessing, '1', reason: 'Mod data processing should match the value provided in constructor');
      expect(vehicle.modFirewall, '1', reason: 'Mod firewall should match the value provided in constructor');
      expect(vehicle.modAttributeArray, ['MA', 'MS', 'MD', 'MF'], reason: 'Mod attribute array should match the list provided in constructor');
      expect(vehicle.canSwapAttributes, true, reason: 'Can swap attributes should match the value provided in constructor');
      expect(vehicle.gears, hasLength(1), reason: 'Gears should contain one gear as provided in constructor');
      expect(vehicle.gears.first.name, 'Test Gear', reason: 'First gear name should match the gear provided in constructor');
      expect(vehicle.weapons, hasLength(0), reason: 'Weapons should be empty as provided in constructor');
      expect(vehicle.notes, 'Custom notes', reason: 'Notes should match the value provided in constructor');
      expect(vehicle.notesColor, 'red', reason: 'Notes color should match the value provided in constructor');
      expect(vehicle.deviceRating, '4', reason: 'Device rating should match the value provided in constructor');
      expect(vehicle.matrixCmFilled, 2, reason: 'Matrix CM filled should match the value provided in constructor');
    });

    group('fromXml', () {
      test('should parse minimal XML correctly', () {
        // Arrange
        final xmlString = '''
          <vehicle>
            <sourceid>test-source</sourceid>
            <guid>test-guid</guid>
            <name>Basic Vehicle</name>
            <category>Car</category>
            <handling>4</handling>
            <offroadhandling>2</offroadhandling>
            <accel>2</accel>
            <offroadaccel>1</offroadaccel>
            <speed>4</speed>
            <offroadspeed>2</offroadspeed>
            <pilot>1</pilot>
            <body>10</body>
            <seats>4</seats>
            <armor>6</armor>
            <sensor>2</sensor>
            <source>Core</source>
            <page>460</page>
            <cost>25000</cost>
            <addslots>0</addslots>
            <modslots>2</modslots>
            <powertrainmodslots>1</powertrainmodslots>
            <protectionmodslots>1</protectionmodslots>
            <weaponmodslots>0</weaponmodslots>
            <bodymodslots>0</bodymodslots>
            <electromagneticmodslots>0</electromagneticmodslots>
            <cosmeticmodslots>1</cosmeticmodslots>
            <physicalcmfilled>0</physicalcmfilled>
            <vehiclename>My Car</vehiclename>
            <dealerconnection>False</dealerconnection>
            <sortorder>1</sortorder>
            <stolen>False</stolen>
            <discountedcost>False</discountedcost>
            <active>False</active>
            <homenode>False</homenode>
            <devicerating>2</devicerating>
            <mods></mods>
            <weaponmounts></weaponmounts>
            <gears></gears>
          </vehicle>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final vehicle = Vehicle.fromXml(xmlElement);

        // Assert
        expect(vehicle.sourceId, 'test-source', reason: 'Source ID should be parsed from XML sourceid element');
        expect(vehicle.locationGuid, '00000000-0000-0000-0000-000000000004', reason: 'Location GUID should be parsed from XML guid element');
        expect(vehicle.name, 'Basic Vehicle', reason: 'Name should be parsed from XML name element');
        expect(vehicle.category, 'Car', reason: 'Category should be parsed from XML category element');
        expect(vehicle.handling, '4', reason: 'Handling should be parsed from XML handling element');
        expect(vehicle.offRoadHandling, '2', reason: 'Off-road handling should be parsed from XML offroadhandling element');
        expect(vehicle.accel, '2', reason: 'Acceleration should be parsed from XML accel element');
        expect(vehicle.offRoadAccel, '1', reason: 'Off-road acceleration should be parsed from XML offroadaccel element');
        expect(vehicle.speed, '4', reason: 'Speed should be parsed from XML speed element');
        expect(vehicle.offRoadSpeed, '2', reason: 'Off-road speed should be parsed from XML offroadspeed element');
        expect(vehicle.pilot, '1', reason: 'Pilot rating should be parsed from XML pilot element');
        expect(vehicle.body, '10', reason: 'Body should be parsed from XML body element');
        expect(vehicle.seats, '4', reason: 'Seats should be parsed from XML seats element');
        expect(vehicle.armor, '6', reason: 'Armor should be parsed from XML armor element');
        expect(vehicle.sensor, '2', reason: 'Sensor should be parsed from XML sensor element');
        expect(vehicle.source, 'Core', reason: 'Source should be parsed from XML source element');
        expect(vehicle.page, '460', reason: 'Page should be parsed from XML page element');
        expect(vehicle.addSlots, '0', reason: 'Add slots should be parsed from XML addslots element');
        expect(vehicle.modSlots, '2', reason: 'Mod slots should be parsed from XML modslots element');
        expect(vehicle.powertrainModSlots, '1', reason: 'Powertrain mod slots should be parsed from XML powertrainmodslots element');
        expect(vehicle.protectionModSlots, '1', reason: 'Protection mod slots should be parsed from XML protectionmodslots element');
        expect(vehicle.weaponModSlots, '0', reason: 'Weapon mod slots should be parsed from XML weaponmodslots element');
        expect(vehicle.bodyModSlots, '0', reason: 'Body mod slots should be parsed from XML bodymodslots element');
        expect(vehicle.electromagneticModSlots, '0', reason: 'Electromagnetic mod slots should be parsed from XML electromagneticmodslots element');
        expect(vehicle.cosmeticModSlots, '1', reason: 'Cosmetic mod slots should be parsed from XML cosmeticmodslots element');
        expect(vehicle.physicalCmFilled, '0', reason: 'Physical CM filled should be parsed from XML physicalcmfilled element');
        expect(vehicle.vehicleName, 'My Car', reason: 'Vehicle name should be parsed from XML vehiclename element');
        expect(vehicle.dealerConnection, false, reason: 'Dealer connection should be parsed as false from XML dealerconnection element value "False"');
        expect(vehicle.stolen, false, reason: 'Stolen should be parsed as false from XML stolen element value "False"');
        expect(vehicle.discountedCost, false, reason: 'Discounted cost should be parsed as false from XML discountedcost element value "False"');
        expect(vehicle.active, false, reason: 'Active should be parsed as false from XML active element value "False"');
        expect(vehicle.homeNode, false, reason: 'Home node should be parsed as false from XML homenode element value "False"');
        expect(vehicle.deviceRating, '2', reason: 'Device rating should be parsed from XML devicerating element');
        expect(vehicle.mods, isEmpty, reason: 'Mods should be empty when XML mods element contains no child elements');
        expect(vehicle.weaponMounts, isEmpty, reason: 'Weapon mounts should be empty when XML weaponmounts element contains no child elements');
        expect(vehicle.gears, isEmpty, reason: 'Gears should be empty when XML gears element contains no child elements');
      });

      test('should handle missing XML elements gracefully', () {
        // Arrange
        final xmlString = '''
          <vehicle>
            <name></name>
            <category></category>
            <source></source>
            <page></page>
            <mods></mods>
            <weaponmounts></weaponmounts>
            <gears></gears>
          </vehicle>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final vehicle = Vehicle.fromXml(xmlElement);

        // Assert
        expect(vehicle.name, '', reason: 'Name should default to empty string when XML name element is empty');
        expect(vehicle.category, '', reason: 'Category should default to empty string when XML category element is empty');
        expect(vehicle.source, '', reason: 'Source should default to empty string when XML source element is empty');
        expect(vehicle.page, '', reason: 'Page should default to empty string when XML page element is empty');
        expect(vehicle.handling, '', reason: 'Handling should default to empty string when XML handling element is missing');
        expect(vehicle.pilot, '', reason: 'Pilot should default to empty string when XML pilot element is missing');
        expect(vehicle.body, '', reason: 'Body should default to empty string when XML body element is missing');
        expect(vehicle.armor, '', reason: 'Armor should default to empty string when XML armor element is missing');
        expect(vehicle.vehicleName, '', reason: 'Vehicle name should default to empty string when XML vehiclename element is missing');
        expect(vehicle.physicalCmFilled, '0', reason: 'Physical CM filled should default to "0" when XML physicalcmfilled element is missing');
        expect(vehicle.dealerConnection, false, reason: 'Dealer connection should default to false when XML dealerconnection element is missing');
        expect(vehicle.stolen, false, reason: 'Stolen should default to false when XML stolen element is missing');
        expect(vehicle.discountedCost, false, reason: 'Discounted cost should default to false when XML discountedcost element is missing');
        expect(vehicle.active, false, reason: 'Active should default to false when XML active element is missing');
        expect(vehicle.homeNode, false, reason: 'Home node should default to false when XML homenode element is missing');
        expect(vehicle.mods, isEmpty, reason: 'Mods should be empty when XML mods element is empty');
        expect(vehicle.weaponMounts, isEmpty, reason: 'Weapon mounts should be empty when XML weaponmounts element is empty');
        expect(vehicle.gears, isEmpty, reason: 'Gears should be empty when XML gears element is empty');
      });

      test('should parse boolean values correctly', () {
        // Arrange
        final xmlString = '''
          <vehicle>
            <name>Test</name>
            <category>Test</category>
            <source>Test</source>
            <page>1</page>
            <handling>1</handling>
            <offroadhandling>1</offroadhandling>
            <accel>1</accel>
            <offroadaccel>1</offroadaccel>
            <speed>1</speed>
            <offroadspeed>1</offroadspeed>
            <pilot>1</pilot>
            <body>1</body>
            <seats>1</seats>
            <armor>1</armor>
            <sensor>1</sensor>
            <addslots>0</addslots>
            <modslots>0</modslots>
            <powertrainmodslots>0</powertrainmodslots>
            <protectionmodslots>0</protectionmodslots>
            <weaponmodslots>0</weaponmodslots>
            <bodymodslots>0</bodymodslots>
            <electromagneticmodslots>0</electromagneticmodslots>
            <cosmeticmodslots>0</cosmeticmodslots>
            <physicalcmfilled>0</physicalcmfilled>
            <vehiclename>Test</vehiclename>
            <dealerconnection>True</dealerconnection>
            <stolen>True</stolen>
            <discountedcost>True</discountedcost>
            <active>True</active>
            <homenode>True</homenode>
            <canswapattributes>True</canswapattributes>
            <mods></mods>
            <weaponmounts></weaponmounts>
            <gears></gears>
          </vehicle>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final vehicle = Vehicle.fromXml(xmlElement);

        // Assert
        expect(vehicle.dealerConnection, true, reason: 'Dealer connection should be parsed as true from XML dealerconnection element value "True"');
        expect(vehicle.stolen, true, reason: 'Stolen should be parsed as true from XML stolen element value "True"');
        expect(vehicle.discountedCost, true, reason: 'Discounted cost should be parsed as true from XML discountedcost element value "True"');
        expect(vehicle.active, true, reason: 'Active should be parsed as true from XML active element value "True"');
        expect(vehicle.homeNode, true, reason: 'Home node should be parsed as true from XML homenode element value "True"');
        expect(vehicle.canSwapAttributes, true, reason: 'Can swap attributes should be parsed as true from XML canswapattributes element value "True"');
      });

      test('should parse numeric values correctly with invalid input', () {
        // Arrange
        final xmlString = '''
          <vehicle>
            <name>Test</name>
            <category>Test</category>
            <source>Test</source>
            <page>1</page>
            <handling>1</handling>
            <offroadhandling>1</offroadhandling>
            <accel>1</accel>
            <offroadaccel>1</offroadaccel>
            <speed>1</speed>
            <offroadspeed>1</offroadspeed>
            <pilot>1</pilot>
            <body>1</body>
            <seats>1</seats>
            <armor>1</armor>
            <sensor>1</sensor>
            <addslots>0</addslots>
            <modslots>0</modslots>
            <powertrainmodslots>0</powertrainmodslots>
            <protectionmodslots>0</protectionmodslots>
            <weaponmodslots>0</weaponmodslots>
            <bodymodslots>0</bodymodslots>
            <electromagneticmodslots>0</electromagneticmodslots>
            <cosmeticmodslots>0</cosmeticmodslots>
            <physicalcmfilled>0</physicalcmfilled>
            <vehiclename>Test</vehiclename>
            <dealerconnection>False</dealerconnection>
            <sortorder>invalid</sortorder>
            <matrixcmfilled>invalid</matrixcmfilled>
            <mods></mods>
            <weaponmounts></weaponmounts>
            <gears></gears>
          </vehicle>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final vehicle = Vehicle.fromXml(xmlElement);

        // Assert
        expect(vehicle.sortOrder, 0, reason: 'Sort order should default to 0 when XML sortorder element contains invalid text "invalid"');
        expect(vehicle.matrixCmFilled, 0, reason: 'Matrix CM filled should default to 0 when XML matrixcmfilled element contains invalid text "invalid"');
      });

      test('should handle null XML element', () {
        // Arrange
        final xmlString = '''
          <vehicle>
            <mods></mods>
            <weaponmounts></weaponmounts>
            <gears></gears>
          </vehicle>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final vehicle = Vehicle.fromXml(xmlElement);

        // Assert
        expect(vehicle.name, '', reason: 'Name should default to empty string when XML name element is missing');
        expect(vehicle.category, '', reason: 'Category should default to empty string when XML category element is missing');
        expect(vehicle.source, '', reason: 'Source should default to empty string when XML source element is missing');
        expect(vehicle.page, '', reason: 'Page should default to empty string when XML page element is missing');
        expect(vehicle.vehicleName, '', reason: 'Vehicle name should default to empty string when XML vehiclename element is missing');
        expect(vehicle.physicalCmFilled, '0', reason: 'Physical CM filled should default to "0" when XML physicalcmfilled element is missing');
        expect(vehicle.mods, isEmpty, reason: 'Mods should be empty when XML mods element is empty');
        expect(vehicle.weaponMounts, isEmpty, reason: 'Weapon mounts should be empty when XML weaponmounts element is empty');
        expect(vehicle.gears, isEmpty, reason: 'Gears should be empty when XML gears element is empty');
      });
    });
  });
}
