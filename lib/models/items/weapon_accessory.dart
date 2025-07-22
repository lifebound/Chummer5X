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
      sourceId: xmlElement.getElement('sourceid')?.innerText,
      guid: xmlElement.getElement('guid')?.innerText,
      name: xmlElement.getElement('name')?.innerText ?? 'Unnamed Accessory',
      mount: xmlElement.getElement('mount')?.innerText ?? 'None',
      extraMount: xmlElement.getElement('extramount')?.innerText ?? 'None',
      rc: xmlElement.getElement('rc')?.innerText,
      maxRating: int.tryParse(xmlElement.getElement('maxrating')?.innerText ?? '0') ?? 0,
      rating: int.tryParse(xmlElement.getElement('rating')?.innerText ?? '0') ?? 0,
      ratingLabel: xmlElement.getElement('ratinglabel')?.innerText ?? 'String_Rating',
      rcGroup: int.tryParse(xmlElement.getElement('rcgroup')?.innerText ?? '0') ?? 0,
      rcDeployable: xmlElement.getElement('rcdeployable')?.innerText == 'True',
      specialModification: xmlElement.getElement('specialmodification')?.innerText == 'True',
      conceal: xmlElement.getElement('conceal')?.innerText,
      avail: xmlElement.getElement('avail')?.innerText ?? '',
      cost: xmlElement.getElement('cost')?.innerText ?? '0',
      weight: xmlElement.getElement('weight')?.innerText,
      included: xmlElement.getElement('included')?.innerText == 'True',
      equipped: xmlElement.getElement('equipped')?.innerText == 'True',
      source: xmlElement.getElement('source')?.innerText ?? 'Unknown',
      page: xmlElement.getElement('page')?.innerText ?? '0',
      accuracy: xmlElement.getElement('accuracy')?.innerText,
      gears: xmlElement.findElements('gears').expand((e) => e.findElements('gear')).map((gearXml) => Gear.fromXml(gearXml)).toList(),
      ammoReplace: xmlElement.getElement('ammoreplace')?.innerText,
      ammoSlots: int.tryParse(xmlElement.getElement('ammoslots')?.innerText ?? '0') ?? 0,
      modifyAmmoCapacity: xmlElement.getElement('modifyammocapacity')?.innerText,
      damageType: xmlElement.getElement('damagetype')?.innerText,
      damage: xmlElement.getElement('damage')?.innerText,
      reach: xmlElement.getElement('reach')?.innerText,
      damageReplace: xmlElement.getElement('damagereplace')?.innerText,
      fireMode: xmlElement.getElement('firemode')?.innerText,
      fireModeReplace: xmlElement.getElement('firemodereplace')?.innerText,
      ap: xmlElement.getElement('ap')?.innerText,
      apReplace: xmlElement.getElement('apreplace')?.innerText,
      notes: xmlElement.getElement('notes')?.innerText,
      notesColor: xmlElement.getElement('notesColor')?.innerText,
      discountedCost: xmlElement.getElement('discountedcost')?.innerText == 'True',
      singleShot: int.tryParse(xmlElement.getElement('singleshot')?.innerText ?? '0') ?? 0,
      shortBurst: int.tryParse(xmlElement.getElement('shortburst')?.innerText ?? '0') ?? 0,
      longBurst: int.tryParse(xmlElement.getElement('longburst')?.innerText ?? '0') ?? 0,
      fullBurst: int.tryParse(xmlElement.getElement('fullburst')?.innerText ?? '0') ?? 0,
      suppressive: int.tryParse(xmlElement.getElement('suppressive')?.innerText ?? '0') ?? 0,
      rangeBonus: int.tryParse(xmlElement.getElement('rangebonus')?.innerText ?? '0') ?? 0,
      rangeModifier: int.tryParse(xmlElement.getElement('rangemodifier')?.innerText ?? '0') ?? 0,
      extra: xmlElement.getElement('extra')?.innerText,
      ammoBonus: xmlElement.getElement('ammobonus')?.innerText,
      wirelessOn: xmlElement.getElement('wirelesson')?.innerText == 'True',
      stolen: xmlElement.getElement('stolen')?.innerText == 'True',
      sortOrder: int.tryParse(xmlElement.getElement('sortorder')?.innerText ?? '0') ?? 0,
      parentId: xmlElement.getElement('parentid')?.innerText,
    );
  }
}