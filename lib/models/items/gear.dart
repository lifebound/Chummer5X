import 'package:chummer5x/models/items/location.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/utils/availability_parser.dart';

class Gear extends ShadowrunItem {
  // ... Gear-specific final fields remain as they are.
  final String? capacity;
  final String? armorCapacity;
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
  });


  factory Gear.fromXml(XmlElement xmlElement) {
    int gearRating = int.tryParse(xmlElement.getElement('rating')?.innerText ?? '0') ?? 0;
    
    // Handle name selection priority: extra > name > default
    final extraText = xmlElement.getElement('extra')?.innerText;
    final nameText = xmlElement.getElement('name')?.innerText;
    final categoryText = xmlElement.getElement('category')?.innerText;
    final sourceText = xmlElement.getElement('source')?.innerText;
    final pageText = xmlElement.getElement('page')?.innerText;
    
    final String rawLocationGuid = xmlElement.getElement('location')?.innerText ?? '';
    final String locationGuid = rawLocationGuid.isNotEmpty ? rawLocationGuid : defaultGearLocationGuid;



    String finalName;
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
      qty: double.tryParse(xmlElement.getElement('qty')?.innerText ?? '1.0') ?? 1.0,
      avail: parseAvail(xmlElement.getElement('avail'), gearRating),
      cost: int.tryParse(xmlElement.getElement('cost')?.innerText ?? '0') ?? 0,
      weight: xmlElement.getElement('weight')?.innerText,
      extra: xmlElement.getElement('extra')?.innerText,
      bonded: xmlElement.getElement('bonded')?.innerText == 'True',
      forcedValue: xmlElement.getElement('forcedvalue')?.innerText,
      parentId: xmlElement.getElement('parentid')?.innerText,
      allowRename: xmlElement.getElement('allowrename')?.innerText == 'True',
      children: xmlElement.findElements('children').expand((e) => e.findElements('gear')).map((childXml) => Gear.fromXml(childXml)).toList(),
      location: xmlElement.getElement('location')?.innerText,
      notes: xmlElement.getElement('notes')?.innerText,
      notesColor: xmlElement.getElement('notesColor')?.innerText,
      discountedCost: xmlElement.getElement('discountedcost')?.innerText == 'True',
      sortOrder: int.tryParse(xmlElement.getElement('sortorder')?.innerText ?? '0') ?? 0,
    );
  }
}