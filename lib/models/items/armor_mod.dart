import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';


class ArmorMod extends ShadowrunItem {
  final int armor;
  final String armorCapacity;
  final String? gearCapacity;
  final int maxRating;
  final int rating;
  final String ratingLabel;
  final String? weight;
  final bool included;
  final String? extra;

  ArmorMod({
    super.sourceId,
    required super.name,
    required super.category,
    this.armor = 0,
    required this.armorCapacity,
    this.gearCapacity,
    this.maxRating = 0,
    this.rating = 0,
    this.ratingLabel = 'String_Rating',
    super.avail = '-',
    super.cost = 0,
    this.weight,
    required super.source,
    required super.page,
    this.included = false,
    super.equipped = false,
    this.extra,
    super.stolen = false,
    super.notes,
    super.notesColor,
    super.discountedCost = false,
    super.sortOrder = 0,
    super.wirelessOn = false,
  }) : super();

  factory ArmorMod.fromXml(XmlElement xmlElement) {
    final nameText = xmlElement.getElement('name')?.innerText;
    final categoryText = xmlElement.getElement('category')?.innerText;
    final sourceText = xmlElement.getElement('source')?.innerText;
    final pageText = xmlElement.getElement('page')?.innerText;
    
    return ArmorMod(
      sourceId: xmlElement.getElement('sourceid')?.innerText,
      name: nameText?.isNotEmpty == true ? nameText! : 'Unnamed Armor Mod',
      category: categoryText?.isNotEmpty == true ? categoryText! : 'Unknown',
      armor: int.tryParse(xmlElement.getElement('armor')?.innerText ?? '0') ?? 0,
      armorCapacity: xmlElement.getElement('armorcapacity')?.innerText ?? '0',
      gearCapacity: xmlElement.getElement('gearcapacity')?.innerText,
      maxRating: int.tryParse(xmlElement.getElement('maxrating')?.innerText ?? '0') ?? 0,
      rating: int.tryParse(xmlElement.getElement('rating')?.innerText ?? '0') ?? 0,
      ratingLabel: xmlElement.getElement('ratinglabel')?.innerText ?? 'String_Rating',
      avail: xmlElement.getElement('avail')?.innerText ?? '-',
      cost: int.tryParse(xmlElement.getElement('cost')?.innerText ?? '0') ?? 0,
      weight: xmlElement.getElement('weight')?.innerText,
      source: sourceText?.isNotEmpty == true ? sourceText! : 'Unknown',
      page: pageText?.isNotEmpty == true ? pageText! : '0',
      included: xmlElement.getElement('included')?.innerText == 'True',
      equipped: xmlElement.getElement('equipped')?.innerText == 'True',
      extra: xmlElement.getElement('extra')?.innerText,
      stolen: xmlElement.getElement('stolen')?.innerText == 'True',
      notes: xmlElement.getElement('notes')?.innerText,
      notesColor: xmlElement.getElement('notesColor')?.innerText,
      discountedCost: xmlElement.getElement('discountedcost')?.innerText == 'True',
      sortOrder: int.tryParse(xmlElement.getElement('sortorder')?.innerText ?? '0') ?? 0,
      wirelessOn: xmlElement.getElement('wirelesson')?.innerText == 'True',
    );
  }

  ArmorMod copyWith({
    String? sourceId,
    String? name,
    String? category,
    int? armor,
    String? armorCapacity,
    String? gearCapacity,
    int? maxRating,
    int? rating,
    String? ratingLabel,
    String? avail,
    int? cost,
    String? weight,
    String? source,
    String? page,
    bool? included,
    bool? equipped,
    String? extra,
    bool? stolen,
    String? notes,
    String? notesColor,
    bool? discountedCost,
    int? sortOrder,
    bool? wirelessOn,
  }) {
    return ArmorMod(
      sourceId: sourceId ?? this.sourceId,
      name: name ?? this.name,
      category: category ?? this.category,
      armor: armor ?? this.armor,
      armorCapacity: armorCapacity ?? this.armorCapacity,
      gearCapacity: gearCapacity ?? this.gearCapacity,
      maxRating: maxRating ?? this.maxRating,
      rating: rating ?? this.rating,
      ratingLabel: ratingLabel ?? this.ratingLabel,
      avail: avail ?? this.avail,
      cost: cost ?? this.cost,
      weight: weight ?? this.weight,
      source: source ?? this.source,
      page: page ?? this.page,
      included: included ?? this.included,
      equipped: equipped ?? this.equipped,
      extra: extra ?? this.extra,
      stolen: stolen ?? this.stolen,
      notes: notes ?? this.notes,
      notesColor: notesColor ?? this.notesColor,
      discountedCost: discountedCost ?? this.discountedCost,
      sortOrder: sortOrder ?? this.sortOrder,
      wirelessOn: wirelessOn ?? this.wirelessOn,
    );
  }

  @override
  ArmorMod? filterWithHierarchy(String query) {
    if (query.isEmpty) return this;
    return matchesSearch(query) ? this : null;
  }

  @override
  String get details {
    return 'Category: $category, Source: $source p. $page, Cost: $cost¥, Availability: $avail';
  }

  @override
  Widget getDetailsContent(BuildContext context, {Function? onUpdate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDetailRow(context, 'Category', category),
        if (rating > 0) buildDetailRow(context, 'Rating', rating.toString()),
        if (ratingLabel != 'String_Rating') buildDetailRow(context, 'Rating Label', ratingLabel),
        buildDetailRow(context, 'Source', '$source p. $page'),
        buildDetailRow(context, 'Availability', avail),
        buildDetailRow(context, 'Cost', '$cost¥'),
        if (weight != null) buildDetailRow(context, 'Weight', weight!),
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