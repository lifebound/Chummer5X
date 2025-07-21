import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/weapon.dart';
import 'package:chummer5x/models/items/vehicle_mod.dart';
import 'package:chummer5x/models/items/weapon_mount_option.dart';

class WeaponMount {
  final String sourceId;
  final String guid;
  final String name;
  final String category;
  final String? limit;
  final String slots;
  final String avail;
  final String cost;
  final bool freeCost;
  final String markup;
  final String? extra;
  final String source;
  final String page;
  final bool included;
  final bool equipped;
  final String weaponMountCategories;
  final String weaponCapacity;
  final List<Weapon>? weapons; // Reusing the Weapon class
  final List<WeaponMountOption> weaponMountOptions;
  final List<VehicleMod> mods; // Assuming <mods> here would contain VehicleMod
  final String? notes;
  final String? notesColor;
  final bool discountedCost;
  final String sortOrder;
  final bool stolen;

  WeaponMount({
    required this.sourceId,
    required this.guid,
    required this.name,
    required this.category,
    this.limit,
    required this.slots,
    required this.avail,
    required this.cost,
    required this.freeCost,
    required this.markup,
    this.extra,
    required this.source,
    required this.page,
    required this.included,
    required this.equipped,
    required this.weaponMountCategories,
    required this.weaponCapacity,
    required this.weapons,
    required this.weaponMountOptions,
    required this.mods,
    this.notes,
    this.notesColor,
    required this.discountedCost,
    required this.sortOrder,
    required this.stolen,
  });

  factory WeaponMount.fromXmlElement(XmlElement element) {
    return WeaponMount(
      sourceId: element.getElement('sourceid')?.innerText ?? '',
      guid: element.getElement('guid')?.innerText ?? '',
      name: element.getElement('name')?.innerText ?? '',
      category: element.getElement('category')?.innerText ?? '',
      limit: element.getElement('limit')?.innerText,
      slots: element.getElement('slots')?.innerText ?? '',
      avail: element.getElement('avail')?.innerText ?? '',
      cost: element.getElement('cost')?.innerText ?? '',
      freeCost: element.getElement('freecost')?.innerText == 'True',
      markup: element.getElement('markup')?.innerText ?? '0',
      extra: element.getElement('extra')?.innerText,
      source: element.getElement('source')?.innerText ?? '',
      page: element.getElement('page')?.innerText ?? '',
      included: element.getElement('included')?.innerText == 'True',
      equipped: element.getElement('equipped')?.innerText == 'True',
      weaponMountCategories: element.getElement('weaponmountcategories')?.innerText ?? '',
      weaponCapacity: element.getElement('weaponcapacity')?.innerText ?? '0',
      weapons: element.getElement('weapons')?.findAllElements('weapon').map((e) => Weapon.fromXml(e)).toList() ?? [],
      weaponMountOptions: element.getElement('weaponmountoptions')?.findAllElements('weaponmountoption').map((e) => WeaponMountOption.fromXmlElement(e)).toList() ?? [],
      mods: element.getElement('mods')?.findAllElements('mod').map((e) => VehicleMod.fromXmlElement(e)).toList() ?? [],
      notes: element.getElement('notes')?.innerText,
      notesColor: element.getElement('notesColor')?.innerText,
      discountedCost: element.getElement('discountedcost')?.innerText == 'True',
      sortOrder: element.getElement('sortorder')?.innerText ?? '0',
      stolen: element.getElement('stolen')?.innerText == 'True',
    );
  }
}