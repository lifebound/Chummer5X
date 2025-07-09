import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/shadowrun_character.dart';

void main() {
  group('Attribute Filtering Tests', () {
    test('should filter out MAGAdept attribute regardless of flags', () {
      final attributes = [
        const Attribute(
          name: 'MAGAdept',
          metatypeCategory: 'Special',
          totalValue: 6,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 6,
          karma: 0,
        ),
        const Attribute(
          name: 'BOD',
          metatypeCategory: 'Standard',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 0,
        ),
      ];

      // Simulate the filtering logic from AttributesCard
      bool shouldDisplayAttribute(Attribute attr, bool magEnabled, bool resEnabled, bool depEnabled) {
        if (attr.name == 'MAGAdept') return false;
        if (attr.name == 'DEP' && !depEnabled) return false;
        if (attr.name == 'MAG' && !magEnabled) return false;
        if (attr.name == 'RES' && !resEnabled) return false;
        return true;
      }

      // Even with magic enabled, MAGAdept should be hidden
      final filteredAttributes = attributes.where((attr) => shouldDisplayAttribute(attr, true, false, false)).toList();
      
      expect(filteredAttributes.length, 1);
      expect(filteredAttributes.first.name, 'BOD');
      expect(filteredAttributes.any((attr) => attr.name == 'MAGAdept'), false);
    });

    test('should show MAG attribute only when magEnabled is true', () {
      final attributes = [
        const Attribute(
          name: 'MAG',
          metatypeCategory: 'Special',
          totalValue: 6,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 6,
          karma: 0,
        ),
        const Attribute(
          name: 'BOD',
          metatypeCategory: 'Standard',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 0,
        ),
      ];

      bool shouldDisplayAttribute(Attribute attr, bool magEnabled, bool resEnabled, bool depEnabled) {
        if (attr.name == 'MAGAdept') return false;
        if (attr.name == 'DEP' && !depEnabled) return false;
        if (attr.name == 'MAG' && !magEnabled) return false;
        if (attr.name == 'RES' && !resEnabled) return false;
        return true;
      }

      // Test with magEnabled = false
      final filteredNoMag = attributes.where((attr) => shouldDisplayAttribute(attr, false, false, false)).toList();
      expect(filteredNoMag.length, 1);
      expect(filteredNoMag.first.name, 'BOD');

      // Test with magEnabled = true
      final filteredWithMag = attributes.where((attr) => shouldDisplayAttribute(attr, true, false, false)).toList();
      expect(filteredWithMag.length, 2);
      expect(filteredWithMag.any((attr) => attr.name == 'MAG'), true);
      expect(filteredWithMag.any((attr) => attr.name == 'BOD'), true);
    });

    test('should show RES attribute only when resEnabled is true', () {
      final attributes = [
        const Attribute(
          name: 'RES',
          metatypeCategory: 'Special',
          totalValue: 6,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 6,
          karma: 0,
        ),
        const Attribute(
          name: 'BOD',
          metatypeCategory: 'Standard',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 0,
        ),
      ];

      bool shouldDisplayAttribute(Attribute attr, bool magEnabled, bool resEnabled, bool depEnabled) {
        if (attr.name == 'MAGAdept') return false;
        if (attr.name == 'DEP' && !depEnabled) return false;
        if (attr.name == 'MAG' && !magEnabled) return false;
        if (attr.name == 'RES' && !resEnabled) return false;
        return true;
      }

      // Test with resEnabled = false
      final filteredNoRes = attributes.where((attr) => shouldDisplayAttribute(attr, false, false, false)).toList();
      expect(filteredNoRes.length, 1);
      expect(filteredNoRes.first.name, 'BOD');

      // Test with resEnabled = true
      final filteredWithRes = attributes.where((attr) => shouldDisplayAttribute(attr, false, true, false)).toList();
      expect(filteredWithRes.length, 2);
      expect(filteredWithRes.any((attr) => attr.name == 'RES'), true);
      expect(filteredWithRes.any((attr) => attr.name == 'BOD'), true);
    });

    test('should show DEP attribute only when depEnabled is true', () {
      final attributes = [
        const Attribute(
          name: 'DEP',
          metatypeCategory: 'Special',
          totalValue: 6,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 6,
          karma: 0,
        ),
        const Attribute(
          name: 'BOD',
          metatypeCategory: 'Standard',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 0,
        ),
      ];

      bool shouldDisplayAttribute(Attribute attr, bool magEnabled, bool resEnabled, bool depEnabled) {
        if (attr.name == 'MAGAdept') return false;
        if (attr.name == 'DEP' && !depEnabled) return false;
        if (attr.name == 'MAG' && !magEnabled) return false;
        if (attr.name == 'RES' && !resEnabled) return false;
        return true;
      }

      // Test with depEnabled = false
      final filteredNoDep = attributes.where((attr) => shouldDisplayAttribute(attr, false, false, false)).toList();
      expect(filteredNoDep.length, 1);
      expect(filteredNoDep.first.name, 'BOD');

      // Test with depEnabled = true
      final filteredWithDep = attributes.where((attr) => shouldDisplayAttribute(attr, false, false, true)).toList();
      expect(filteredWithDep.length, 2);
      expect(filteredWithDep.any((attr) => attr.name == 'DEP'), true);
      expect(filteredWithDep.any((attr) => attr.name == 'BOD'), true);
    });
  });
}
