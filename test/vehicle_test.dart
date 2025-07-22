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
        cost: '45000',
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
      expect(vehicle.name, 'Ares Roadmaster');
      expect(vehicle.category, 'Truck');
      expect(vehicle.source, 'Core');
      expect(vehicle.page, '462');
      expect(vehicle.handling, '5');
      expect(vehicle.offRoadHandling, '4');
      expect(vehicle.accel, '2');
      expect(vehicle.offRoadAccel, '1');
      expect(vehicle.speed, '4');
      expect(vehicle.offRoadSpeed, '3');
      expect(vehicle.pilot, '1');
      expect(vehicle.body, '16');
      expect(vehicle.seats, '8');
      expect(vehicle.armor, '12');
      expect(vehicle.sensor, '2');
      expect(vehicle.addSlots, '0');
      expect(vehicle.modSlots, '3');
      expect(vehicle.powertrainModSlots, '1');
      expect(vehicle.protectionModSlots, '1');
      expect(vehicle.weaponModSlots, '1');
      expect(vehicle.bodyModSlots, '0');
      expect(vehicle.electromagneticModSlots, '0');
      expect(vehicle.cosmeticModSlots, '0');
      expect(vehicle.physicalCmFilled, '0');
      expect(vehicle.vehicleName, 'My Roadmaster');
      expect(vehicle.dealerConnection, false);
      expect(vehicle.mods, isEmpty);
      expect(vehicle.weaponMounts, isEmpty);
      expect(vehicle.gears, isEmpty);
      expect(vehicle.weapons, isNull);
      expect(vehicle.equipped, true); // Default from constructor
      expect(vehicle.wirelessOn, false); // Default from constructor
      expect(vehicle.canFormPersona, false); // Default from constructor
      expect(vehicle.matrixCmBonus, 0); // Default from constructor
    });

    test('should create Vehicle with optional parameters', () {
      // Arrange
      final mockGear = Gear(
        name: 'Test Gear',
        category: 'Electronics',
        source: 'Core',
        page: '1',
      );

      // Act
      final vehicle = Vehicle(
        sourceId: 'test-id',
        locationGuid: 'test-guid',
        name: 'Custom Vehicle',
        category: 'Car',
        avail: '12F',
        cost: '80000',
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
      expect(vehicle.name, 'Custom Vehicle');
      expect(vehicle.category, 'Car');
      expect(vehicle.source, 'Data Trails');
      expect(vehicle.page, '234');
      expect(vehicle.stolen, true);
      expect(vehicle.discountedCost, true);
      expect(vehicle.active, true);
      expect(vehicle.homeNode, true);
      expect(vehicle.dealerConnection, true);
      expect(vehicle.programLimit, '5');
      expect(vehicle.overclocked, '1');
      expect(vehicle.attack, '4');
      expect(vehicle.sleaze, '5');
      expect(vehicle.dataProcessing, '6');
      expect(vehicle.firewall, '7');
      expect(vehicle.attributeArray, ['A', 'S', 'D', 'F']);
      expect(vehicle.modAttack, '1');
      expect(vehicle.modSleaze, '1');
      expect(vehicle.modDataProcessing, '1');
      expect(vehicle.modFirewall, '1');
      expect(vehicle.modAttributeArray, ['MA', 'MS', 'MD', 'MF']);
      expect(vehicle.canSwapAttributes, true);
      expect(vehicle.gears, hasLength(1));
      expect(vehicle.gears.first.name, 'Test Gear');
      expect(vehicle.weapons, hasLength(0));
      expect(vehicle.notes, 'Custom notes');
      expect(vehicle.notesColor, 'red');
      expect(vehicle.deviceRating, '4');
      expect(vehicle.matrixCmFilled, 2);
    });

    group('fromXmlElement', () {
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
        final vehicle = Vehicle.fromXmlElement(xmlElement);

        // Assert
        expect(vehicle.sourceId, 'test-source');
        expect(vehicle.locationGuid, 'test-guid');
        expect(vehicle.name, 'Basic Vehicle');
        expect(vehicle.category, 'Car');
        expect(vehicle.handling, '4');
        expect(vehicle.offRoadHandling, '2');
        expect(vehicle.accel, '2');
        expect(vehicle.offRoadAccel, '1');
        expect(vehicle.speed, '4');
        expect(vehicle.offRoadSpeed, '2');
        expect(vehicle.pilot, '1');
        expect(vehicle.body, '10');
        expect(vehicle.seats, '4');
        expect(vehicle.armor, '6');
        expect(vehicle.sensor, '2');
        expect(vehicle.source, 'Core');
        expect(vehicle.page, '460');
        expect(vehicle.addSlots, '0');
        expect(vehicle.modSlots, '2');
        expect(vehicle.powertrainModSlots, '1');
        expect(vehicle.protectionModSlots, '1');
        expect(vehicle.weaponModSlots, '0');
        expect(vehicle.bodyModSlots, '0');
        expect(vehicle.electromagneticModSlots, '0');
        expect(vehicle.cosmeticModSlots, '1');
        expect(vehicle.physicalCmFilled, '0');
        expect(vehicle.vehicleName, 'My Car');
        expect(vehicle.dealerConnection, false);
        expect(vehicle.stolen, false);
        expect(vehicle.discountedCost, false);
        expect(vehicle.active, false);
        expect(vehicle.homeNode, false);
        expect(vehicle.deviceRating, '2');
        expect(vehicle.mods, isEmpty);
        expect(vehicle.weaponMounts, isEmpty);
        expect(vehicle.gears, isEmpty);
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
        final vehicle = Vehicle.fromXmlElement(xmlElement);

        // Assert
        expect(vehicle.name, '');
        expect(vehicle.category, '');
        expect(vehicle.source, '');
        expect(vehicle.page, '');
        expect(vehicle.handling, '');
        expect(vehicle.pilot, '');
        expect(vehicle.body, '');
        expect(vehicle.armor, '');
        expect(vehicle.vehicleName, '');
        expect(vehicle.physicalCmFilled, '0');
        expect(vehicle.dealerConnection, false);
        expect(vehicle.stolen, false);
        expect(vehicle.discountedCost, false);
        expect(vehicle.active, false);
        expect(vehicle.homeNode, false);
        expect(vehicle.mods, isEmpty);
        expect(vehicle.weaponMounts, isEmpty);
        expect(vehicle.gears, isEmpty);
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
        final vehicle = Vehicle.fromXmlElement(xmlElement);

        // Assert
        expect(vehicle.dealerConnection, true);
        expect(vehicle.stolen, true);
        expect(vehicle.discountedCost, true);
        expect(vehicle.active, true);
        expect(vehicle.homeNode, true);
        expect(vehicle.canSwapAttributes, true);
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
        final vehicle = Vehicle.fromXmlElement(xmlElement);

        // Assert
        expect(vehicle.sortOrder, 0);
        expect(vehicle.matrixCmFilled, 0);
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
        final vehicle = Vehicle.fromXmlElement(xmlElement);

        // Assert
        expect(vehicle.name, '');
        expect(vehicle.category, '');
        expect(vehicle.source, '');
        expect(vehicle.page, '');
        expect(vehicle.vehicleName, '');
        expect(vehicle.physicalCmFilled, '0');
        expect(vehicle.mods, isEmpty);
        expect(vehicle.weaponMounts, isEmpty);
        expect(vehicle.gears, isEmpty);
      });
    });
  });
}
