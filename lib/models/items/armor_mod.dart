import 'package:xml/xml.dart';


class ArmorMod {
  final String? sourceId;
  final String? guid;
  final String name;
  final String category;
  final int armor;
  final String armorCapacity;
  final String? gearCapacity;
  final int maxRating;
  final int rating;
  final String ratingLabel;
  final String? avail;
  final String cost;
  final String? weight;
  final String source;
  final String page;
  final bool included;
  final bool equipped;
  final String? extra;
  final bool stolen;
  final String? notes;
  final String? notesColor;
  final bool discountedCost;
  final int sortOrder;
  final bool wirelessOn;

  ArmorMod({
    this.sourceId,
    this.guid,
    required this.name,
    required this.category,
    this.armor = 0,
    required this.armorCapacity,
    this.gearCapacity,
    this.maxRating = 0,
    this.rating = 0,
    this.ratingLabel = 'String_Rating',
    this.avail,
    this.cost = '0',
    this.weight,
    required this.source,
    required this.page,
    this.included = false,
    this.equipped = false,
    this.extra,
    this.stolen = false,
    this.notes,
    this.notesColor,
    this.discountedCost = false,
    this.sortOrder = 0,
    this.wirelessOn = false,
  });

  factory ArmorMod.fromXml(XmlElement xmlElement) {
    final nameText = xmlElement.getElement('name')?.innerText;
    final categoryText = xmlElement.getElement('category')?.innerText;
    final sourceText = xmlElement.getElement('source')?.innerText;
    final pageText = xmlElement.getElement('page')?.innerText;
    
    return ArmorMod(
      sourceId: xmlElement.getElement('sourceid')?.innerText,
      guid: xmlElement.getElement('guid')?.innerText,
      name: nameText?.isNotEmpty == true ? nameText! : 'Unnamed Armor Mod',
      category: categoryText?.isNotEmpty == true ? categoryText! : 'Unknown',
      armor: int.tryParse(xmlElement.getElement('armor')?.innerText ?? '0') ?? 0,
      armorCapacity: xmlElement.getElement('armorcapacity')?.innerText ?? '0',
      gearCapacity: xmlElement.getElement('gearcapacity')?.innerText,
      maxRating: int.tryParse(xmlElement.getElement('maxrating')?.innerText ?? '0') ?? 0,
      rating: int.tryParse(xmlElement.getElement('rating')?.innerText ?? '0') ?? 0,
      ratingLabel: xmlElement.getElement('ratinglabel')?.innerText ?? 'String_Rating',
      avail: xmlElement.getElement('avail')?.innerText,
      cost: xmlElement.getElement('cost')?.innerText ?? '0',
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
}