import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/weapon_mount_option.dart';

void main() {
  group('WeaponMountOption', () {
    test('should create WeaponMountOption with required parameters', () {
      // Arrange & Act
      final option = WeaponMountOption(
        sourceId: 'test-source',
        guid: 'test-guid',
        name: 'Gyroscopic Stabilization',
        category: 'Weapon Mount Options',
        slots: '1',
        avail: '8R',
        cost: '5000',
        includedInParent: false,
      );

      // Assert
      expect(option.sourceId, 'test-source');
      expect(option.guid, 'test-guid');
      expect(option.name, 'Gyroscopic Stabilization');
      expect(option.category, 'Weapon Mount Options');
      expect(option.slots, '1');
      expect(option.avail, '8R');
      expect(option.cost, '5000');
      expect(option.includedInParent, false);
    });

    test('should create WeaponMountOption with includedInParent true', () {
      // Arrange & Act
      final option = WeaponMountOption(
        sourceId: 'included-source',
        guid: 'included-guid',
        name: 'Standard Targeting',
        category: 'Weapon Mount Options',
        slots: '0',
        avail: '4R',
        cost: '0',
        includedInParent: true,
      );

      // Assert
      expect(option.sourceId, 'included-source');
      expect(option.guid, 'included-guid');
      expect(option.name, 'Standard Targeting');
      expect(option.category, 'Weapon Mount Options');
      expect(option.slots, '0');
      expect(option.avail, '4R');
      expect(option.cost, '0');
      expect(option.includedInParent, true);
    });

    group('fromXml', () {
      test('should parse minimal XML correctly', () {
        // Arrange
        final xmlString = '''
          <weaponmountoption>
            <sourceid>basic-source</sourceid>
            <guid>basic-guid</guid>
            <name>Basic Option</name>
            <category>Weapon Mount Options</category>
            <slots>1</slots>
            <avail>4R</avail>
            <cost>2000</cost>
            <includedinparent>False</includedinparent>
          </weaponmountoption>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final option = WeaponMountOption.fromXml(xmlElement);

        // Assert
        expect(option.sourceId, 'basic-source');
        expect(option.guid, 'basic-guid');
        expect(option.name, 'Basic Option');
        expect(option.category, 'Weapon Mount Options');
        expect(option.slots, '1');
        expect(option.avail, '4R');
        expect(option.cost, '2000');
        expect(option.includedInParent, false);
      });

      test('should parse complete XML correctly', () {
        // Arrange
        final xmlString = '''
          <weaponmountoption>
            <sourceid>complete-source</sourceid>
            <guid>complete-guid</guid>
            <name>Advanced Targeting System</name>
            <category>Electronic Systems</category>
            <slots>2</slots>
            <avail>12F</avail>
            <cost>15000</cost>
            <includedinparent>True</includedinparent>
          </weaponmountoption>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final option = WeaponMountOption.fromXml(xmlElement);

        // Assert
        expect(option.sourceId, 'complete-source');
        expect(option.guid, 'complete-guid');
        expect(option.name, 'Advanced Targeting System');
        expect(option.category, 'Electronic Systems');
        expect(option.slots, '2');
        expect(option.avail, '12F');
        expect(option.cost, '15000');
        expect(option.includedInParent, true);
      });

      test('should handle missing XML elements gracefully', () {
        // Arrange
        final xmlString = '''
          <weaponmountoption>
          </weaponmountoption>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final option = WeaponMountOption.fromXml(xmlElement);

        // Assert
        expect(option.sourceId, '');
        expect(option.guid, '');
        expect(option.name, '');
        expect(option.category, '');
        expect(option.slots, '0');
        expect(option.avail, '');
        expect(option.cost, '');
        expect(option.includedInParent, false);
      });

      test('should parse boolean values correctly', () {
        // Arrange
        final xmlString = '''
          <weaponmountoption>
            <sourceid>bool-test</sourceid>
            <guid>bool-guid</guid>
            <name>Boolean Test</name>
            <category>Test</category>
            <slots>1</slots>
            <avail>1</avail>
            <cost>1</cost>
            <includedinparent>True</includedinparent>
          </weaponmountoption>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final option = WeaponMountOption.fromXml(xmlElement);

        // Assert
        expect(option.includedInParent, true);
      });

      test('should handle false boolean correctly', () {
        // Arrange
        final xmlString = '''
          <weaponmountoption>
            <sourceid>bool-false-test</sourceid>
            <guid>bool-false-guid</guid>
            <name>Boolean False Test</name>
            <category>Test</category>
            <slots>1</slots>
            <avail>1</avail>
            <cost>1</cost>
            <includedinparent>False</includedinparent>
          </weaponmountoption>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final option = WeaponMountOption.fromXml(xmlElement);

        // Assert
        expect(option.includedInParent, false);
      });

      test('should handle various slot values', () {
        // Arrange
        final xmlString = '''
          <weaponmountoption>
            <sourceid>slot-test</sourceid>
            <guid>slot-guid</guid>
            <name>Slot Test</name>
            <category>Test</category>
            <slots>5</slots>
            <avail>1</avail>
            <cost>1</cost>
            <includedinparent>False</includedinparent>
          </weaponmountoption>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final option = WeaponMountOption.fromXml(xmlElement);

        // Assert
        expect(option.slots, '5');
      });

      test('should handle various availability formats', () {
        // Arrange
        final xmlString = '''
          <weaponmountoption>
            <sourceid>avail-test</sourceid>
            <guid>avail-guid</guid>
            <name>Availability Test</name>
            <category>Test</category>
            <slots>1</slots>
            <avail>20F</avail>
            <cost>50000</cost>
            <includedinparent>False</includedinparent>
          </weaponmountoption>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final option = WeaponMountOption.fromXml(xmlElement);

        // Assert
        expect(option.avail, '20F');
      });

      test('should handle various cost formats', () {
        // Arrange
        final xmlString = '''
          <weaponmountoption>
            <sourceid>cost-test</sourceid>
            <guid>cost-guid</guid>
            <name>Cost Test</name>
            <category>Test</category>
            <slots>1</slots>
            <avail>1</avail>
            <cost>Variable</cost>
            <includedinparent>False</includedinparent>
          </weaponmountoption>
        ''';
        final xmlElement = XmlDocument.parse(xmlString).rootElement;

        // Act
        final option = WeaponMountOption.fromXml(xmlElement);

        // Assert
        expect(option.cost, 'Variable');
      });
    });
  });
}
