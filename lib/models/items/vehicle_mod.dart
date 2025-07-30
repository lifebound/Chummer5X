import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/weapon.dart';

class VehicleMod extends ShadowrunItem{
  
  final String guid;
  final String? limit;
  final String slots;
  final String? capacity;
  // TODO: These should be int instead of String - ratings are always integers
  final String rating;
  final String maxRating;
  final String ratingLabel;
  final String conditionMonitor;

  final String markup;
  final String? extra;

  final bool included;
  final String? subsystems;
  final String? weaponMountCategories;
  final String ammoBonus;
  final String ammoBonusPercent;
  final String? ammoReplace;
  final List<Weapon>? weapons; // This seems to be an empty tag or string in sample


  VehicleMod({
    required super.sourceId,
    required this.guid,
    required super.name,
    required super.category,
    this.limit,
    required this.slots,
    this.capacity,
    required this.rating,
    required this.maxRating,
    required this.ratingLabel,
    required this.conditionMonitor,
    required super.avail,
    required super.cost,
    required this.markup,
    this.extra,
    required super.source,
    required super.page,
    required super.equipped,
    required super.wirelessOn,
    super.notes,
    super.notesColor,
    required super.discountedCost,
    required super.sortOrder,
    required super.stolen,
    required this.included,
 
    this.subsystems,
    this.weaponMountCategories,
    required this.ammoBonus,
    required this.ammoBonusPercent,
    this.ammoReplace,
    this.weapons,
 
  });

  factory VehicleMod.fromXmlElement(XmlElement element) {
    return VehicleMod(
      sourceId: element.getElement('sourceid')?.innerText ?? '',
      guid: element.getElement('guid')?.innerText ?? '',
      name: element.getElement('name')?.innerText ?? '',
      category: element.getElement('category')?.innerText ?? '',
      limit: element.getElement('limit')?.innerText,
      slots: element.getElement('slots')?.innerText ?? '',
      capacity: element.getElement('capacity')?.innerText,
      rating: element.getElement('rating')?.innerText ?? '0',
      maxRating: element.getElement('maxrating')?.innerText ?? '0',
      ratingLabel: element.getElement('ratinglabel')?.innerText ?? '',
      conditionMonitor: element.getElement('conditionmonitor')?.innerText ?? '0',
      avail: element.getElement('avail')?.innerText ?? '',
      cost: double.tryParse(element.getElement('cost')?.innerText ?? '') ?? 0,
      markup: element.getElement('markup')?.innerText ?? '0',
      extra: element.getElement('extra')?.innerText,
      source: element.getElement('source')?.innerText ?? '',
      page: element.getElement('page')?.innerText ?? '',
      included: element.getElement('included')?.innerText == 'True',
      equipped: element.getElement('equipped')?.innerText == 'True',
      wirelessOn: element.getElement('wirelesson')?.innerText == 'True',
      subsystems: element.getElement('subsystems')?.innerText,
      weaponMountCategories: element.getElement('weaponmountcategories')?.innerText,
      ammoBonus: element.getElement('ammobonus')?.innerText ?? '0',
      ammoBonusPercent: element.getElement('ammobonuspercent')?.innerText ?? '0',
      ammoReplace: element.getElement('ammoreplace')?.innerText,
      weapons: element.getElement('weapons')?.findAllElements('weapon').map((e) => Weapon.fromXml(e)).toList() ?? [],
      notes: element.getElement('notes')?.innerText,
      notesColor: element.getElement('notesColor')?.innerText,
      discountedCost: element.getElement('discountedcost')?.innerText == 'True',
      sortOrder:int.tryParse(element.getElement('sortorder')?.innerText ?? '') ?? 0,
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
    return weapons?.any((weapon) => weapon.matchesSearch(query)) ?? false;
  }

  VehicleMod copyWith({
    String? sourceId,
    String? guid,
    String? name,
    String? category,
    String? limit,
    String? slots,
    String? capacity,
    String? rating,
    String? maxRating,
    String? ratingLabel,
    String? conditionMonitor,
    String? avail,
    double? cost,
    String? markup,
    String? extra,
    String? source,
    String? page,
    bool? included,
    bool? equipped,
    bool? wirelessOn,
    String? subsystems,
    String? weaponMountCategories,
    String? ammoBonus,
    String? ammoBonusPercent,
    String? ammoReplace,
    List<Weapon>? weapons,
    String? notes,
    String? notesColor,
    bool? discountedCost,
    int? sortOrder,
    bool? stolen,
  }) {
    return VehicleMod(
      sourceId: sourceId ?? this.sourceId,
      guid: guid ?? this.guid,
      name: name ?? this.name,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      slots: slots ?? this.slots,
      capacity: capacity ?? this.capacity,
      rating: rating ?? this.rating,
      maxRating: maxRating ?? this.maxRating,
      ratingLabel: ratingLabel ?? this.ratingLabel,
      conditionMonitor: conditionMonitor ?? this.conditionMonitor,
      avail: avail ?? this.avail,
      cost: cost ?? this.cost,
      markup: markup ?? this.markup,
      extra: extra ?? this.extra,
      source: source ?? this.source,
      page: page ?? this.page,
      included: included ?? this.included,
      equipped: equipped ?? this.equipped,
      wirelessOn: wirelessOn ?? this.wirelessOn,
      subsystems: subsystems ?? this.subsystems,
      weaponMountCategories: weaponMountCategories ?? this.weaponMountCategories,
      ammoBonus: ammoBonus ?? this.ammoBonus,
      ammoBonusPercent: ammoBonusPercent ?? this.ammoBonusPercent,
      ammoReplace: ammoReplace ?? this.ammoReplace,
      weapons: weapons ?? this.weapons,
      notes: notes ?? this.notes,
      notesColor: notesColor ?? this.notesColor,
      discountedCost: discountedCost ?? this.discountedCost,
      sortOrder: sortOrder ?? this.sortOrder,
      stolen: stolen ?? this.stolen,
    );
  }

  @override
  VehicleMod? filterWithHierarchy(String query) {
    if (query.isEmpty) return this;
    
    // Filter nested weapons
    final filteredWeapons = weapons
        ?.map((weapon) => weapon.filterWithHierarchy(query))
        .where((weapon) => weapon != null)
        .cast<Weapon>()
        .toList();
    
    // Include this mod if it matches OR if it has matching weapons
    if (matchesSearch(query) || (filteredWeapons?.isNotEmpty ?? false)) {
      return copyWith(weapons: filteredWeapons);
    }
    
    return null;
  }
}