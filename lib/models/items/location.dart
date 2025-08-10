// File: models/location.dart

import 'package:chummer5x/utils/xml_element_extensions.dart';
import 'package:xml/xml.dart';

const String defaultGearLocationGuid = '00000000-0000-0000-0000-000000000001';
const String defaultArmorLocationGuid = '00000000-0000-0000-0000-000000000002';
const String defaultWeaponLocationGuid = '00000000-0000-0000-0000-000000000003';
const String defaultVehicleLocationGuid = '00000000-0000-0000-0000-000000000004';
const String defaultCyberwareLocationGuid = '00000000-0000-0000-0000-000000000005';
const String defaultBiowareLocationGuid = '00000000-0000-0000-0000-000000000006';

final Location defaultGearLocation = Location(
  guid: defaultGearLocationGuid,
  name: 'Selected Gear',
  notes: 'Default location for unassigned gear.',
  notesColor: 'LightGray',
  sortOrder: 0,
);

final Location defaultArmorLocation = Location(
  guid: defaultArmorLocationGuid,
  name: 'Selected Armor',
  notes: 'Default location for unassigned armor.',
  notesColor: 'LightGray',
  sortOrder: 0,
);

final Location defaultWeaponLocation = Location(
  guid: defaultWeaponLocationGuid,
  name: 'Selected Weapon',
  notes: 'Default location for unassigned weapons.',
  notesColor: 'LightGray',
  sortOrder: 0,
);

final Location defaultVehicleLocation = Location(
  guid: defaultVehicleLocationGuid,
  name: 'Selected Vehicle',
  notes: 'Default location for unassigned vehicles.',
  notesColor: 'LightGray',
  sortOrder: 0,
);

final Location defaultCyberwareLocation = Location(
  guid: defaultCyberwareLocationGuid,
  name: 'Cyberware',
  notes: 'Cybernetic enhancements',
  notesColor: 'Blue',
  sortOrder: 0,
);

final Location defaultBiowareLocation = Location(
  guid: defaultBiowareLocationGuid,
  name: 'Bioware',
  notes: 'Biological enhancements',
  notesColor: 'Green',
  sortOrder: 1,
);


class Location {
  final String guid;
  final String name;
  final String notes;
  final String notesColor;
  final int sortOrder;

  Location({
    required this.guid,
    required this.name,
    required this.notes,
    required this.notesColor,
    required this.sortOrder,
  });

  factory Location.fromXml(XmlElement element) {
    return Location(
      guid: element.getElementText('guid') ?? "<unknown>",
      name: element.getElementText('name') ?? "",
      notes: element.getElementText('notes') ?? "",
      notesColor: element.getElementText('notesColor') ?? "",
      sortOrder: element.getInt('sortorder', defaultValue: 0),
    );
  }
}

class GearLocations {
  final List<Location> locations;

  GearLocations({required this.locations});

  factory GearLocations.fromXml(XmlElement element) {
    final List<Location> loadedLocations = element.findAllElements('location')
        .map((e) => Location.fromXml(e))
        .toList();
      loadedLocations.add(defaultGearLocation); // Ensure default location is included
    return GearLocations(locations: loadedLocations);
  }
}
class ArmorLocations {
  final List<Location> locations;

  ArmorLocations({required this.locations});

  factory ArmorLocations.fromXml(XmlElement element) {
    final List<Location> loadedLocations = element.findAllElements('location')
        .map((e) => Location.fromXml(e))
        .toList();
    loadedLocations.add(defaultArmorLocation); // Ensure default location is included
    return ArmorLocations(locations: loadedLocations);
  }
}
class WeaponLocations {
  final List<Location> locations;

  WeaponLocations({required this.locations});

  factory WeaponLocations.fromXml(XmlElement element) {
    final List<Location> loadedLocations = element.findAllElements('location')
        .map((e) => Location.fromXml(e))
        .toList();
    loadedLocations.add(defaultWeaponLocation); // Ensure default location is included
    return WeaponLocations(locations: loadedLocations);
  }
}
class VehicleLocations {
  final List<Location> locations;

  VehicleLocations({required this.locations});

  factory VehicleLocations.fromXml(XmlElement element) {
    final List<Location> loadedLocations = element.findAllElements('location')
        .map((e) => Location.fromXml(e))
        .toList();
    loadedLocations.add(defaultVehicleLocation); // Ensure default location is included
    return VehicleLocations(locations: loadedLocations);
  }
}