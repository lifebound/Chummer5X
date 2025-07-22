import 'package:chummer5x/models/items/location.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:chummer5x/utils/availability_parser.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/armor_mod.dart';

class Armor extends ShadowrunItem {
  final String armorValue;
  final String? armorOverride;
  final String armorCapacity;
  final int cost;
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
    required this.armorValue,
    this.armorOverride,
    required this.armorCapacity,
    this.cost = 0,
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
    super.avail = '0',
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
}