import 'package:chummer5x/models/items/location.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/utils/availability_parser.dart';

class Gear extends ShadowrunItem {
  // ... Gear-specific final fields remain as they are.
  final String? capacity;
  final String? armorCapacity;
  // TODO: These should be int? instead of String? - ratings are always integers
  final String? minRating;
  final String? maxRating;
  final int rating;
  final double qty;
  final String? weight;
  final String? extra;
  final bool bonded;
  final String? forcedValue;
  final String? parentId;
  final bool allowRename;
  final List<Gear>? children;
  final String? location;

  Gear({
    super.sourceId,
    super.locationGuid,
    required super.name,
    required super.category,
    required super.source,
    required super.page,
    super.equipped,
    super.wirelessOn,
    super.stolen,
    // Note: avail is required in ShadowrunItem, but you had a default '0' for it in Gear.
    // If '0' is truly the default for Gear if not provided, it should be handled:
    // 1. Make avail optional in ShadowrunItem if it can truly be defaulted.
    // 2. Or ensure it's always provided by the factory or passed explicitly.
    // Assuming for now it's always provided by fromXml or explicitly set:
    required super.avail, // This comes directly from ShadowrunItem
    super.notes,
    super.notesColor,
    super.discountedCost,
    super.sortOrder,
    // Gear-specific parameters:
    this.capacity,
    this.armorCapacity,
    this.minRating,
    this.maxRating,
    this.rating = 0,
    this.qty = 1.0,
    super.cost = 0,
    this.weight,
    this.extra,
    this.bonded = false,
    this.forcedValue,
    this.parentId,
    this.allowRename = false,
    this.children,
    this.location,
    super.active = false, // Default to false if not provided
  });

  Gear copyWith({
    String? sourceId,
    String? locationGuid,
    String? name,
    String? category,
    String? source,
    String? page,
    bool? equipped,
    bool? wirelessOn,
    bool? stolen,
    String? avail,
    String? notes,
    String? notesColor,
    bool? discountedCost,
    int? sortOrder,
    String? capacity,
    String? armorCapacity,
    String? minRating,
    String? maxRating,
    int? rating,
    double? qty,
    double? cost,
    String? weight,
    String? extra,
    bool? bonded,
    String? forcedValue,
    String? parentId,
    bool? allowRename,
    List<Gear>? children,
    String? location,
    bool? active,
  }) {
    return Gear(
      sourceId: sourceId ?? this.sourceId,
      locationGuid: locationGuid ?? this.locationGuid,
      name: name ?? this.name,
      category: category ?? this.category,
      source: source ?? this.source,
      page: page ?? this.page,
      equipped: equipped ?? this.equipped,
      wirelessOn: wirelessOn ?? this.wirelessOn,
      stolen: stolen ?? this.stolen,
      avail: avail ?? this.avail,
      notes: notes ?? this.notes,
      notesColor: notesColor ?? this.notesColor,
      discountedCost: discountedCost ?? this.discountedCost,
      sortOrder: sortOrder ?? this.sortOrder,
      capacity: capacity ?? this.capacity,
      armorCapacity: armorCapacity ?? this.armorCapacity,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      rating: rating ?? this.rating,
      qty: qty ?? this.qty,
      cost: cost ?? this.cost,
      weight: weight ?? this.weight,
      extra: extra ?? this.extra,
      bonded: bonded ?? this.bonded,
      forcedValue: forcedValue ?? this.forcedValue,
      parentId: parentId ?? this.parentId,
      allowRename: allowRename ?? this.allowRename,
      children: children ?? this.children,
      location: location ?? this.location,
      active: active ?? this.active,
    );
  }

  factory Gear.fromXml(XmlElement xmlElement) {
    int gearRating =
        int.tryParse(xmlElement.getElement('rating')?.innerText ?? '0') ?? 0;

    // Handle name selection priority: extra > name > default
    final extraText = xmlElement.getElement('extra')?.innerText;
    final nameText = xmlElement.getElement('name')?.innerText;
    final categoryText = xmlElement.getElement('category')?.innerText;
    final sourceText = xmlElement.getElement('source')?.innerText;
    final pageText = xmlElement.getElement('page')?.innerText;

    final String rawLocationGuid =
        xmlElement.getElement('location')?.innerText ?? '';
    final String locationGuid =
        rawLocationGuid.isNotEmpty ? rawLocationGuid : defaultGearLocationGuid;

    String finalName;
    //finalName uses extraText if present, otherwise nameText, or falls back to default
    if (extraText?.isNotEmpty == true) {
      finalName = extraText!;
    } else if (nameText?.isNotEmpty == true) {
      finalName = nameText!;
    } else {
      finalName = 'Unnamed Gear';
    }

    return Gear(
      sourceId: xmlElement.getElement('sourceid')?.innerText,
      locationGuid: locationGuid,
      name: finalName,
      category: categoryText?.isNotEmpty == true ? categoryText! : 'Unknown',
      source: sourceText?.isNotEmpty == true ? sourceText! : 'Unknown',
      page: pageText?.isNotEmpty == true ? pageText! : '0',
      equipped: xmlElement.getElement('equipped')?.innerText == 'True',
      wirelessOn: xmlElement.getElement('wirelesson')?.innerText == 'True',
      stolen: xmlElement.getElement('stolen')?.innerText == 'True',
      capacity: xmlElement.getElement('capacity')?.innerText,
      armorCapacity: xmlElement.getElement('armorcapacity')?.innerText,
      minRating: xmlElement.getElement('minrating')?.innerText,
      maxRating: xmlElement.getElement('maxrating')?.innerText,
      rating: gearRating,
      qty: double.tryParse(xmlElement.getElement('qty')?.innerText ?? '1.0') ??
          1.0,
      avail: parseAvail(xmlElement.getElement('avail'), gearRating),
      cost: double.tryParse(xmlElement.getElement('cost')?.innerText ?? '0') ?? 0,
      weight: xmlElement.getElement('weight')?.innerText,
      extra: xmlElement.getElement('extra')?.innerText,
      bonded: xmlElement.getElement('bonded')?.innerText == 'True',
      forcedValue: xmlElement.getElement('forcedvalue')?.innerText,
      parentId: xmlElement.getElement('parentid')?.innerText,
      allowRename: xmlElement.getElement('allowrename')?.innerText == 'True',
      children: xmlElement
          .findElements('children')
          .expand((e) => e.findElements('gear'))
          .map((childXml) => Gear.fromXml(childXml))
          .toList(),
      location: xmlElement.getElement('location')?.innerText,
      notes: xmlElement.getElement('notes')?.innerText,
      notesColor: xmlElement.getElement('notesColor')?.innerText,
      discountedCost:
          xmlElement.getElement('discountedcost')?.innerText == 'True',
      sortOrder:
          int.tryParse(xmlElement.getElement('sortorder')?.innerText ?? '0') ??
              0,
      active: xmlElement.getElement('active')?.innerText == 'True',
    );
  }

  @override
  Icon getIcon(Color? color) {
    return switch (category.toLowerCase()) {
      'tools' => Icon(Icons.handyman_outlined, color: color),
      'commlinks' => Icon(Icons.smartphone_outlined, color: color),
      'elecrtronics accessories' => Icon(Icons.mic_external_on_outlined, color: color),
      'id/credsticks' => Icon(Icons.credit_card_outlined, color: color),
      'hacking programs' => Icon(Icons.code_outlined, color: color),
      'ammunition' => Icon(Icons.bolt_outlined, color: color),
      'autosoft' => Icon(Icons.book_outlined, color: color),
      'chemicals' => Icon(Icons.science_outlined, color: color),
      'cyberdecks' => Icon(Icons.laptop_outlined, color: color),
      'btls' => Icon(Icons.video_collection_outlined, color: color),
      'drugs' => Icon(Icons.local_pharmacy_outlined, color: color),
      'explosives' => Icon(Icons.stream_outlined, color: color),
      'food' => Icon(Icons.fastfood_outlined, color: color),
      'currency' => Icon(Icons.currency_yen_outlined, color: color),
      'paydata' => Icon(Icons.cases_outlined, color: color),
      'skillsofts' => Icon(Icons.school_outlined, color: color),
      'survival gear' => Icon(Icons.flashlight_on_rounded, color: color),
      _ => Icon(Icons.miscellaneous_services_outlined, color: color)
    };
  }

  @override
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    // Check base fields first (name, category)
    if (super.matchesSearch(query)) return true;
    
    // Check if any child matches recursively
    return children?.any((child) => child.matchesSearch(query)) ?? false;
  }

  /// For filtering that preserves the gear hierarchy
  @override
  Gear? filterWithHierarchy(String query) {
    if (query.isEmpty) return this;
    
    final filteredChildren = children
        ?.map((child) => child.filterWithHierarchy(query))
        .where((child) => child != null)
        .cast<Gear>()
        .toList();
    
    // Include this item if it matches OR if it has matching children
    if (matchesSearch(query) || (filteredChildren?.isNotEmpty ?? false)) {
      return copyWith(children: filteredChildren);
    }
    
    return null;
  }

  @override
  String get details {
    return 'Category: $category, Source: $source p. $page, Cost: $cost¥, Quantity: $qty, Availability: $avail';
  }

  @override
  Widget getDetailsContent(BuildContext context, {Map<String, int>? characterAttributes, Function? onUpdate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDetailRow(context, 'Category', category, attributes: characterAttributes),
        buildDetailRow(context, 'Source', '$source p. $page', attributes: characterAttributes),
        buildDetailRow(context, 'Availability', avail, attributes: characterAttributes),
        buildDetailRow(context, 'Cost', '$cost¥', attributes: characterAttributes),
        buildDetailRow(context, 'Quantity', qty.toString(), attributes: characterAttributes),
        if (rating > 0) buildDetailRow(context, 'Rating', rating.toString(), rating: rating, attributes: characterAttributes),
        if (capacity != null) buildDetailRow(context, 'Capacity', capacity!, attributes: characterAttributes),
        if (weight != null) buildDetailRow(context, 'Weight', weight!, attributes: characterAttributes),
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
        if (category.toLowerCase() == 'commlinks')
          buildToggleRow(context, 'Active Commlink', active, (value) {
            if (onUpdate != null) {
              onUpdate(this, active: value);
            }
          }),
      ],
    );
  }
}
