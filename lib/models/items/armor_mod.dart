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
    final nameText = xmlElement.getElement('name')?.text;
    final categoryText = xmlElement.getElement('category')?.text;
    final sourceText = xmlElement.getElement('source')?.text;
    final pageText = xmlElement.getElement('page')?.text;
    
    return ArmorMod(
      sourceId: xmlElement.getElement('sourceid')?.text,
      guid: xmlElement.getElement('guid')?.text,
      name: nameText?.isNotEmpty == true ? nameText! : 'Unnamed Armor Mod',
      category: categoryText?.isNotEmpty == true ? categoryText! : 'Unknown',
      armor: int.tryParse(xmlElement.getElement('armor')?.text ?? '0') ?? 0,
      armorCapacity: xmlElement.getElement('armorcapacity')?.text ?? '0',
      gearCapacity: xmlElement.getElement('gearcapacity')?.text,
      maxRating: int.tryParse(xmlElement.getElement('maxrating')?.text ?? '0') ?? 0,
      rating: int.tryParse(xmlElement.getElement('rating')?.text ?? '0') ?? 0,
      ratingLabel: xmlElement.getElement('ratinglabel')?.text ?? 'String_Rating',
      avail: xmlElement.getElement('avail')?.text,
      cost: xmlElement.getElement('cost')?.text ?? '0',
      weight: xmlElement.getElement('weight')?.text,
      source: sourceText?.isNotEmpty == true ? sourceText! : 'Unknown',
      page: pageText?.isNotEmpty == true ? pageText! : '0',
      included: xmlElement.getElement('included')?.text == 'True',
      equipped: xmlElement.getElement('equipped')?.text == 'True',
      extra: xmlElement.getElement('extra')?.text,
      stolen: xmlElement.getElement('stolen')?.text == 'True',
      notes: xmlElement.getElement('notes')?.text,
      notesColor: xmlElement.getElement('notesColor')?.text,
      discountedCost: xmlElement.getElement('discountedcost')?.text == 'True',
      sortOrder: int.tryParse(xmlElement.getElement('sortorder')?.text ?? '0') ?? 0,
      wirelessOn: xmlElement.getElement('wirelesson')?.text == 'True',
    );
  }
}