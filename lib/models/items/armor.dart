import 'package:chummer5x/models/items/location.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:chummer5x/utils/availability_parser.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:chummer5x/models/items/armor_mod.dart';

class Armor extends ShadowrunItem {
  final String armorValue;
  final String? armorOverride;
  final String armorCapacity;
  final String? weight;
  final String? armorName;
  final String? extra;
  final int damage;
  final int rating;
  final int maxRating;
  final String ratingLabel;
  final bool encumbrance; // 'emcumbrance' in XML, assuming it means encumbrance
  final List<ArmorMod>? armorMods;
  final String? location;
  Armor({
    super.sourceId,
    super.locationGuid,
    required super.name,
    required super.category,
    required super.source,
    required super.page,
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
    super.matrixCmFilled,
    super.matrixCmBonus,
    super.canFormPersona,
    super.notes,
    super.notesColor,
    super.discountedCost,
    super.sortOrder,
    required super.avail, // This comes directly from ShadowrunItem
    // Armor-specific parameters:
    required this.armorValue,
    this.armorOverride,
    required this.armorCapacity,
    super.cost = 0,
    this.weight,
    this.armorName,
    this.extra,
    this.damage = 0,
    this.rating = 0,
    this.maxRating = 0,
    this.ratingLabel = 'String_Rating',
    this.encumbrance = false,
    this.armorMods,
    this.location,
    
  });

  factory Armor.fromXml(XmlElement xmlElement) {
    int armorRating = int.tryParse(xmlElement.getElement('armor')?.innerText ?? '0') ?? 0;
    
    final nameText = xmlElement.getElement('name')?.innerText;
    final categoryText = xmlElement.getElement('category')?.innerText;
    final sourceText = xmlElement.getElement('source')?.innerText;
    final pageText = xmlElement.getElement('page')?.innerText;
    
    final String rawLocationGuid = xmlElement.getElement('location')?.innerText ?? '';
    final String locationGuid = rawLocationGuid.isNotEmpty ? rawLocationGuid : defaultArmorLocationGuid;


    return Armor(
      sourceId: xmlElement.getElement('sourceid')?.innerText,
      locationGuid: locationGuid,
      name: nameText?.isNotEmpty == true ? nameText! : 'Unnamed Armor',
      category: categoryText?.isNotEmpty == true ? categoryText! : 'Unknown',
      armorValue: xmlElement.getElement('armor')?.innerText ?? '0',
      armorOverride: xmlElement.getElement('armoroverride')?.innerText,
      armorCapacity: xmlElement.getElement('armorcapacity')?.innerText ?? '0',
      avail: parseAvail(xmlElement.getElement('avail'), armorRating),
      cost: int.tryParse(xmlElement.getElement('cost')?.innerText ?? '0') ?? 0,
      weight: xmlElement.getElement('weight')?.innerText,
      source: sourceText?.isNotEmpty == true ? sourceText! : 'Unknown',
      page: pageText?.isNotEmpty == true ? pageText! : '0',
      armorName: xmlElement.getElement('armorname')?.innerText,
      equipped: xmlElement.getElement('equipped')?.innerText == 'True',
      active: xmlElement.getElement('active')?.innerText == 'True',
      homeNode: xmlElement.getElement('homenode')?.innerText == 'True',
      deviceRating: xmlElement.getElement('devicerating')?.innerText,
      programLimit: xmlElement.getElement('programlimit')?.innerText,
      overclocked: xmlElement.getElement('overclocked')?.innerText,
      attack: xmlElement.getElement('attack')?.innerText,
      sleaze: xmlElement.getElement('sleaze')?.innerText,
      dataProcessing: xmlElement.getElement('dataprocessing')?.innerText,
      firewall: xmlElement.getElement('firewall')?.innerText,
      wirelessOn: xmlElement.getElement('wirelesson')?.innerText == 'True',
      canFormPersona: xmlElement.getElement('canformpersona')?.innerText == 'True',
      extra: xmlElement.getElement('extra')?.innerText,
      damage: int.tryParse(xmlElement.getElement('damage')?.innerText ?? '0') ?? 0,
      rating: armorRating,
      maxRating: int.tryParse(xmlElement.getElement('maxrating')?.innerText ?? '0') ?? 0,
      ratingLabel: xmlElement.getElement('ratinglabel')?.innerText ?? 'String_Rating',
      stolen: xmlElement.getElement('stolen')?.innerText == 'True',
      encumbrance: xmlElement.getElement('emcumbrance')?.innerText == 'True',
      armorMods: xmlElement.findElements('armormods').expand((e) => e.findElements('armormod')).map((modXml) => ArmorMod.fromXml(modXml)).toList(),
      location: xmlElement.getElement('location')?.innerText,
      notes: xmlElement.getElement('notes')?.innerText,
      notesColor: xmlElement.getElement('notesColor')?.innerText,
      discountedCost: xmlElement.getElement('discountedcost')?.innerText == 'True',
      sortOrder: int.tryParse(xmlElement.getElement('sortorder')?.innerText ?? '0') ?? 0,
    );
  }
  Armor copyWith({
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
    String? armorValue,
    String? armorOverride,
    String? armorCapacity,
    String? weight,
    String? armorName,
    String? extra,
    int? damage,
    int? rating,
    int? maxRating,
    String? ratingLabel,
    bool? encumbrance,
    List<ArmorMod>? armorMods,
    String? location,
  }) {
    return Armor(
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
      armorValue: armorValue ?? this.armorValue,
      armorOverride: armorOverride ?? this.armorOverride,
      armorCapacity: armorCapacity ?? this.armorCapacity,
      weight: weight ?? this.weight,
      armorName: armorName ?? this.armorName,
      extra: extra ?? this.extra,
      damage: damage ?? this.damage,
      rating: rating ?? this.rating,
      maxRating: maxRating ?? this.maxRating,
      ratingLabel: ratingLabel ?? this.ratingLabel,
      encumbrance: encumbrance ?? this.encumbrance,
      armorMods: armorMods ?? this.armorMods,
      location: location ?? this.location,
    );
  }

  @override
  Armor? filterWithHierarchy(String query) {
    if (query.isEmpty) return this;
    
    // Filter nested armor mods
    final filteredArmorMods = armorMods
        ?.map((mod) => mod.filterWithHierarchy(query))
        .where((mod) => mod != null)
        .cast<ArmorMod>()
        .toList();
    
    // Include this armor if it matches OR if it has matching mods
    if (matchesSearch(query) || (filteredArmorMods?.isNotEmpty ?? false)) {
      return copyWith(armorMods: filteredArmorMods);
    }
    
    return null;
  }

  @override
  Icon getIcon(Color? color) {
    return switch (category.toLowerCase()) {
      'armor' => Icon(Icons.shield, color: color),
      'cloaks' => Icon(Icons.checkroom, color: color),
      'clothing' => Icon(Symbols.apparel, color: color),
      'specialty armor' => Icon(Symbols.exclamation, color: color),
      'high-fashion armor clothing' => Icon(Symbols.shield_person, color: color),
      _ => Icon(Icons.miscellaneous_services_outlined, color: color)
    };
  }

  @override
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    // Check base fields first (name, category)
    if (super.matchesSearch(query)) return true;
    
    // Check if any armor mod matches
    return armorMods?.any((mod) => 
        mod.name.toLowerCase().contains(query.toLowerCase())
    ) ?? false;
  }
}