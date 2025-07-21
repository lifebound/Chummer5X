import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/gear.dart';

class WeaponAccessory {
  final String? sourceId;
  final String? guid;
  final String name;
  final String mount;
  final String extraMount;
  final String? rc;
  final int maxRating;
  final int rating;
  final String ratingLabel;
  final int rcGroup;
  final bool rcDeployable;
  final bool specialModification;
  final String? conceal;
  final String avail;
  final String cost; // Can be "Weapon Cost"
  final String? weight;
  final bool included;
  final bool equipped;
  final String source;
  final String page;
  final String? accuracy;
  final List<Gear>? gears; // Accessories can contain gears
  final String? ammoReplace;
  final int ammoSlots;
  final String? modifyAmmoCapacity;
  final String? damageType;
  final String? damage;
  final String? reach;
  final String? damageReplace;
  final String? fireMode;
  final String? fireModeReplace;
  final String? ap;
  final String? apReplace;
  final String? notes;
  final String? notesColor;
  final bool discountedCost;
  final int singleShot;
  final int shortBurst;
  final int longBurst;
  final int fullBurst;
  final int suppressive;
  final int rangeBonus;
  final int rangeModifier;
  final String? extra;
  final String? ammoBonus;
  final bool wirelessOn;
  final bool stolen;
  final int sortOrder;
  final String? parentId;

  WeaponAccessory({
    this.sourceId,
    this.guid,
    required this.name,
    required this.mount,
    required this.extraMount,
    this.rc,
    this.maxRating = 0,
    this.rating = 0,
    this.ratingLabel = 'String_Rating',
    this.rcGroup = 0,
    this.rcDeployable = false,
    this.specialModification = false,
    this.conceal,
    required this.avail,
    required this.cost,
    this.weight,
    this.included = false,
    this.equipped = false,
    required this.source,
    required this.page,
    this.accuracy,
    this.gears,
    this.ammoReplace,
    this.ammoSlots = 0,
    this.modifyAmmoCapacity,
    this.damageType,
    this.damage,
    this.reach,
    this.damageReplace,
    this.fireMode,
    this.fireModeReplace,
    this.ap,
    this.apReplace,
    this.notes,
    this.notesColor,
    this.discountedCost = false,
    this.singleShot = 0,
    this.shortBurst = 0,
    this.longBurst = 0,
    this.fullBurst = 0,
    this.suppressive = 0,
    this.rangeBonus = 0,
    this.rangeModifier = 0,
    this.extra,
    this.ammoBonus,
    this.wirelessOn = false,
    this.stolen = false,
    this.sortOrder = 0,
    this.parentId,
  });

  factory WeaponAccessory.fromXml(XmlElement xmlElement) {
    return WeaponAccessory(
      sourceId: xmlElement.getElement('sourceid')?.text,
      guid: xmlElement.getElement('guid')?.text,
      name: xmlElement.getElement('name')?.text ?? 'Unnamed Accessory',
      mount: xmlElement.getElement('mount')?.text ?? 'None',
      extraMount: xmlElement.getElement('extramount')?.text ?? 'None',
      rc: xmlElement.getElement('rc')?.text,
      maxRating: int.tryParse(xmlElement.getElement('maxrating')?.text ?? '0') ?? 0,
      rating: int.tryParse(xmlElement.getElement('rating')?.text ?? '0') ?? 0,
      ratingLabel: xmlElement.getElement('ratinglabel')?.text ?? 'String_Rating',
      rcGroup: int.tryParse(xmlElement.getElement('rcgroup')?.text ?? '0') ?? 0,
      rcDeployable: xmlElement.getElement('rcdeployable')?.text == 'True',
      specialModification: xmlElement.getElement('specialmodification')?.text == 'True',
      conceal: xmlElement.getElement('conceal')?.text,
      avail: xmlElement.getElement('avail')?.text ?? '',
      cost: xmlElement.getElement('cost')?.text ?? '0',
      weight: xmlElement.getElement('weight')?.text,
      included: xmlElement.getElement('included')?.text == 'True',
      equipped: xmlElement.getElement('equipped')?.text == 'True',
      source: xmlElement.getElement('source')?.text ?? 'Unknown',
      page: xmlElement.getElement('page')?.text ?? '0',
      accuracy: xmlElement.getElement('accuracy')?.text,
      gears: xmlElement.findElements('gears').expand((e) => e.findElements('gear')).map((gearXml) => Gear.fromXml(gearXml)).toList(),
      ammoReplace: xmlElement.getElement('ammoreplace')?.text,
      ammoSlots: int.tryParse(xmlElement.getElement('ammoslots')?.text ?? '0') ?? 0,
      modifyAmmoCapacity: xmlElement.getElement('modifyammocapacity')?.text,
      damageType: xmlElement.getElement('damagetype')?.text,
      damage: xmlElement.getElement('damage')?.text,
      reach: xmlElement.getElement('reach')?.text,
      damageReplace: xmlElement.getElement('damagereplace')?.text,
      fireMode: xmlElement.getElement('firemode')?.text,
      fireModeReplace: xmlElement.getElement('firemodereplace')?.text,
      ap: xmlElement.getElement('ap')?.text,
      apReplace: xmlElement.getElement('apreplace')?.text,
      notes: xmlElement.getElement('notes')?.text,
      notesColor: xmlElement.getElement('notesColor')?.text,
      discountedCost: xmlElement.getElement('discountedcost')?.text == 'True',
      singleShot: int.tryParse(xmlElement.getElement('singleshot')?.text ?? '0') ?? 0,
      shortBurst: int.tryParse(xmlElement.getElement('shortburst')?.text ?? '0') ?? 0,
      longBurst: int.tryParse(xmlElement.getElement('longburst')?.text ?? '0') ?? 0,
      fullBurst: int.tryParse(xmlElement.getElement('fullburst')?.text ?? '0') ?? 0,
      suppressive: int.tryParse(xmlElement.getElement('suppressive')?.text ?? '0') ?? 0,
      rangeBonus: int.tryParse(xmlElement.getElement('rangebonus')?.text ?? '0') ?? 0,
      rangeModifier: int.tryParse(xmlElement.getElement('rangemodifier')?.text ?? '0') ?? 0,
      extra: xmlElement.getElement('extra')?.text,
      ammoBonus: xmlElement.getElement('ammobonus')?.text,
      wirelessOn: xmlElement.getElement('wirelesson')?.text == 'True',
      stolen: xmlElement.getElement('stolen')?.text == 'True',
      sortOrder: int.tryParse(xmlElement.getElement('sortorder')?.text ?? '0') ?? 0,
      parentId: xmlElement.getElement('parentid')?.text,
    );
  }
}