import 'package:xml/xml.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:chummer5x/models/items/gear.dart';
import 'package:chummer5x/models/items/vehicle_mod.dart';
import 'package:chummer5x/models/items/weapon_mount.dart';
import 'package:chummer5x/utils/availability_parser.dart';
import 'package:chummer5x/models/items/weapon.dart';
class Vehicle extends ShadowrunItem {
  final String handling;
  final String offRoadHandling;
  final String accel;
  final String offRoadAccel;
  final String speed;
  final String offRoadSpeed;
  final String pilot;
  final String body;
  final String seats;
  final String armor;
  final String sensor;
  final String addSlots;
  final String modSlots;
  final String powertrainModSlots;
  final String protectionModSlots;
  final String weaponModSlots;
  final String bodyModSlots;
  final String electromagneticModSlots;
  final String cosmeticModSlots;
  final String physicalCmFilled;
  final String vehicleName;
  final bool dealerConnection;
  final List<VehicleMod> mods;
  final List<WeaponMount> weaponMounts;
  final List<Gear> gears;
  final List<Weapon>? weapons; // Assuming this is a list of Weapon objects

  Vehicle({
    required String super.sourceId,
    required String super.guid,
    required super.name,
    required super.category,
    required super.avail,
    required String cost,
    required super.source,
    required super.page,
    String? parentId,
    required super.sortOrder,
    required super.stolen,
    String? location,
    super.notes,
    super.notesColor,
    required super.discountedCost,
    required super.active,
    required super.homeNode,
    super.deviceRating,
    required this.handling,
    required this.offRoadHandling,
    required this.accel,
    required this.offRoadAccel,
    required this.speed,
    required this.offRoadSpeed,
    required this.pilot,
    required this.body,
    required this.seats,
    required this.armor,
    required this.sensor,
    required this.addSlots,
    required this.modSlots,
    required this.powertrainModSlots,
    required this.protectionModSlots,
    required this.weaponModSlots,
    required this.bodyModSlots,
    required this.electromagneticModSlots,
    required this.cosmeticModSlots,
    required this.physicalCmFilled,
    super.matrixCmFilled,
    required this.vehicleName,
    required this.dealerConnection,
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
    required this.mods,
    required this.weaponMounts,
    required this.gears,
    this.weapons,
  }) : super(
          equipped: true,
          wirelessOn: false, // Default or parse from XML if present
          canFormPersona: false,
          matrixCmBonus: 0, // Not present in XML for Vehicle directly
        );

  factory Vehicle.fromXmlElement(XmlElement element) {
    int vehicleRating = int.tryParse(element.getElement('devicerating')?.innerText ?? '0') ?? 0;
    return Vehicle(
      sourceId: element.getElement('sourceid')?.innerText ?? '',
      guid: element.getElement('guid')?.innerText ?? '',
      name: element.getElement('name')?.innerText ?? '',
      category: element.getElement('category')?.innerText ?? '',
      handling: element.getElement('handling')?.innerText ?? '',
      offRoadHandling: element.getElement('offroadhandling')?.innerText ?? '',
      accel: element.getElement('accel')?.innerText ?? '',
      offRoadAccel: element.getElement('offroadaccel')?.innerText ?? '',
      speed: element.getElement('speed')?.innerText ?? '',
      offRoadSpeed: element.getElement('offroadspeed')?.innerText ?? '',
      pilot: element.getElement('pilot')?.innerText ?? '',
      body: element.getElement('body')?.innerText ?? '',
      seats: element.getElement('seats')?.innerText ?? '',
      armor: element.getElement('armor')?.innerText ?? '',
      sensor: element.getElement('sensor')?.innerText ?? '',
      avail: parseAvail(element.getElement('avail'), vehicleRating),
      cost: element.getElement('cost')?.innerText ?? '',
      addSlots: element.getElement('addslots')?.innerText ?? '',
      modSlots: element.getElement('modslots')?.innerText ?? '',
      powertrainModSlots: element.getElement('powertrainmodslots')?.innerText ?? '',
      protectionModSlots: element.getElement('protectionmodslots')?.innerText ?? '',
      weaponModSlots: element.getElement('weaponmodslots')?.innerText ?? '',
      bodyModSlots: element.getElement('bodymodslots')?.innerText ?? '',
      electromagneticModSlots: element.getElement('electromagneticmodslots')?.innerText ?? '',
      cosmeticModSlots: element.getElement('cosmeticmodslots')?.innerText ?? '',
      source: element.getElement('source')?.innerText ?? '',
      page: element.getElement('page')?.innerText ?? '',
      parentId: element.getElement('parentid')?.innerText,
      sortOrder: int.tryParse(element.getElement('sortorder')?.innerText ?? '0') ?? 0,
      stolen: element.getElement('stolen')?.innerText == 'True',
      physicalCmFilled: element.getElement('physicalcmfilled')?.innerText ?? '0',
      matrixCmFilled: int.tryParse(element.getElement('matrixcmfilled')?.innerText ?? '0') ?? 0,
      vehicleName: element.getElement('vehiclename')?.innerText ?? '',
      location: element.getElement('location')?.innerText,
      notes: element.getElement('notes')?.innerText,
      notesColor: element.getElement('notesColor')?.innerText,
      discountedCost: element.getElement('discountedcost')?.innerText == 'True',
      dealerConnection: element.getElement('dealerconnection')?.innerText == 'True',
      active: element.getElement('active')?.innerText == 'True',
      homeNode: element.getElement('homenode')?.innerText == 'True',
      deviceRating: element.getElement('devicerating')?.innerText,
      programLimit: element.getElement('programlimit')?.innerText,
      overclocked: element.getElement('overclocked')?.innerText,
      attack: element.getElement('attack')?.innerText,
      sleaze: element.getElement('sleaze')?.innerText,
      dataProcessing: element.getElement('dataprocessing')?.innerText,
      firewall: element.getElement('firewall')?.innerText,
      attributeArray: element.getElement('attributearray')?.innerText.split(',').map((s) => s.trim()).toList(),
      modAttack: element.getElement('modattack')?.innerText,
      modSleaze: element.getElement('modsleaze')?.innerText,
      modDataProcessing: element.getElement('moddataprocessing')?.innerText,
      modFirewall: element.getElement('modfirewall')?.innerText,
      modAttributeArray: element.getElement('modattributearray')?.innerText.split(',').map((s) => s.trim()).toList(),
      canSwapAttributes: element.getElement('canswapattributes')?.innerText == 'True',
      mods: element.getElement('mods')?.findAllElements('mod').map((e) => VehicleMod.fromXmlElement(e)).toList() ?? [],
      weaponMounts: element.getElement('weaponmounts')?.findAllElements('weaponmount').map((e) => WeaponMount.fromXmlElement(e)).toList() ?? [],
      gears: element.getElement('gears')?.findAllElements('gear').map((e) => Gear.fromXml(e)).toList() ?? [],
    );
  }
}
