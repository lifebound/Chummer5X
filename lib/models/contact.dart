import 'package:xml/xml.dart';

class Contact {
  final String name;
  final String role;
  final String location;
  final int connection;
  final int loyalty;
  final String metatype;
  final String gender;
  final String age;
  final String contacttype;
  final String preferredpayment;
  final String hobbiesvice;
  final String personallife;
  final String type;
  final String file;
  final String relative;
  final String notes;
  final String notesColor;
  final String groupname;
  final int colour;
  final bool group;
  final bool family;
  final bool blackmail;
  final bool free;
  final bool groupenabled;
  final String guid;
  final int mainmugshotindex;
  final List<String> mugshots;

  Contact({
    required this.name,
    required this.role,
    required this.location,
    required this.connection,
    required this.loyalty,
    required this.metatype,
    required this.gender,
    required this.age,
    required this.contacttype,
    required this.preferredpayment,
    required this.hobbiesvice,
    required this.personallife,
    required this.type,
    required this.file,
    required this.relative,
    required this.notes,
    required this.notesColor,
    required this.groupname,
    required this.colour,
    required this.group,
    required this.family,
    required this.blackmail,
    required this.free,
    required this.groupenabled,
    required this.guid,
    required this.mainmugshotindex,
    required this.mugshots,
  });

  factory Contact.fromXml(XmlElement xmlElement) {
    // Helper to safely get string value from an element
    String getText(String tagName) {
      return xmlElement.findElements(tagName).firstOrNull?.innerText ?? '';
    }

    // Helper to safely get boolean value from an element
    bool getBool(String tagName) {
      return getText(tagName).toLowerCase() == 'true';
    }

    // Helper to safely get int value from an element
    int getInt(String tagName, {int defaultValue = 0}) {
      return int.tryParse(getText(tagName)) ?? defaultValue;
    }

    // Helper to get mugshots list
    List<String> getMugshots() {
      final mugshotsElement = xmlElement.findElements('mugshots').firstOrNull;
      if (mugshotsElement == null) return [];
      
      return mugshotsElement.findElements('mugshot')
          .map((e) => e.innerText)
          .where((text) => text.isNotEmpty)
          .toList();
    }

    return Contact(
      name: getText('name'),
      role: getText('role').isNotEmpty ? getText('role') : getText('archetype'),
      location: getText('location'),
      connection: getInt('connection', defaultValue: 1),
      loyalty: getInt('loyalty', defaultValue: 1),
      metatype: getText('metatype'),
      gender: getText('gender').isNotEmpty ? getText('gender') : getText('sex'),
      age: getText('age'),
      contacttype: getText('contacttype'),
      preferredpayment: getText('preferredpayment'),
      hobbiesvice: getText('hobbiesvice'),
      personallife: getText('personallife'),
      type: getText('type'),
      file: getText('file'),
      relative: getText('relative'),
      notes: getText('notes'),
      notesColor: getText('notesColor'),
      groupname: getText('groupname'),
      colour: getInt('colour'),
      group: getBool('group'),
      family: getBool('family'),
      blackmail: getBool('blackmail'),
      free: getBool('free'),
      groupenabled: getBool('groupenabled'),
      guid: getText('guid'),
      mainmugshotindex: getInt('mainmugshotindex', defaultValue: -1),
      mugshots: getMugshots(),
    );
  }

  /// Returns a display name for the contact
  String get displayName {
    if (name.isNotEmpty) {
      return name;
    } else if (role.isNotEmpty) {
      return role;
    } else if (contacttype.isNotEmpty) {
      return contacttype;
    } else {
      return 'Unnamed Contact';
    }
  }

  /// Returns a brief description combining role and location
  String get description {
    final List<String> parts = [];
    if (role.isNotEmpty) parts.add(role);
    if (location.isNotEmpty) parts.add(location);
    return parts.join(' - ');
  }

  /// Returns the total contact rating (connection + loyalty)
  int get totalRating => connection + loyalty;

  /// Returns whether this contact has meaningful data
  bool get hasData {
    return name.isNotEmpty || 
           role.isNotEmpty || 
           location.isNotEmpty ||
           connection > 1 || 
           loyalty > 1;
  }

  @override
  String toString() {
    return 'Contact(name: $name, role: $role, connection: $connection, loyalty: $loyalty)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Contact && other.guid == guid;
  }

  @override
  int get hashCode => guid.hashCode;
}
