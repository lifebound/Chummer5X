import 'package:chummer5x/models/items/location.dart';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
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
    required String super.locationGuid,
    required super.name,
    required super.category,
    required super.avail,
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
    super.cost = 0, // Default cost to 0 if not provided
  }) : super(
          equipped: true,
          wirelessOn: false, // Default or parse from XML if present
          canFormPersona: false,
          matrixCmBonus: 0, // Not present in XML for Vehicle directly
        );

  factory Vehicle.fromXml(XmlElement element) {
    int vehicleRating = int.tryParse(element.getElement('devicerating')?.innerText ?? '0') ?? 0;

    final String rawLocationGuid = element.getElement('location')?.innerText ?? '';
    final String locationGuid = rawLocationGuid.isNotEmpty ? rawLocationGuid : defaultVehicleLocationGuid;

    
    return Vehicle(
      sourceId: element.getElement('sourceid')?.innerText ?? '',
      locationGuid: locationGuid,
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
      cost: int.tryParse(element.getElement('cost')?.innerText ?? '0') ?? 0,
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

  Vehicle copyWith({
    String? sourceId,
    String? locationGuid,
    String? name,
    String? category,
    String? avail,
    String? source,
    String? page,
    int? sortOrder,
    bool? stolen,
    String? notes,
    String? notesColor,
    bool? discountedCost,
    bool? active,
    bool? homeNode,
    int? cost,
    String? handling,
    String? offRoadHandling,
    String? accel,
    String? offRoadAccel,
    String? speed,
    String? offRoadSpeed,
    String? pilot,
    String? body,
    String? seats,
    String? armor,
    String? sensor,
    String? addSlots,
    String? modSlots,
    String? powertrainModSlots,
    String? protectionModSlots,
    String? weaponModSlots,
    String? bodyModSlots,
    String? electromagneticModSlots,
    String? cosmeticModSlots,
    String? physicalCmFilled,
    String? vehicleName,
    bool? dealerConnection,
    List<VehicleMod>? mods,
    List<WeaponMount>? weaponMounts,
    List<Gear>? gears,
    List<Weapon>? weapons,
  }) {
    return Vehicle(
      sourceId: sourceId ?? this.sourceId!,
      locationGuid: locationGuid ?? this.locationGuid!,
      name: name ?? this.name,
      category: category ?? this.category,
      avail: avail ?? this.avail,
      source: source ?? this.source,
      page: page ?? this.page,
      sortOrder: sortOrder ?? this.sortOrder,
      stolen: stolen ?? this.stolen,
      notes: notes ?? this.notes,
      notesColor: notesColor ?? this.notesColor,
      discountedCost: discountedCost ?? this.discountedCost,
      active: active ?? this.active,
      homeNode: homeNode ?? this.homeNode,
      cost: cost ?? this.cost,
      handling: handling ?? this.handling,
      offRoadHandling: offRoadHandling ?? this.offRoadHandling,
      accel: accel ?? this.accel,
      offRoadAccel: offRoadAccel ?? this.offRoadAccel,
      speed: speed ?? this.speed,
      offRoadSpeed: offRoadSpeed ?? this.offRoadSpeed,
      pilot: pilot ?? this.pilot,
      body: body ?? this.body,
      seats: seats ?? this.seats,
      armor: armor ?? this.armor,
      sensor: sensor ?? this.sensor,
      addSlots: addSlots ?? this.addSlots,
      modSlots: modSlots ?? this.modSlots,
      powertrainModSlots: powertrainModSlots ?? this.powertrainModSlots,
      protectionModSlots: protectionModSlots ?? this.protectionModSlots,
      weaponModSlots: weaponModSlots ?? this.weaponModSlots,
      bodyModSlots: bodyModSlots ?? this.bodyModSlots,
      electromagneticModSlots: electromagneticModSlots ?? this.electromagneticModSlots,
      cosmeticModSlots: cosmeticModSlots ?? this.cosmeticModSlots,
      physicalCmFilled: physicalCmFilled ?? this.physicalCmFilled,
      vehicleName: vehicleName ?? this.vehicleName,
      dealerConnection: dealerConnection ?? this.dealerConnection,
      mods: mods ?? this.mods,
      weaponMounts: weaponMounts ?? this.weaponMounts,
      gears: gears ?? this.gears,
      weapons: weapons ?? this.weapons,
    );
  }

  @override
  Vehicle? filterWithHierarchy(String query) {
    if (query.isEmpty) return this;
    
    // Filter nested collections
    final filteredMods = mods
        .map((mod) => mod.filterWithHierarchy(query))
        .where((mod) => mod != null)
        .cast<VehicleMod>()
        .toList();
    
    final filteredWeaponMounts = weaponMounts
        .map((mount) => mount.filterWithHierarchy(query))
        .where((mount) => mount != null)
        .cast<WeaponMount>()
        .toList();
    
    final filteredGears = gears
        .map((gear) => gear.filterWithHierarchy(query))
        .where((gear) => gear != null)
        .cast<Gear>()
        .toList();
    
    final filteredWeapons = weapons
        ?.map((weapon) => weapon.filterWithHierarchy(query))
        .where((weapon) => weapon != null)
        .cast<Weapon>()
        .toList();
    
    // Include this vehicle if it matches OR if it has any matching nested items
    if (matchesSearch(query) || 
        filteredMods.isNotEmpty || 
        filteredWeaponMounts.isNotEmpty || 
        filteredGears.isNotEmpty || 
        (filteredWeapons?.isNotEmpty ?? false)) {
      return copyWith(
        mods: filteredMods,
        weaponMounts: filteredWeaponMounts,
        gears: filteredGears,
        weapons: filteredWeapons,
      );
    }
    
    return null;
  }

  @override
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    // Check base fields first (name, category)
    if (super.matchesSearch(query)) return true;
    
    final String lowerQuery = query.toLowerCase();
    
    // Check Vehicle's mods
    if (mods.any((mod) => mod.name.toLowerCase().contains(lowerQuery))) {
      return true;
    }
    
    // Check Vehicle's weapon mounts
    if (weaponMounts.any((mount) => mount.name.toLowerCase().contains(lowerQuery))) {
      return true;
    }
    
    // Check Vehicle's gears recursively
    if (gears.any((gear) => gear.matchesSearch(query))) {
      return true;
    }
    
    // Check Vehicle's weapons recursively
    if (weapons?.any((weapon) => weapon.matchesSearch(query)) ?? false) {
      return true;
    }
    
    return false;
  }

  @override
  String get details {
    return 'Category: $category, Pilot: $pilot, Body: $body, Armor: $armor, Source: $source p. $page, Cost: $cost¥, Availability: $avail';
  }

  @override
  Widget getDetailsContent(BuildContext context, {Function? onUpdate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDetailRow(context, 'Category', category),
        buildDetailRow(context, 'Handling', handling),
        buildDetailRow(context, 'Speed', speed),
        buildDetailRow(context, 'Acceleration', accel),
        buildDetailRow(context, 'Body', body),
        buildDetailRow(context, 'Armor', armor),
        buildDetailRow(context, 'Pilot', pilot),
        buildDetailRow(context, 'Sensor', sensor),
        buildDetailRow(context, 'Source', '$source p. $page'),
        buildDetailRow(context, 'Availability', avail),
        buildDetailRow(context, 'Cost', '$cost¥'),
        const Divider(height: 24, thickness: 1),
        buildToggleRow(context, 'Active', active, (value) {
          if (onUpdate != null) {
            onUpdate(this, active: value);
          }
        }),
      ],
    );
  }
}
