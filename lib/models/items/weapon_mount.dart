import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:chummer5x/utils/xml_element_extensions.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/weapon.dart';
import 'package:chummer5x/models/items/vehicle_mod.dart';
import 'package:chummer5x/models/items/weapon_mount_option.dart';

class WeaponMount extends ShadowrunItem{

  final String guid;


  final String? limit;
  final String slots;

  final bool freeCost;
  final String markup;
  final String? extra;

  final bool included;

  final String weaponMountCategories;
  final String weaponCapacity;
  final List<Weapon>? weapons; // Reusing the Weapon class
  final List<WeaponMountOption> weaponMountOptions;
  final List<VehicleMod> mods; // Assuming <mods> here would contain VehicleMod

  WeaponMount({
    required super.sourceId,
    required this.guid,
    required super.name,
    required super.category,
    this.limit,
    required this.slots,
    required super.avail,
    required super.cost,
    required this.freeCost,
    required this.markup,
    this.extra,
    required super.source,
    required super.page,
    required this.included,
    required super.equipped,
    required this.weaponMountCategories,
    required this.weaponCapacity,
    required this.weapons,
    required this.weaponMountOptions,
    required this.mods,
    super.notes,
    super.notesColor,
    required super.discountedCost,
    required super.sortOrder,
    required super.stolen,
  });

  factory WeaponMount.fromXml(XmlElement element) {
    return WeaponMount(
      sourceId: element.getElement('sourceid')?.innerText ?? '',
      guid: element.getElement('guid')?.innerText ?? '',
      name: element.getElement('name')?.innerText ?? '',
      category: element.getElement('category')?.innerText ?? '',
      limit: element.getElement('limit')?.innerText,
      slots: element.getElement('slots')?.innerText ?? '',
      avail: element.getElement('avail')?.innerText ?? '',
      cost: double.tryParse(element.getElement('cost')?.innerText ?? '') ?? 0,
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
      weaponMountOptions: element.getElement('weaponmountoptions')?.findAllElements('weaponmountoption').map((e) => WeaponMountOption.fromXml(e)).toList() ?? [],
      mods: element.parseList(
        collectionTagName: 'mods',
        itemTagName: 'mod',
        fromXml: (e) => VehicleMod.fromXml(e),
      ),
      notes: element.getElement('notes')?.innerText,
      notesColor: element.getElement('notesColor')?.innerText,
      discountedCost: element.getElement('discountedcost')?.innerText == 'True',
      sortOrder: int.tryParse(element.getElement('sortorder')?.innerText ?? '')?? 0,
      stolen: element.getElement('stolen')?.innerText == 'True',
    );
  }

  @override
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
    double? cost,
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
    int? sortOrder,
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

  @override
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