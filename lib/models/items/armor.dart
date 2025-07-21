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
    super.guid,
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
    int armorRating = int.tryParse(xmlElement.getElement('armor')?.text ?? '0') ?? 0;
    return Armor(
      sourceId: xmlElement.getElement('sourceid')?.text,
      guid: xmlElement.getElement('guid')?.text,
      name: xmlElement.getElement('name')?.text ?? 'Unnamed Armor',
      category: xmlElement.getElement('category')?.text ?? 'Unknown',
      armorValue: xmlElement.getElement('armor')?.text ?? '0',
      armorOverride: xmlElement.getElement('armoroverride')?.text,
      armorCapacity: xmlElement.getElement('armorcapacity')?.text ?? '0',
      avail: parseAvail(xmlElement.getElement('avail'), armorRating),
      cost: int.tryParse(xmlElement.getElement('cost')?.text ?? '0') ?? 0,
      weight: xmlElement.getElement('weight')?.text,
      source: xmlElement.getElement('source')?.text ?? 'Unknown',
      page: xmlElement.getElement('page')?.text ?? '0',
      armorName: xmlElement.getElement('armorname')?.text,
      equipped: xmlElement.getElement('equipped')?.text == 'True',
      active: xmlElement.getElement('active')?.text == 'True',
      homeNode: xmlElement.getElement('homenode')?.text == 'True',
      deviceRating: xmlElement.getElement('devicerating')?.text,
      programLimit: xmlElement.getElement('programlimit')?.text,
      overclocked: xmlElement.getElement('overclocked')?.text,
      attack: xmlElement.getElement('attack')?.text,
      sleaze: xmlElement.getElement('sleaze')?.text,
      dataProcessing: xmlElement.getElement('dataprocessing')?.text,
      firewall: xmlElement.getElement('firewall')?.text,
      wirelessOn: xmlElement.getElement('wirelesson')?.text == 'True',
      canFormPersona: xmlElement.getElement('canformpersona')?.text == 'True',
      extra: xmlElement.getElement('extra')?.text,
      damage: int.tryParse(xmlElement.getElement('damage')?.text ?? '0') ?? 0,
      rating: armorRating,
      maxRating: int.tryParse(xmlElement.getElement('maxrating')?.text ?? '0') ?? 0,
      ratingLabel: xmlElement.getElement('ratinglabel')?.text ?? 'String_Rating',
      stolen: xmlElement.getElement('stolen')?.text == 'True',
      encumbrance: xmlElement.getElement('emcumbrance')?.text == 'True',
      armorMods: xmlElement.findElements('armormods').expand((e) => e.findElements('armormod')).map((modXml) => ArmorMod.fromXml(modXml)).toList(),
      location: xmlElement.getElement('location')?.text,
      notes: xmlElement.getElement('notes')?.text,
      notesColor: xmlElement.getElement('notesColor')?.text,
      discountedCost: xmlElement.getElement('discountedcost')?.text == 'True',
      sortOrder: int.tryParse(xmlElement.getElement('sortorder')?.text ?? '0') ?? 0,
    );
  }
}