import 'package:chummer5x/models/items/location.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/weapon_accessory.dart';
import 'package:chummer5x/utils/availability_parser.dart';


class Weapon extends ShadowrunItem {
  final String type;
  final String? spec;
  final String? spec2;
  final int reach;
  final String damage;
  final String ap;
  final String mode;
  final int rc;
  final String ammo;
  final bool cyberware;
  final String? ammoCategory;
  final int ammoSlots;
  final String? sizeCategory;
  final String firingMode;
  final String? minRating;
  final String? maxRating;
  final int rating;
  final String accuracy;
  final int activeAmmoSlot;
  final String conceal;
  final int cost;
  final String? weight;
  final String? useSkill;
  final String? useSkillSpec;
  final String? range;
  final String? alternateRange;
  final int rangeMultiply;
  final int singleShot;
  final int shortBurst;
  final int longBurst;
  final int fullBurst;
  final int suppressive;
  final bool allowSingleShot;
  final bool allowShortBurst;
  final bool allowLongBurst;
  final bool allowFullBurst;
  final bool allowSuppressive;
  final String? parentId;
  final bool allowAccessory;
  final String? weaponName;
  final bool included;
  final bool requireAmmo;
  final String? mount;
  final String? extraMount;
  final List<WeaponAccessory>? accessories;
  final String? location;
  final String? weaponType;

  Weapon({
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
    super.matrixCmFilled = 0,
    super.matrixCmBonus,
    super.notes,
    super.notesColor,
    super.discountedCost,
    super.sortOrder,
    required this.type,
    this.spec,
    this.spec2,
    this.reach = 0,
    required this.damage,
    required this.ap,
    required this.mode,
    this.rc = 0,
    required this.ammo,
    this.cyberware = false,
    this.ammoCategory,
    this.ammoSlots = 1,
    this.sizeCategory,
    required this.firingMode,
    this.minRating,
    this.maxRating,
    this.rating = 0,
    required this.accuracy,
    this.activeAmmoSlot = 1,
    this.conceal = '0',
    this.cost = 0,
    this.weight,
    this.useSkill,
    this.useSkillSpec,
    this.range,
    this.alternateRange,
    this.rangeMultiply = 1,
    this.singleShot = 1,
    this.shortBurst = 3,
    this.longBurst = 6,
    this.fullBurst = 10,
    this.suppressive = 20,
    this.allowSingleShot = true,
    this.allowShortBurst = true,
    this.allowLongBurst = true,
    this.allowFullBurst = true,
    this.allowSuppressive = true,
    this.parentId,
    this.allowAccessory = false,
    this.weaponName,
    this.included = false,
    this.requireAmmo = true,
    this.mount,
    this.extraMount,
    this.accessories,
    this.location,
    this.weaponType,
    required super.avail
  });

  factory Weapon.fromXml(XmlElement xmlElement) {
    int weaponRating = int.tryParse(xmlElement.getElement('rating')?.text ?? '0') ?? 0;
    
    final nameText = xmlElement.getElement('name')?.text;
    final categoryText = xmlElement.getElement('category')?.text;
    final typeText = xmlElement.getElement('type')?.text;
    final sourceText = xmlElement.getElement('source')?.text;
    final pageText = xmlElement.getElement('page')?.text;
    final modeText = xmlElement.getElement('mode')?.text;
    final ammoText = xmlElement.getElement('ammo')?.text;
    final firingModeText = xmlElement.getElement('firingmode')?.text;
    final accuracyText = xmlElement.getElement('accuracy')?.text;
    

    final String rawLocationGuid = xmlElement.getElement('location')?.innerText ?? '';
    final String locationGuid = rawLocationGuid.isNotEmpty ? rawLocationGuid : defaultWeaponLocationGuid;

    return Weapon(
      sourceId: xmlElement.getElement('sourceid')?.text,
      locationGuid: locationGuid,
      name: nameText?.isNotEmpty == true ? nameText! : 'Unnamed Weapon',
      category: categoryText?.isNotEmpty == true ? categoryText! : 'Unknown',
      type: typeText?.isNotEmpty == true ? typeText! : 'Unknown',
      spec: xmlElement.getElement('spec')?.text,
      spec2: xmlElement.getElement('spec2')?.text,
      reach: int.tryParse(xmlElement.getElement('reach')?.text ?? '0') ?? 0,
      damage: xmlElement.getElement('damage')?.text ?? '0',
      ap: xmlElement.getElement('ap')?.text ?? '-',
      mode: modeText?.isNotEmpty == true ? modeText! : 'Unknown',
      rc: int.tryParse(xmlElement.getElement('rc')?.text ?? '0') ?? 0,
      ammo: ammoText?.isNotEmpty == true ? ammoText! : 'Unknown',
      cyberware: xmlElement.getElement('cyberware')?.text == 'True',
      ammoCategory: xmlElement.getElement('ammocategory')?.text,
      ammoSlots: int.tryParse(xmlElement.getElement('ammoslots')?.text ?? '1') ?? 1,
      sizeCategory: xmlElement.getElement('sizecategory')?.text,
      firingMode: firingModeText?.isNotEmpty == true ? firingModeText! : 'Unknown',
      minRating: xmlElement.getElement('minrating')?.text,
      maxRating: xmlElement.getElement('maxrating')?.text,
      rating: weaponRating,
      accuracy: accuracyText?.isNotEmpty == true ? accuracyText! : '0',
      activeAmmoSlot: int.tryParse(xmlElement.getElement('activeammoslot')?.text ?? '1') ?? 1,
      conceal: xmlElement.getElement('conceal')?.text ?? '0',
      avail: parseAvail(xmlElement.getElement('avail'), weaponRating),
      cost: int.tryParse(xmlElement.getElement('cost')?.text ?? '0') ?? 0,
      weight: xmlElement.getElement('weight')?.text,
      useSkill: xmlElement.getElement('useskill')?.text,
      useSkillSpec: xmlElement.getElement('useskillspec')?.text,
      range: xmlElement.getElement('range')?.text,
      alternateRange: xmlElement.getElement('alternaterange')?.text,
      rangeMultiply: int.tryParse(xmlElement.getElement('rangemultiply')?.text ?? '1') ?? 1,
      singleShot: int.tryParse(xmlElement.getElement('singleshot')?.text ?? '1') ?? 1,
      shortBurst: int.tryParse(xmlElement.getElement('shortburst')?.text ?? '3') ?? 3,
      longBurst: int.tryParse(xmlElement.getElement('longburst')?.text ?? '6') ?? 6,
      fullBurst: int.tryParse(xmlElement.getElement('fullburst')?.text ?? '10') ?? 10,
      suppressive: int.tryParse(xmlElement.getElement('suppressive')?.text ?? '20') ?? 20,
      allowSingleShot: xmlElement.getElement('allowsingleshot')?.text == 'True' || xmlElement.getElement('allowsingleshot') == null,
      allowShortBurst: xmlElement.getElement('allowshortburst')?.text == 'True' || xmlElement.getElement('allowshortburst') == null,
      allowLongBurst: xmlElement.getElement('allowlongburst')?.text == 'True' || xmlElement.getElement('allowlongburst') == null,
      allowFullBurst: xmlElement.getElement('allowfullburst')?.text == 'True' || xmlElement.getElement('allowfullburst') == null,
      allowSuppressive: xmlElement.getElement('allowsuppressive')?.text == 'True' || xmlElement.getElement('allowsuppressive') == null,
      source: sourceText?.isNotEmpty == true ? sourceText! : 'Unknown',
      page: pageText?.isNotEmpty == true ? pageText! : '0',
      parentId: xmlElement.getElement('parentid')?.text,
      allowAccessory: xmlElement.getElement('allowaccessory')?.text == 'True',
      weaponName: xmlElement.getElement('weaponname')?.text,
      included: xmlElement.getElement('included')?.text == 'True',
      equipped: xmlElement.getElement('equipped')?.text == 'True',
      active: xmlElement.getElement('active')?.text == 'True',
      homeNode: xmlElement.getElement('homenode')?.text == 'True',
      deviceRating: xmlElement.getElement('devicerating')?.text,
      requireAmmo: xmlElement.getElement('requireammo')?.text == 'True' || xmlElement.getElement('requireammo') == null,
      mount: xmlElement.getElement('mount')?.text,
      stolen: xmlElement.getElement('stolen')?.text == 'True',
      extraMount: xmlElement.getElement('extramount')?.text,
      accessories: xmlElement.findElements('accessories').expand((e) => e.findElements('accessory')).map((accXml) => WeaponAccessory.fromXml(accXml)).toList(),
      location: xmlElement.getElement('location')?.text,
      notes: xmlElement.getElement('notes')?.text,
      notesColor: xmlElement.getElement('notesColor')?.text,
      discountedCost: xmlElement.getElement('discountedcost')?.text == 'True',
      wirelessOn: xmlElement.getElement('wirelesson')?.text == 'True',
      sortOrder: int.tryParse(xmlElement.getElement('sortorder')?.text ?? '0') ?? 0,
      weaponType: xmlElement.getElement('weapontype')?.text,
    );
  }
}