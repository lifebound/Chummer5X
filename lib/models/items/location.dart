// File: models/location.dart

import 'package:xml/xml.dart';


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

  factory Location.fromXmlElement(XmlElement element) {
    return Location(
      guid: element.getElement('guid')?.innerText ?? '',
      name: element.getElement('name')?.innerText ?? '',
      notes: element.getElement('notes')?.innerText ?? '',
      notesColor: element.getElement('notesColor')?.innerText ?? '',
      sortOrder: int.tryParse(element.getElement('sortorder')?.innerText ?? '') ?? 0,
    );
  }
}
class GearLocations {
  final List<Location> locations;

  GearLocations({required this.locations});

  factory GearLocations.fromXmlElement(XmlElement element) {
    final List<Location> loadedLocations = element.findAllElements('location')
        .map((e) => Location.fromXmlElement(e))
        .toList();
    return GearLocations(locations: loadedLocations);
  }
}
class ArmorLocations {
  final List<Location> locations;

  ArmorLocations({required this.locations});

  factory ArmorLocations.fromXmlElement(XmlElement element) {
    final List<Location> loadedLocations = element.findAllElements('location')
        .map((e) => Location.fromXmlElement(e))
        .toList();
    return ArmorLocations(locations: loadedLocations);
  }
}
class WeaponLocations {
  final List<Location> locations;

  WeaponLocations({required this.locations});

  factory WeaponLocations.fromXmlElement(XmlElement element) {
    final List<Location> loadedLocations = element.findAllElements('location')
        .map((e) => Location.fromXmlElement(e))
        .toList();
    return WeaponLocations(locations: loadedLocations);
  }
}
class VehicleLocations {
  final List<Location> locations;

  VehicleLocations({required this.locations});

  factory VehicleLocations.fromXmlElement(XmlElement element) {
    final List<Location> loadedLocations = element.findAllElements('location')
        .map((e) => Location.fromXmlElement(e))
        .toList();
    return VehicleLocations(locations: loadedLocations);
  }
}