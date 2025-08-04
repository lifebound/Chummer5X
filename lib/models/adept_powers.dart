import 'package:chummer5x/utils/xml_element_extensions.dart';
import 'package:xml/xml.dart';

class AdeptPower {
  final String name;
  // TODO: This should be int? instead of String? - rating is always an integer
  final String? rating;
  final String? extra;
  final double? pointsPerLevel; // Optional field for points per level
  final double? extraPointCost; // Optional field for extra point cost
  final bool? hasLevels; // Indicates if the power has levels
  final int? maxLevels; // Maximum levels for the power, if applicable
  final String? action; // Optional action type for the power
  final bool? discounted; // Indicates if the power is discounted
  final String source; // source for the power
  final String page; // page for the power
  final String? description; // Optional description for the power
  final Map<String, String>? bonus;


  const AdeptPower({
    required this.name,
    this.rating,
    this.extra,
    this.pointsPerLevel,
    this.extraPointCost,
    this.hasLevels,
    this.maxLevels,
    this.action,
    this.discounted,
    required this.source,
    required this.page,
    this.description,
    this.bonus,
    
  });

  factory AdeptPower.fromJson(Map<String, dynamic> json) {
    //debugPrint('Parsing AdeptPower from JSON: $json');
    return AdeptPower(
      name: json['name'] ?? '',
      rating: json['rating']?.toString(),
      extra: json['extra'],
      source: json['source'] ?? '',
      page: json['page'] ?? '',
      bonus: (json['bonus'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      pointsPerLevel: json['pointsperlevel'] != null
          ? double.tryParse(json['pointsperlevel'].toString())
          : null,
      extraPointCost: json['extrapointcost'] != null
          ? double.tryParse(json['extrapointcost'].toString())
          : null,
      hasLevels: json['haslevels'] == true,
      maxLevels: json['maxlevels'] != null
          ? int.tryParse(json['maxlevels'].toString())
          : null,
      action: json['action'],
      discounted: json['discounted'] == true,
      description: json['description'],
    );
  }
  factory AdeptPower.fromXml(XmlElement xml) {
    //debugPrint('Parsing AdeptPower from XML: ${xml.toString()}');
    return AdeptPower(
      name: xml.getElementText('name') ?? '',
      rating: xml.getElementText('rating'),
      extra: xml.getElementText('extra'),
      source: xml.getElementText('source') ?? '',
      page: xml.getElementText('page') ?? '',
      bonus: _parseBonus(xml),
      pointsPerLevel: xml.getDouble('pointsperlevel'),
      extraPointCost: xml.getDouble('extrapointcost'),
      hasLevels: xml.getBool('haslevels'),
      maxLevels: xml.getInt('maxlevels'),
      action: xml.getElementText('action'),
      discounted: xml.getBool('discounted'),
      description: xml.getElementText('description'),
    );
  }
  static Map<String, String>? _parseBonus(XmlElement powerElement) {
    final bonusElement = powerElement.getElement('bonus');
    if (bonusElement == null) return null;

    final Map<String, String> bonusMap = {};

    for (final child in bonusElement.children.whereType<XmlElement>()) {
      final key = child.name.local.trim();
      final value = child.innerText.trim();
      if (key.isNotEmpty && value.isNotEmpty) {
        bonusMap[key] = value;
      }
    }

    return bonusMap.isEmpty ? null : bonusMap;
  }

  String get displayName => name;
  bool get hasCompleteInfo => 
    name.isNotEmpty && 
    rating != null &&
    source.isNotEmpty&&
    page.isNotEmpty;
}
