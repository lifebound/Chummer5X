import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:chummer5x/utils/xml_element_extensions.dart';
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

  factory VehicleMod.fromXml(XmlElement element) {
    return VehicleMod(
      sourceId: element.getElementText('sourceid') ?? '',
      guid: element.getElementText('guid') ?? '',
      name: element.getElementText('name') ?? '',
      category: element.getElementText('category') ?? '',
      limit: element.getElementText('limit'),
      slots: element.getElementText('slots') ?? '',
      capacity: element.getElementText('capacity'),
      rating: element.getElementText('rating') ?? '0',
      maxRating: element.getElementText('maxrating') ?? '0',
      ratingLabel: element.getElementText('ratinglabel') ?? '',
      conditionMonitor: element.getElementText('conditionmonitor') ?? '0',
      avail: element.getElementText('avail') ?? '',
      cost: double.tryParse(element.getElementText('cost') ?? '') ?? 0,
      markup: element.getElementText('markup') ?? '0',
      extra: element.getElementText('extra'),
      source: element.getElementText('source') ?? '',
      page: element.getElementText('page') ?? '',
      included: element.getElementText('included') == 'True',
      equipped: element.getElementText('equipped') == 'True',
      wirelessOn: element.getElementText('wirelesson') == 'True',
      subsystems: element.getElementText('subsystems'),
      weaponMountCategories: element.getElementText('weaponmountcategories'),
      ammoBonus: element.getElementText('ammobonus') ?? '0',
      ammoBonusPercent: element.getElementText('ammobonuspercent') ?? '0',
      ammoReplace: element.getElementText('ammoreplace'),
      weapons: element.parseList(
        collectionTagName: 'weapons',
        itemTagName: 'weapon',
        fromXml: (e) => Weapon.fromXml(e),
      ),
      notes: element.getElementText('notes'),
      notesColor: element.getElementText('notesColor'),
      discountedCost: element.getElementText('discountedcost') == 'True',
      sortOrder: int.tryParse(element.getElementText('sortorder') ?? '') ?? 0,
      stolen: element.getElementText('stolen') == 'True',
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