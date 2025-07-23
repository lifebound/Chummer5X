import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';

// Concrete implementation of ShadowrunItem for testing purposes
class TestShadowrunItem extends ShadowrunItem {
  TestShadowrunItem({
    super.sourceId,
    super.locationGuid,
    required super.name,
    required super.category,
    required super.source,
    required super.page,
    super.equipped,
    super.active,
    super.homeNode,
    super.deviceRating,
    super.programLimit,
    super.overclocked,
    super.attack,
    super.sleaze,
    super.dataProcessing,
    super.firewall,
    super.attributeArray,
    super.modAttack,
    super.modSleaze,
    super.modDataProcessing,
    super.modFirewall,
    super.modAttributeArray,
    super.canSwapAttributes,
    super.matrixCmFilled,
    super.matrixCmBonus,
    super.wirelessOn,
    super.canFormPersona,
    super.notes,
    super.notesColor,
    super.discountedCost,
    super.sortOrder,
    super.stolen,
    required super.avail,
    super.cost = 0,
  });

  factory TestShadowrunItem.fromXml(XmlElement xmlElement) {
    return TestShadowrunItem(
      name: xmlElement.getElement('name')?.innerText ?? 'Test Item',
      category: xmlElement.getElement('category')?.innerText ?? 'Test Category',
      source: xmlElement.getElement('source')?.innerText ?? 'Test Source',
      page: xmlElement.getElement('page')?.innerText ?? '0',
      avail: xmlElement.getElement('avail')?.innerText ?? '0',
    );
  }
}

void main() {
  group('ShadowrunItem', () {
    test('should create ShadowrunItem with required parameters', () {
      // Arrange & Act
      final item = TestShadowrunItem(
        name: 'Test Item',
        category: 'Test Category',
        source: 'Test Source',
        page: '100',
        avail: '5R',
      );

      // Assert
      expect(item.name, 'Test Item');
      expect(item.category, 'Test Category');
      expect(item.source, 'Test Source');
      expect(item.page, '100');
      expect(item.avail, '5R');
      
      // Check defaults
      expect(item.sourceId, null);
      expect(item.locationGuid, null);
      expect(item.equipped, false);
      expect(item.active, false);
      expect(item.homeNode, false);
      expect(item.deviceRating, null);
      expect(item.programLimit, null);
      expect(item.overclocked, null);
      expect(item.attack, null);
      expect(item.sleaze, null);
      expect(item.dataProcessing, null);
      expect(item.firewall, null);
      expect(item.attributeArray, null);
      expect(item.modAttack, null);
      expect(item.modSleaze, null);
      expect(item.modDataProcessing, null);
      expect(item.modFirewall, null);
      expect(item.modAttributeArray, null);
      expect(item.canSwapAttributes, false);
      expect(item.matrixCmFilled, 0);
      expect(item.matrixCmBonus, 0);
      expect(item.wirelessOn, false);
      expect(item.canFormPersona, null);
      expect(item.notes, null);
      expect(item.notesColor, null);
      expect(item.discountedCost, false);
      expect(item.sortOrder, 0);
      expect(item.stolen, false);
    });

    test('should create ShadowrunItem with all optional parameters', () {
      // Arrange & Act
      final item = TestShadowrunItem(
        sourceId: 'test-source',
        locationGuid: 'test-guid',
        name: 'Advanced Item',
        category: 'Advanced Category',
        source: 'Advanced Source',
        page: '200',
        equipped: true,
        active: true,
        homeNode: true,
        deviceRating: '6',
        programLimit: '4',
        overclocked: '2',
        attack: '8',
        sleaze: '7',
        dataProcessing: '9',
        firewall: '6',
        attributeArray: ['A', 'S', 'D', 'F'],
        modAttack: '2',
        modSleaze: '1',
        modDataProcessing: '3',
        modFirewall: '2',
        modAttributeArray: ['MA', 'MS', 'MD', 'MF'],
        canSwapAttributes: true,
        matrixCmFilled: 3,
        matrixCmBonus: 2,
        wirelessOn: true,
        canFormPersona: true,
        notes: 'Test notes',
        notesColor: 'blue',
        discountedCost: true,
        sortOrder: 5,
        stolen: true,
        avail: '12F',
      );

      // Assert
      expect(item.sourceId, 'test-source');
      expect(item.locationGuid, 'test-guid');
      expect(item.name, 'Advanced Item');
      expect(item.category, 'Advanced Category');
      expect(item.source, 'Advanced Source');
      expect(item.page, '200');
      expect(item.equipped, true);
      expect(item.active, true);
      expect(item.homeNode, true);
      expect(item.deviceRating, '6');
      expect(item.programLimit, '4');
      expect(item.overclocked, '2');
      expect(item.attack, '8');
      expect(item.sleaze, '7');
      expect(item.dataProcessing, '9');
      expect(item.firewall, '6');
      expect(item.attributeArray, ['A', 'S', 'D', 'F']);
      expect(item.modAttack, '2');
      expect(item.modSleaze, '1');
      expect(item.modDataProcessing, '3');
      expect(item.modFirewall, '2');
      expect(item.modAttributeArray, ['MA', 'MS', 'MD', 'MF']);
      expect(item.canSwapAttributes, true);
      expect(item.matrixCmFilled, 3);
      expect(item.matrixCmBonus, 2);
      expect(item.wirelessOn, true);
      expect(item.canFormPersona, true);
      expect(item.notes, 'Test notes');
      expect(item.notesColor, 'blue');
      expect(item.discountedCost, true);
      expect(item.sortOrder, 5);
      expect(item.stolen, true);
      expect(item.avail, '12F');
    });

    test('should throw UnimplementedError when calling base fromXml', () {
      // Arrange
      final xmlString = '''
        <item>
          <name>Test</name>
        </item>
      ''';
      final xmlElement = XmlDocument.parse(xmlString).rootElement;

      // Act & Assert
      expect(() => ShadowrunItem.fromXml(xmlElement), throwsUnimplementedError);
    });

    group('fromXml implementation in concrete class', () {
      test('should parse basic XML correctly', () {
        // Arrange
        final xmlString = '''
          <item>
            <name>Basic Item</name>
            <category>Basic Category</category>
            <source>Basic Source</source>
            <page>50</page>
            <avail>3R</avail>
          </item>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final item = TestShadowrunItem.fromXml(xmlElement);

        // Assert
        expect(item.name, 'Basic Item');
        expect(item.category, 'Basic Category');
        expect(item.source, 'Basic Source');
        expect(item.page, '50');
        expect(item.avail, '3R');
      });

      test('should handle missing XML elements gracefully', () {
        // Arrange
        final xmlString = '''
          <item>
          </item>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final item = TestShadowrunItem.fromXml(xmlElement);

        // Assert
        expect(item.name, 'Test Item');
        expect(item.category, 'Test Category');
        expect(item.source, 'Test Source');
        expect(item.page, '0');
        expect(item.avail, '0');
      });
    });
  });
}
