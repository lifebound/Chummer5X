import 'package:chummer5x/models/items/location.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/weapon_accessory.dart';
import 'package:chummer5x/utils/availability_parser.dart';
import 'package:material_symbols_icons/symbols.dart';


class Weapon extends ShadowrunItem {
  final String type;
  final String? spec;
  final String? spec2;
  final int reach;
  final String damage;
  final String ap;
  final String mode;
  final int rc;
  final String ammo;
  final bool cyberware;
  final String? ammoCategory;
  final int ammoSlots;
  final String? sizeCategory;
  final String firingMode;
  final String? minRating;
  final String? maxRating;
  final int rating;
  final String accuracy;
  final int activeAmmoSlot;
  final String conceal;
  final String? weight;
  final String? useSkill;
  final String? useSkillSpec;
  final String? range;
  final String? alternateRange;
  final int rangeMultiply;
  final int singleShot;
  final int shortBurst;
  final int longBurst;
  final int fullBurst;
  final int suppressive;
  final bool allowSingleShot;
  final bool allowShortBurst;
  final bool allowLongBurst;
  final bool allowFullBurst;
  final bool allowSuppressive;
  final String? parentId;
  final bool allowAccessory;
  final bool included;
  final bool requireAmmo;
  final String? mount;
  final String? extraMount;
  final List<WeaponAccessory>? accessories;
  final String? location;
  final String? weaponType;

  Weapon({
    required super.name,
    required super.category,
    required super.source,
    required super.page,
    required super.avail, // This comes directly from ShadowrunItem
    required this.type,
    required this.damage,
    required this.ap,
    required this.mode,
    required this.ammo,
    required this.firingMode,
    required this.accuracy,
    
    super.sourceId,
    super.cost = 0,
    super.locationGuid,
    super.equipped,
    super.active,
    super.homeNode,
    super.wirelessOn,
    super.stolen,
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
    super.matrixCmFilled, // Has default in ShadowrunItem
    super.matrixCmBonus, // Has default in ShadowrunItem
    super.notes,
    super.notesColor,
    super.discountedCost,
    super.sortOrder,
    super.canFormPersona, // Make sure this is also handled in Weapon constructor if needed
    
    // Weapon-specific parameters:
    this.spec,
    this.spec2,
    this.reach = 0,
    this.rc = 0,
    this.cyberware = false,
    this.ammoCategory,
    this.ammoSlots = 1,
    this.sizeCategory,
    this.minRating,
    this.maxRating,
    this.rating = 0,
    this.activeAmmoSlot = 1,
    this.conceal = '0',
    
    this.weight,
    this.useSkill,
    this.useSkillSpec,
    this.range,
    this.alternateRange,
    this.rangeMultiply = 1,
    this.singleShot = 1,
    this.shortBurst = 3,
    this.longBurst = 6,
    this.fullBurst = 10,
    this.suppressive = 20,
    this.allowSingleShot = true,
    this.allowShortBurst = true,
    this.allowLongBurst = true,
    this.allowFullBurst = true,
    this.allowSuppressive = true,
    this.parentId,
    this.allowAccessory = false,
    this.included = false,
    this.requireAmmo = true,
    this.mount,
    this.extraMount,
    this.accessories,
    this.location,
    this.weaponType,
  });

  factory Weapon.fromXml(XmlElement xmlElement) {
    int weaponRating = int.tryParse(xmlElement.getElement('rating')?.innerText ?? '0') ?? 0;
    
    final nameText = xmlElement.getElement('name')?.innerText;
    final categoryText = xmlElement.getElement('category')?.innerText;
    final typeText = xmlElement.getElement('type')?.innerText;
    final sourceText = xmlElement.getElement('source')?.innerText;
    final pageText = xmlElement.getElement('page')?.innerText;
    final modeText = xmlElement.getElement('mode')?.innerText;
    final ammoText = xmlElement.getElement('ammo')?.innerText;
    final firingModeText = xmlElement.getElement('firingmode')?.innerText;
    final accuracyText = xmlElement.getElement('accuracy')?.innerText;
    

    final String rawLocationGuid = xmlElement.getElement('location')?.innerText ?? '';
    final String locationGuid = rawLocationGuid.isNotEmpty ? rawLocationGuid : defaultWeaponLocationGuid;

    return Weapon(
      sourceId: xmlElement.getElement('sourceid')?.innerText,
      locationGuid: locationGuid,
      name: nameText?.isNotEmpty == true ? nameText! : 'Unnamed Weapon',
      category: categoryText?.isNotEmpty == true ? categoryText! : 'Unknown',
      type: typeText?.isNotEmpty == true ? typeText! : 'Unknown',
      spec: xmlElement.getElement('spec')?.innerText,
      spec2: xmlElement.getElement('spec2')?.innerText,
      reach: int.tryParse(xmlElement.getElement('reach')?.innerText ?? '0') ?? 0,
      damage: xmlElement.getElement('damage')?.innerText ?? '0',
      ap: xmlElement.getElement('ap')?.innerText ?? '-',
      mode: modeText?.isNotEmpty == true ? modeText! : 'Unknown',
      rc: int.tryParse(xmlElement.getElement('rc')?.innerText ?? '0') ?? 0,
      ammo: ammoText?.isNotEmpty == true ? ammoText! : 'Unknown',
      cyberware: xmlElement.getElement('cyberware')?.innerText == 'True',
      ammoCategory: xmlElement.getElement('ammocategory')?.innerText,
      ammoSlots: int.tryParse(xmlElement.getElement('ammoslots')?.innerText ?? '1') ?? 1,
      sizeCategory: xmlElement.getElement('sizecategory')?.innerText,
      firingMode: firingModeText?.isNotEmpty == true ? firingModeText! : 'Unknown',
      minRating: xmlElement.getElement('minrating')?.innerText,
      maxRating: xmlElement.getElement('maxrating')?.innerText,
      rating: weaponRating,
      accuracy: accuracyText?.isNotEmpty == true ? accuracyText! : '0',
      activeAmmoSlot: int.tryParse(xmlElement.getElement('activeammoslot')?.innerText ?? '1') ?? 1,
      conceal: xmlElement.getElement('conceal')?.innerText ?? '0',
      avail: parseAvail(xmlElement.getElement('avail'), weaponRating),
      cost: int.tryParse(xmlElement.getElement('cost')?.innerText ?? '0') ?? 0,
      weight: xmlElement.getElement('weight')?.innerText,
      useSkill: xmlElement.getElement('useskill')?.innerText,
      useSkillSpec: xmlElement.getElement('useskillspec')?.innerText,
      range: xmlElement.getElement('range')?.innerText,
      alternateRange: xmlElement.getElement('alternaterange')?.innerText,
      rangeMultiply: int.tryParse(xmlElement.getElement('rangemultiply')?.innerText ?? '1') ?? 1,
      singleShot: int.tryParse(xmlElement.getElement('singleshot')?.innerText ?? '1') ?? 1,
      shortBurst: int.tryParse(xmlElement.getElement('shortburst')?.innerText ?? '3') ?? 3,
      longBurst: int.tryParse(xmlElement.getElement('longburst')?.innerText ?? '6') ?? 6,
      fullBurst: int.tryParse(xmlElement.getElement('fullburst')?.innerText ?? '10') ?? 10,
      suppressive: int.tryParse(xmlElement.getElement('suppressive')?.innerText ?? '20') ?? 20,
      allowSingleShot: xmlElement.getElement('allowsingleshot')?.innerText == 'True' || xmlElement.getElement('allowsingleshot') == null,
      allowShortBurst: xmlElement.getElement('allowshortburst')?.innerText == 'True' || xmlElement.getElement('allowshortburst') == null,
      allowLongBurst: xmlElement.getElement('allowlongburst')?.innerText == 'True' || xmlElement.getElement('allowlongburst') == null,
      allowFullBurst: xmlElement.getElement('allowfullburst')?.innerText == 'True' || xmlElement.getElement('allowfullburst') == null,
      allowSuppressive: xmlElement.getElement('allowsuppressive')?.innerText == 'True' || xmlElement.getElement('allowsuppressive') == null,
      source: sourceText?.isNotEmpty == true ? sourceText! : 'Unknown',
      page: pageText?.isNotEmpty == true ? pageText! : '0',
      parentId: xmlElement.getElement('parentid')?.innerText,
      allowAccessory: xmlElement.getElement('allowaccessory')?.innerText == 'True',
      included: xmlElement.getElement('included')?.innerText == 'True',
      equipped: xmlElement.getElement('equipped')?.innerText == 'True',
      active: xmlElement.getElement('active')?.innerText == 'True',
      homeNode: xmlElement.getElement('homenode')?.innerText == 'True',
      deviceRating: xmlElement.getElement('devicerating')?.innerText,
      requireAmmo: xmlElement.getElement('requireammo')?.innerText == 'True' || xmlElement.getElement('requireammo') == null,
      mount: xmlElement.getElement('mount')?.innerText,
      stolen: xmlElement.getElement('stolen')?.innerText == 'True',
      extraMount: xmlElement.getElement('extramount')?.innerText,
      accessories: xmlElement.findElements('accessories').expand((e) => e.findElements('accessory')).map((accXml) => WeaponAccessory.fromXml(accXml)).toList(),
      location: xmlElement.getElement('location')?.innerText,
      notes: xmlElement.getElement('notes')?.innerText,
      notesColor: xmlElement.getElement('notesColor')?.innerText,
      discountedCost: xmlElement.getElement('discountedcost')?.innerText == 'True',
      wirelessOn: xmlElement.getElement('wirelesson')?.innerText == 'True',
      sortOrder: int.tryParse(xmlElement.getElement('sortorder')?.innerText ?? '0') ?? 0,
      weaponType: xmlElement.getElement('weapontype')?.innerText,
    );
  }
  @override
  Icon getIcon(Color? color) {
    return switch (category.toLowerCase()) {
      'flamethrower' => Icon(Symbols.local_fire_department, color: color),
      'swords' => Icon(Symbols.swords, color: color),
      'clubs' => Icon(Symbols.gavel, color: color),
      'sniper rifles' => Icon(Symbols.point_scan, color: color),
      'grenade launcher' => Icon(Symbols.bomb, color: color),
      var cat when cat.contains('pistol') => Icon(Symbols.recenter, color: color),
      var cat when cat.contains('rifle') => Icon(Symbols.target, color: color),
      _ => Icon(Symbols.manufacturing, color: color)
    };
  }

  @override
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    // Check base fields first (name, category)
    if (super.matchesSearch(query)) return true;
    
    // Check if any accessory matches (using their own matchesSearch method)
    return accessories?.any((acc) => acc.matchesSearch(query)) ?? false;
  }

  Weapon copyWith({
    String? sourceId,
    String? locationGuid,
    String? name,
    String? category,
    String? avail,
    int? cost,
    bool? equipped,
    bool? active,
    bool? homeNode,
    bool? wirelessOn,
    bool? stolen,
    String? deviceRating,
    String? programLimit,
    String? overclocked,
    String? attack,
    String? sleaze,
    String? dataProcessing,
    String? firewall,
    List<String>? attributeArray,
    String? modAttack,
    String? modSleaze,
    String? modDataProcessing,
    String? modFirewall,
    List<String>? modAttributeArray,
    bool? canSwapAttributes,
    int? matrixCmFilled,
    int? matrixCmBonus,
    String? notes,
    String? notesColor,
    bool? discountedCost,
    int? sortOrder,
    bool? canFormPersona,
    String? source,
    String? page,
    String? type,
    String? spec,
    String? spec2,
    int? reach,
    String? damage,
    String? ap,
    String? mode,
    int? rc,
    String? ammo,
    bool? cyberware,
    String? ammoCategory,
    int? ammoSlots,
    String? sizeCategory,
    String? firingMode,
    String? minRating,
    String? maxRating,
    int? rating,
    String? accuracy,
    int? activeAmmoSlot,
    String? conceal,
    String? weight,
    String? useSkill,
    String? useSkillSpec,
    String? range,
    String? alternateRange,
    int? rangeMultiply,
    int? singleShot,
    int? shortBurst,
    int? longBurst,
    int? fullBurst,
    int? suppressive,
    bool? allowSingleShot,
    bool? allowShortBurst,
    bool? allowLongBurst,
    bool? allowFullBurst,
    bool? allowSuppressive,
    String? parentId,
    bool? allowAccessory,
    bool? included,
    bool? requireAmmo,
    String? mount,
    String? extraMount,
    List<WeaponAccessory>? accessories,
    String? location,
    String? weaponType,
  }) {
    return Weapon(
      sourceId: sourceId ?? this.sourceId,
      locationGuid: locationGuid ?? this.locationGuid,
      name: name ?? this.name,
      category: category ?? this.category,
      avail: avail ?? this.avail,
      cost: cost ?? this.cost,
      equipped: equipped ?? this.equipped,
      active: active ?? this.active,
      homeNode: homeNode ?? this.homeNode,
      wirelessOn: wirelessOn ?? this.wirelessOn,
      stolen: stolen ?? this.stolen,
      deviceRating: deviceRating ?? this.deviceRating,
      programLimit: programLimit ?? this.programLimit,
      overclocked: overclocked ?? this.overclocked,
      attack: attack ?? this.attack,
      sleaze: sleaze ?? this.sleaze,
      dataProcessing: dataProcessing ?? this.dataProcessing,
      firewall: firewall ?? this.firewall,
      attributeArray: attributeArray ?? this.attributeArray,
      modAttack: modAttack ?? this.modAttack,
      modSleaze: modSleaze ?? this.modSleaze,
      modDataProcessing: modDataProcessing ?? this.modDataProcessing,
      modFirewall: modFirewall ?? this.modFirewall,
      modAttributeArray: modAttributeArray ?? this.modAttributeArray,
      canSwapAttributes: canSwapAttributes ?? this.canSwapAttributes,
      matrixCmFilled: matrixCmFilled ?? this.matrixCmFilled,
      matrixCmBonus: matrixCmBonus ?? this.matrixCmBonus,
      notes: notes ?? this.notes,
      notesColor: notesColor ?? this.notesColor,
      discountedCost: discountedCost ?? this.discountedCost,
      sortOrder: sortOrder ?? this.sortOrder,
      canFormPersona: canFormPersona ?? this.canFormPersona,
      source: source ?? this.source,
      page: page ?? this.page,
      type: type ?? this.type,
      spec: spec ?? this.spec,
      spec2: spec2 ?? this.spec2,
      reach: reach ?? this.reach,
      damage: damage ?? this.damage,
      ap: ap ?? this.ap,
      mode: mode ?? this.mode,
      rc: rc ?? this.rc,
      ammo: ammo ?? this.ammo,
      cyberware: cyberware ?? this.cyberware,
      ammoCategory: ammoCategory ?? this.ammoCategory,
      ammoSlots: ammoSlots ?? this.ammoSlots,
      sizeCategory: sizeCategory ?? this.sizeCategory,
      firingMode: firingMode ?? this.firingMode,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      rating: rating ?? this.rating,
      accuracy: accuracy ?? this.accuracy,
      activeAmmoSlot: activeAmmoSlot ?? this.activeAmmoSlot,
      conceal: conceal ?? this.conceal,
      weight: weight ?? this.weight,
      useSkill: useSkill ?? this.useSkill,
      useSkillSpec: useSkillSpec ?? this.useSkillSpec,
      range: range ?? this.range,
      alternateRange: alternateRange ?? this.alternateRange,
      rangeMultiply: rangeMultiply ?? this.rangeMultiply,
      singleShot: singleShot ?? this.singleShot,
      shortBurst: shortBurst ?? this.shortBurst,
      longBurst: longBurst ?? this.longBurst,
      fullBurst: fullBurst ?? this.fullBurst,
      suppressive: suppressive ?? this.suppressive,
      allowSingleShot: allowSingleShot ?? this.allowSingleShot,
      allowShortBurst: allowShortBurst ?? this.allowShortBurst,
      allowLongBurst: allowLongBurst ?? this.allowLongBurst,
      allowFullBurst: allowFullBurst ?? this.allowFullBurst,
      allowSuppressive: allowSuppressive ?? this.allowSuppressive,
      parentId: parentId ?? this.parentId,
      allowAccessory: allowAccessory ?? this.allowAccessory,
      included: included ?? this.included,
      requireAmmo: requireAmmo ?? this.requireAmmo,
      mount: mount ?? this.mount,
      extraMount: extraMount ?? this.extraMount,
      accessories: accessories ?? this.accessories,
      location: location ?? this.location,
      weaponType: weaponType ?? this.weaponType,
    );
  }

  @override
  Weapon? filterWithHierarchy(String query) {
    if (query.isEmpty) return this;
    
    // Filter nested accessories
    final filteredAccessories = accessories
        ?.map((acc) => acc.filterWithHierarchy(query))
        .where((acc) => acc != null)
        .cast<WeaponAccessory>()
        .toList();
    
    // Include this weapon if it matches OR if it has matching accessories
    if (matchesSearch(query) || (filteredAccessories?.isNotEmpty ?? false)) {
      // Use copyWith to return filtered version
      return copyWith(accessories: filteredAccessories);
    }
    
    return null;
  }
}