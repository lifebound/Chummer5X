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

  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    final String lowerQuery = query.toLowerCase();
    
    // Check basic fields
    if (name.toLowerCase().contains(lowerQuery) ||
        category.toLowerCase().contains(lowerQuery) ||
        (extra?.toLowerCase().contains(lowerQuery) ?? false)) {
      return true;
    }
    
    // Check nested weapons
    if (weapons?.any((weapon) => weapon.matchesSearch(query)) ?? false) {
      return true;
    }
    
    // Check nested mods
    if (mods.any((mod) => mod.matchesSearch(query))) {
      return true;
    }
    
    // Check weapon mount options
    return weaponMountOptions.any((option) => 
        option.name.toLowerCase().contains(lowerQuery)
    );
  }

  WeaponMount copyWith({
    String? sourceId,
    String? guid,
    String? name,
    String? category,
    String? limit,
    String? slots,
    String? avail,
    String? cost,
    bool? freeCost,
    String? markup,
    String? extra,
    String? source,
    String? page,
    bool? included,
    bool? equipped,
    String? weaponMountCategories,
    String? weaponCapacity,
    List<Weapon>? weapons,
    List<WeaponMountOption>? weaponMountOptions,
    List<VehicleMod>? mods,
    String? notes,
    String? notesColor,
    bool? discountedCost,
    String? sortOrder,
    bool? stolen,
  }) {
    return WeaponMount(
      sourceId: sourceId ?? this.sourceId,
      guid: guid ?? this.guid,
      name: name ?? this.name,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      slots: slots ?? this.slots,
      avail: avail ?? this.avail,
      cost: cost ?? this.cost,
      freeCost: freeCost ?? this.freeCost,
      markup: markup ?? this.markup,
      extra: extra ?? this.extra,
      source: source ?? this.source,
      page: page ?? this.page,
      included: included ?? this.included,
      equipped: equipped ?? this.equipped,
      weaponMountCategories: weaponMountCategories ?? this.weaponMountCategories,
      weaponCapacity: weaponCapacity ?? this.weaponCapacity,
      weapons: weapons ?? this.weapons,
      weaponMountOptions: weaponMountOptions ?? this.weaponMountOptions,
      mods: mods ?? this.mods,
      notes: notes ?? this.notes,
      notesColor: notesColor ?? this.notesColor,
      discountedCost: discountedCost ?? this.discountedCost,
      sortOrder: sortOrder ?? this.sortOrder,
      stolen: stolen ?? this.stolen,
    );
  }

  WeaponMount? filterWithHierarchy(String query) {
    if (query.isEmpty) return this;
    
    // Filter nested collections
    final filteredWeapons = weapons
        ?.map((weapon) => weapon.filterWithHierarchy(query))
        .where((weapon) => weapon != null)
        .cast<Weapon>()
        .toList();
    
    final filteredMods = mods
        .map((mod) => mod.filterWithHierarchy(query))
        .where((mod) => mod != null)
        .cast<VehicleMod>()
        .toList();
    
    final filteredOptions = weaponMountOptions
        .where((option) => option.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    
    // Include this mount if it matches OR if it has any matching nested items
    if (matchesSearch(query) || 
        (filteredWeapons?.isNotEmpty ?? false) || 
        filteredMods.isNotEmpty || 
        filteredOptions.isNotEmpty) {
      return copyWith(
        weapons: filteredWeapons,
        mods: filteredMods,
        weaponMountOptions: filteredOptions,
      );
    }
    
    return null;
  }
}