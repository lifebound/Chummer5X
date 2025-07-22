import 'package:chummer5x/models/items/location.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/utils/availability_parser.dart';

class Gear extends ShadowrunItem {
  final String? capacity;
  final String? armorCapacity;
  final String? minRating;
  final String? maxRating;
  final int rating;
  final double qty;
  @override
  final String avail;
  final int cost;
  final String? weight;
  final String? extra;
  final bool bonded;
  final String? gearName;
  final String? forcedValue;
  final String? parentId;
  final bool allowRename;
  final List<Gear>? children; // Gear can contain other gears
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
    this.capacity,
    this.armorCapacity,
    this.minRating,
    this.maxRating,
    this.rating = 0,
    this.qty = 1.0,
    this.avail = '0',
    this.cost = 0,
    this.weight,
    this.extra,
    this.bonded = false,
    this.gearName,
    this.forcedValue,
    this.parentId,
    this.allowRename = false,
    this.children,
    this.location,
    super.notes,
    super.notesColor,
    super.discountedCost,
    super.sortOrder,
  }) : super(
          avail: avail,
        );

  factory Gear.fromXml(XmlElement xmlElement) {
    int gearRating = int.tryParse(xmlElement.getElement('rating')?.text ?? '0') ?? 0;
    
    // Handle name selection priority: extra > name > default
    final extraText = xmlElement.getElement('extra')?.text;
    final nameText = xmlElement.getElement('name')?.text;
    final categoryText = xmlElement.getElement('category')?.text;
    final sourceText = xmlElement.getElement('source')?.text;
    final pageText = xmlElement.getElement('page')?.text;
    
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
      sourceId: xmlElement.getElement('sourceid')?.text,
      locationGuid: locationGuid,
      name: finalName,
      category: categoryText?.isNotEmpty == true ? categoryText! : 'Unknown',
      source: sourceText?.isNotEmpty == true ? sourceText! : 'Unknown',
      page: pageText?.isNotEmpty == true ? pageText! : '0',
      equipped: xmlElement.getElement('equipped')?.text == 'True',
      wirelessOn: xmlElement.getElement('wirelesson')?.text == 'True',
      stolen: xmlElement.getElement('stolen')?.text == 'True',
      capacity: xmlElement.getElement('capacity')?.text,
      armorCapacity: xmlElement.getElement('armorcapacity')?.text,
      minRating: xmlElement.getElement('minrating')?.text,
      maxRating: xmlElement.getElement('maxrating')?.text,
      rating: gearRating,
      qty: double.tryParse(xmlElement.getElement('qty')?.text ?? '1.0') ?? 1.0,
      avail: parseAvail(xmlElement.getElement('avail'), gearRating),
      cost: int.tryParse(xmlElement.getElement('cost')?.text ?? '0') ?? 0,
      weight: xmlElement.getElement('weight')?.text,
      extra: xmlElement.getElement('extra')?.text,
      bonded: xmlElement.getElement('bonded')?.text == 'True',
      gearName: xmlElement.getElement('gearname')?.text,
      forcedValue: xmlElement.getElement('forcedvalue')?.text,
      parentId: xmlElement.getElement('parentid')?.text,
      allowRename: xmlElement.getElement('allowrename')?.text == 'True',
      children: xmlElement.findElements('children').expand((e) => e.findElements('gear')).map((childXml) => Gear.fromXml(childXml)).toList(),
      location: xmlElement.getElement('location')?.text,
      notes: xmlElement.getElement('notes')?.text,
      notesColor: xmlElement.getElement('notesColor')?.text,
      discountedCost: xmlElement.getElement('discountedcost')?.text == 'True',
      sortOrder: int.tryParse(xmlElement.getElement('sortorder')?.text ?? '0') ?? 0,
    );
  }
}