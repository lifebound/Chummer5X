import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'package:chummer5x/models/items/gear.dart';

class WeaponAccessory extends ShadowrunItem {
  final String? guid;
  final String mount;
  final String extraMount;
  final String? rc;
  final int maxRating;
  final int rating;
  final String ratingLabel;
  final int rcGroup;
  final bool rcDeployable;
  final bool specialModification;
  final String? conceal;
  final String? weight;
  final bool included;
  final String? accuracy;
  final List<Gear>? gears; // Accessories can contain gears
  final String? ammoReplace;
  final int ammoSlots;
  final String? modifyAmmoCapacity;
  final String? damageType;
  final String? damage;
  final String? reach;
  final String? damageReplace;
  final String? fireMode;
  final String? fireModeReplace;
  final String? ap;
  final String? apReplace;
  final int singleShot;
  final int shortBurst;
  final int longBurst;
  final int fullBurst;
  final int suppressive;
  final int rangeBonus;
  final int rangeModifier;
  final String? extra;
  final String? ammoBonus;
  final String? parentId;

  WeaponAccessory({
    required super.name,
    required super.category,
    required super.source,
    required super.page,
    required super.avail,
    required super.cost,
    this.guid,
    required this.mount,
    required this.extraMount,
    this.rc,
    this.maxRating = 0,
    this.rating = 0,
    this.ratingLabel = 'String_Rating',
    this.rcGroup = 0,
    this.rcDeployable = false,
    this.specialModification = false,
    this.conceal,
    this.weight,
    this.included = false,
    this.accuracy,
    this.gears,
    this.ammoReplace,
    this.ammoSlots = 0,
    this.modifyAmmoCapacity,
    this.damageType,
    this.damage,
    this.reach,
    this.damageReplace,
    this.fireMode,
    this.fireModeReplace,
    this.ap,
    this.apReplace,
    this.singleShot = 0,
    this.shortBurst = 0,
    this.longBurst = 0,
    this.fullBurst = 0,
    this.suppressive = 0,
    this.rangeBonus = 0,
    this.rangeModifier = 0,
    this.extra,
    this.ammoBonus,
    this.parentId, 
    required super.equipped, 
    super.notes, 
    super.notesColor, 
    required super.discountedCost, 
    required super.wirelessOn, 
    required super.stolen, 
    required super.sortOrder, 
  });

  factory WeaponAccessory.fromXml(XmlElement xmlElement) {
    return WeaponAccessory(
      guid: xmlElement.getElement('guid')?.innerText,
      name: xmlElement.getElement('name')?.innerText ?? 'Unnamed Accessory',
      mount: xmlElement.getElement('mount')?.innerText ?? 'None',
      extraMount: xmlElement.getElement('extramount')?.innerText ?? 'None',
      rc: xmlElement.getElement('rc')?.innerText,
      maxRating: int.tryParse(xmlElement.getElement('maxrating')?.innerText ?? '0') ?? 0,
      rating: int.tryParse(xmlElement.getElement('rating')?.innerText ?? '0') ?? 0,
      ratingLabel: xmlElement.getElement('ratinglabel')?.innerText ?? 'String_Rating',
      rcGroup: int.tryParse(xmlElement.getElement('rcgroup')?.innerText ?? '0') ?? 0,
      rcDeployable: xmlElement.getElement('rcdeployable')?.innerText == 'True',
      specialModification: xmlElement.getElement('specialmodification')?.innerText == 'True',
      conceal: xmlElement.getElement('conceal')?.innerText,
      avail: xmlElement.getElement('avail')?.innerText ?? '',
      cost: int.tryParse(xmlElement.getElement('cost')?.innerText ?? '0') ?? 0,
      weight: xmlElement.getElement('weight')?.innerText,
      included: xmlElement.getElement('included')?.innerText == 'True',
      equipped: xmlElement.getElement('equipped')?.innerText == 'True',
      source: xmlElement.getElement('source')?.innerText ?? 'Unknown',
      page: xmlElement.getElement('page')?.innerText ?? '0',
      accuracy: xmlElement.getElement('accuracy')?.innerText,
      gears: xmlElement.findElements('gears').expand((e) => e.findElements('gear')).map((gearXml) => Gear.fromXml(gearXml)).toList(),
      ammoReplace: xmlElement.getElement('ammoreplace')?.innerText,
      ammoSlots: int.tryParse(xmlElement.getElement('ammoslots')?.innerText ?? '0') ?? 0,
      modifyAmmoCapacity: xmlElement.getElement('modifyammocapacity')?.innerText,
      damageType: xmlElement.getElement('damagetype')?.innerText,
      damage: xmlElement.getElement('damage')?.innerText,
      reach: xmlElement.getElement('reach')?.innerText,
      damageReplace: xmlElement.getElement('damagereplace')?.innerText,
      fireMode: xmlElement.getElement('firemode')?.innerText,
      fireModeReplace: xmlElement.getElement('firemodereplace')?.innerText,
      ap: xmlElement.getElement('ap')?.innerText,
      apReplace: xmlElement.getElement('apreplace')?.innerText,
      notes: xmlElement.getElement('notes')?.innerText,
      notesColor: xmlElement.getElement('notesColor')?.innerText,
      discountedCost: xmlElement.getElement('discountedcost')?.innerText == 'True',
      singleShot: int.tryParse(xmlElement.getElement('singleshot')?.innerText ?? '0') ?? 0,
      shortBurst: int.tryParse(xmlElement.getElement('shortburst')?.innerText ?? '0') ?? 0,
      longBurst: int.tryParse(xmlElement.getElement('longburst')?.innerText ?? '0') ?? 0,
      fullBurst: int.tryParse(xmlElement.getElement('fullburst')?.innerText ?? '0') ?? 0,
      suppressive: int.tryParse(xmlElement.getElement('suppressive')?.innerText ?? '0') ?? 0,
      rangeBonus: int.tryParse(xmlElement.getElement('rangebonus')?.innerText ?? '0') ?? 0,
      rangeModifier: int.tryParse(xmlElement.getElement('rangemodifier')?.innerText ?? '0') ?? 0,
      extra: xmlElement.getElement('extra')?.innerText,
      ammoBonus: xmlElement.getElement('ammobonus')?.innerText,
      wirelessOn: xmlElement.getElement('wirelesson')?.innerText == 'True',
      stolen: xmlElement.getElement('stolen')?.innerText == 'True',
      sortOrder: int.tryParse(xmlElement.getElement('sortorder')?.innerText ?? '0') ?? 0,
      parentId: xmlElement.getElement('parentid')?.innerText, 
      category: xmlElement.getElement('category')?.innerText ?? 'Unknown',
    );
  }

  @override
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    // Check base fields first (name, category)
    if (super.matchesSearch(query)) return true;
    
    final String lowerQuery = query.toLowerCase();
    
    // Check WeaponAccessory-specific fields
    if (mount.toLowerCase().contains(lowerQuery) ||
        extraMount.toLowerCase().contains(lowerQuery)) {
      return true;
    }
    
    // Check nested gears
    return gears?.any((gear) => gear.matchesSearch(query)) ?? false;
  }

  WeaponAccessory copyWith({
    String? name,
    String? category,
    String? source,
    String? page,
    String? avail,
    int? cost,
    String? guid,
    String? mount,
    String? extraMount,
    String? rc,
    int? maxRating,
    int? rating,
    String? ratingLabel,
    int? rcGroup,
    bool? rcDeployable,
    bool? specialModification,
    String? conceal,
    String? weight,
    bool? included,
    String? accuracy,
    List<Gear>? gears,
    String? ammoReplace,
    int? ammoSlots,
    String? modifyAmmoCapacity,
    String? damageType,
    String? damage,
    String? reach,
    String? damageReplace,
    String? fireMode,
    String? fireModeReplace,
    String? ap,
    String? apReplace,
    int? singleShot,
    int? shortBurst,
    int? longBurst,
    int? fullBurst,
    int? suppressive,
    int? rangeBonus,
    int? rangeModifier,
    String? extra,
    String? ammoBonus,
    String? parentId,
    bool? equipped,
    String? notes,
    String? notesColor,
    bool? discountedCost,
    bool? wirelessOn,
    bool? stolen,
    int? sortOrder,
  }) {
    return WeaponAccessory(
      name: name ?? this.name,
      category: category ?? this.category,
      source: source ?? this.source,
      page: page ?? this.page,
      avail: avail ?? this.avail,
      cost: cost ?? this.cost,
      guid: guid ?? this.guid,
      mount: mount ?? this.mount,
      extraMount: extraMount ?? this.extraMount,
      rc: rc ?? this.rc,
      maxRating: maxRating ?? this.maxRating,
      rating: rating ?? this.rating,
      ratingLabel: ratingLabel ?? this.ratingLabel,
      rcGroup: rcGroup ?? this.rcGroup,
      rcDeployable: rcDeployable ?? this.rcDeployable,
      specialModification: specialModification ?? this.specialModification,
      conceal: conceal ?? this.conceal,
      weight: weight ?? this.weight,
      included: included ?? this.included,
      accuracy: accuracy ?? this.accuracy,
      gears: gears ?? this.gears,
      ammoReplace: ammoReplace ?? this.ammoReplace,
      ammoSlots: ammoSlots ?? this.ammoSlots,
      modifyAmmoCapacity: modifyAmmoCapacity ?? this.modifyAmmoCapacity,
      damageType: damageType ?? this.damageType,
      damage: damage ?? this.damage,
      reach: reach ?? this.reach,
      damageReplace: damageReplace ?? this.damageReplace,
      fireMode: fireMode ?? this.fireMode,
      fireModeReplace: fireModeReplace ?? this.fireModeReplace,
      ap: ap ?? this.ap,
      apReplace: apReplace ?? this.apReplace,
      singleShot: singleShot ?? this.singleShot,
      shortBurst: shortBurst ?? this.shortBurst,
      longBurst: longBurst ?? this.longBurst,
      fullBurst: fullBurst ?? this.fullBurst,
      suppressive: suppressive ?? this.suppressive,
      rangeBonus: rangeBonus ?? this.rangeBonus,
      rangeModifier: rangeModifier ?? this.rangeModifier,
      extra: extra ?? this.extra,
      ammoBonus: ammoBonus ?? this.ammoBonus,
      parentId: parentId ?? this.parentId,
      equipped: equipped ?? super.equipped,
      notes: notes ?? super.notes,
      notesColor: notesColor ?? super.notesColor,
      discountedCost: discountedCost ?? super.discountedCost,
      wirelessOn: wirelessOn ?? super.wirelessOn,
      stolen: stolen ?? super.stolen,
      sortOrder: sortOrder ?? super.sortOrder,
    );
  }

  @override
  WeaponAccessory? filterWithHierarchy(String query) {
    if (query.isEmpty) return this;
    
    // Filter nested gears
    final filteredGears = gears
        ?.map((gear) => gear.filterWithHierarchy(query))
        .where((gear) => gear != null)
        .cast<Gear>()
        .toList();
    
    // Include this accessory if it matches OR if it has matching gears
    if (matchesSearch(query) || (filteredGears?.isNotEmpty ?? false)) {
      // Create a new WeaponAccessory with filtered gears
      return copyWith(gears: filteredGears);
    }
    
    return null;
  }

  @override
  String get details {
    return 'Category: $category, Mount: $mount, Source: $source p. $page, Cost: $cost¥, Availability: $avail';
  }

  @override
  Widget getDetailsContent(BuildContext context, {Map<String, int>? characterAttributes, Function? onUpdate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDetailRow(context, 'Category', category),
        buildDetailRow(context, 'Mount', mount),
        if (rating > 0) buildDetailRow(context, 'Rating', rating.toString()),
        if (ratingLabel != 'String_Rating') buildDetailRow(context, 'Rating Label', ratingLabel),
        buildDetailRow(context, 'Source', '$source p. $page'),
        buildDetailRow(context, 'Availability', avail),
        buildDetailRow(context, 'Cost', '$cost¥'),
        if (rc != null) buildDetailRow(context, 'RC', rc!),
        if (accuracy != null) buildDetailRow(context, 'Accuracy', accuracy!),
        const Divider(height: 24, thickness: 1),
        buildToggleRow(context, 'Equipped', equipped, (value) {
          if (onUpdate != null) {
            onUpdate(this, equipped: value);
          }
        }),
        buildToggleRow(context, 'Wireless', wirelessOn, (value) {
          if (onUpdate != null) {
            onUpdate(this, wireless: value);
          }
        }),
      ],
    );
  }
}