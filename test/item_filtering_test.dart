import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:chummer5x/models/items/gear.dart';
import 'package:chummer5x/models/items/armor.dart';
import 'package:chummer5x/models/items/weapon.dart';

void main() {
  group('Item Filtering Tests', () {
    late List<Gear> gearItems;
    late List<Armor> armorItems;
    late List<Weapon> weaponItems;

    setUp(() {
      // Create test gear items (simplified to avoid complex constructors)
      gearItems = [
        Gear(
          name: 'Commlink Alpha',
          category: 'Commlinks',
          source: 'Core',
          page: '120',
          avail: '2',
          cost: 1000,
        ),
        Gear(
          name: 'Medkit',
          category: 'Medical',
          source: 'Core',
          page: '130',
          avail: '1',
          cost: 200,
        ),
      ];

      // Create test armor items (simplified)
      armorItems = [
        Armor(
          name: 'Armor Vest',
          category: 'Armor',
          source: 'Core',
          page: '140',
          armorValue: '6',
          armorCapacity: '2',
          avail: '2',
          cost: 500,
          damage: 0,
          rating: 0,
          maxRating: 0,
          ratingLabel: '',
          encumbrance: false,
        ),
      ];

      // Create test weapon items (simplified)
      weaponItems = [
        Weapon(
          name: 'Ares Predator V',
          category: 'Heavy Pistols',
          source: 'Core',
          page: '150',
          type: 'Ranged',
          reach: 0,
          damage: '8P',
          ap: '-1',
          mode: 'SA',
          rc: 0,
          ammo: '15(c)',
          cyberware: false,
          ammoSlots: 0,
          firingMode: 'SA',
          rating: 0,
          accuracy: '5',
          activeAmmoSlot: 0,
          conceal: '+1',
          rangeMultiply: 1,
          singleShot: 0,
          shortBurst: 0,
          longBurst: 0,
          fullBurst: 0,
          suppressive: 0,
          allowSingleShot: true,
          allowShortBurst: false,
          allowLongBurst: false,
          allowFullBurst: false,
          allowSuppressive: false,
          allowAccessory: true,
          included: false,
          requireAmmo: true,
          avail: '5R',
          cost: 725,
        ),
      ];
    });

    test('Gear.matchesSearch should find items by name', () {
      final result = gearItems[0].matchesSearch('commlink');
      expect(result, isTrue);
    });

    test('Gear.matchesSearch should find items by category', () {
      final result = gearItems[0].matchesSearch('commlinks');
      expect(result, isTrue);
    });

    test('ShadowrunItem.filterItems should return matching items', () {
      final result = ShadowrunItem.filterItems(gearItems, 'commlink');
      expect(result.length, equals(1));
      expect(result[0].name, equals('Commlink Alpha'));
    });

    test('Armor filtering should return matching items', () {
      final result = ShadowrunItem.filterItems(armorItems, 'vest');
      expect(result.length, equals(1));
      expect(result[0].name, equals('Armor Vest'));
    });

    test('Weapon filtering should return matching items', () {
      final result = ShadowrunItem.filterItems(weaponItems, 'predator');
      expect(result.length, equals(1));
      expect(result[0].name, equals('Ares Predator V'));
    });

    test('Base ShadowrunItem.matchesSearch should work for basic matching', () {
      final result = gearItems[0].matchesSearch('alpha');
      expect(result, isTrue);
    });

    test('Base ShadowrunItem.filterItems should work for basic filtering', () {
      final result = ShadowrunItem.filterItems(gearItems, 'medkit');
      expect(result.length, equals(1));
      expect(result[0].name, equals('Medkit'));
    });

    test('Filtering should be case insensitive', () {
      final result = gearItems[0].matchesSearch('COMMLINK');
      expect(result, isTrue);
    });

    test('Empty query should return all items', () {
      final result = ShadowrunItem.filterItems(gearItems, '');
      expect(result.length, equals(gearItems.length));
    });

    test('No matches should return empty list', () {
      final result = ShadowrunItem.filterItems(gearItems, 'nonexistent');
      expect(result.length, equals(0));
    });
  });
}
