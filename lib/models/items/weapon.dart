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
    int weaponRating = int.tryParse(xmlElement.getElement('rating')?.innerText ?? '0') ?? 0;
    
    final nameText = xmlElement.getElement('name')?.innerText;
    final categoryText = xmlElement.getElement('category')?.innerText;
    final typeText = xmlElement.getElement('type')?.innerText;
    final sourceText = xmlElement.getElement('source')?.innerText;
    final pageText = xmlElement.getElement('page')?.innerText;
    final modeText = xmlElement.getElement('mode')?.innerText;
    final ammoText = xmlElement.getElement('ammo')?.innerText;
    final firingModeText = xmlElement.getElement('firingmode')?.innerText;
    final accuracyText = xmlElement.getElement('accuracy')?.innerText;
    

    final String rawLocationGuid = xmlElement.getElement('location')?.innerText ?? '';
    final String locationGuid = rawLocationGuid.isNotEmpty ? rawLocationGuid : defaultWeaponLocationGuid;

    return Weapon(
      sourceId: xmlElement.getElement('sourceid')?.innerText,
      locationGuid: locationGuid,
      name: nameText?.isNotEmpty == true ? nameText! : 'Unnamed Weapon',
      category: categoryText?.isNotEmpty == true ? categoryText! : 'Unknown',
      type: typeText?.isNotEmpty == true ? typeText! : 'Unknown',
      spec: xmlElement.getElement('spec')?.innerText,
      spec2: xmlElement.getElement('spec2')?.innerText,
      reach: int.tryParse(xmlElement.getElement('reach')?.innerText ?? '0') ?? 0,
      damage: xmlElement.getElement('damage')?.innerText ?? '0',
      ap: xmlElement.getElement('ap')?.innerText ?? '-',
      mode: modeText?.isNotEmpty == true ? modeText! : 'Unknown',
      rc: int.tryParse(xmlElement.getElement('rc')?.innerText ?? '0') ?? 0,
      ammo: ammoText?.isNotEmpty == true ? ammoText! : 'Unknown',
      cyberware: xmlElement.getElement('cyberware')?.innerText == 'True',
      ammoCategory: xmlElement.getElement('ammocategory')?.innerText,
      ammoSlots: int.tryParse(xmlElement.getElement('ammoslots')?.innerText ?? '1') ?? 1,
      sizeCategory: xmlElement.getElement('sizecategory')?.innerText,
      firingMode: firingModeText?.isNotEmpty == true ? firingModeText! : 'Unknown',
      minRating: xmlElement.getElement('minrating')?.innerText,
      maxRating: xmlElement.getElement('maxrating')?.innerText,
      rating: weaponRating,
      accuracy: accuracyText?.isNotEmpty == true ? accuracyText! : '0',
      activeAmmoSlot: int.tryParse(xmlElement.getElement('activeammoslot')?.innerText ?? '1') ?? 1,
      conceal: xmlElement.getElement('conceal')?.innerText ?? '0',
      avail: parseAvail(xmlElement.getElement('avail'), weaponRating),
      cost: int.tryParse(xmlElement.getElement('cost')?.innerText ?? '0') ?? 0,
      weight: xmlElement.getElement('weight')?.innerText,
      useSkill: xmlElement.getElement('useskill')?.innerText,
      useSkillSpec: xmlElement.getElement('useskillspec')?.innerText,
      range: xmlElement.getElement('range')?.innerText,
      alternateRange: xmlElement.getElement('alternaterange')?.innerText,
      rangeMultiply: int.tryParse(xmlElement.getElement('rangemultiply')?.innerText ?? '1') ?? 1,
      singleShot: int.tryParse(xmlElement.getElement('singleshot')?.innerText ?? '1') ?? 1,
      shortBurst: int.tryParse(xmlElement.getElement('shortburst')?.innerText ?? '3') ?? 3,
      longBurst: int.tryParse(xmlElement.getElement('longburst')?.innerText ?? '6') ?? 6,
      fullBurst: int.tryParse(xmlElement.getElement('fullburst')?.innerText ?? '10') ?? 10,
      suppressive: int.tryParse(xmlElement.getElement('suppressive')?.innerText ?? '20') ?? 20,
      allowSingleShot: xmlElement.getElement('allowsingleshot')?.innerText == 'True' || xmlElement.getElement('allowsingleshot') == null,
      allowShortBurst: xmlElement.getElement('allowshortburst')?.innerText == 'True' || xmlElement.getElement('allowshortburst') == null,
      allowLongBurst: xmlElement.getElement('allowlongburst')?.innerText == 'True' || xmlElement.getElement('allowlongburst') == null,
      allowFullBurst: xmlElement.getElement('allowfullburst')?.innerText == 'True' || xmlElement.getElement('allowfullburst') == null,
      allowSuppressive: xmlElement.getElement('allowsuppressive')?.innerText == 'True' || xmlElement.getElement('allowsuppressive') == null,
      source: sourceText?.isNotEmpty == true ? sourceText! : 'Unknown',
      page: pageText?.isNotEmpty == true ? pageText! : '0',
      parentId: xmlElement.getElement('parentid')?.innerText,
      allowAccessory: xmlElement.getElement('allowaccessory')?.innerText == 'True',
      weaponName: xmlElement.getElement('weaponname')?.innerText,
      included: xmlElement.getElement('included')?.innerText == 'True',
      equipped: xmlElement.getElement('equipped')?.innerText == 'True',
      active: xmlElement.getElement('active')?.innerText == 'True',
      homeNode: xmlElement.getElement('homenode')?.innerText == 'True',
      deviceRating: xmlElement.getElement('devicerating')?.innerText,
      requireAmmo: xmlElement.getElement('requireammo')?.innerText == 'True' || xmlElement.getElement('requireammo') == null,
      mount: xmlElement.getElement('mount')?.innerText,
      stolen: xmlElement.getElement('stolen')?.innerText == 'True',
      extraMount: xmlElement.getElement('extramount')?.innerText,
      accessories: xmlElement.findElements('accessories').expand((e) => e.findElements('accessory')).map((accXml) => WeaponAccessory.fromXml(accXml)).toList(),
      location: xmlElement.getElement('location')?.innerText,
      notes: xmlElement.getElement('notes')?.innerText,
      notesColor: xmlElement.getElement('notesColor')?.innerText,
      discountedCost: xmlElement.getElement('discountedcost')?.innerText == 'True',
      wirelessOn: xmlElement.getElement('wirelesson')?.innerText == 'True',
      sortOrder: int.tryParse(xmlElement.getElement('sortorder')?.innerText ?? '0') ?? 0,
      weaponType: xmlElement.getElement('weapontype')?.innerText,
    );
  }
}