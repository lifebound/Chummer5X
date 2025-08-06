import 'package:xml/xml.dart';
import 'package:chummer5x/utils/xml_element_extensions.dart';

class LifestyleQuality {
  final String sourceId;
  final String guid;
  final String name;
  final String category;
  final String extra;
  final int cost;
  final int multiplier;
  final int baseMultiplier;
  final int lp;
  final int areaMaximum;
  final int comfortsMaximum;
  final int securityMaximum;
  final int area;
  final int comforts;
  final int security;
  final bool useLpCost;
  final bool print;
  final String lifestyleQualityType;
  final String lifestyleQualitySource;
  final bool free;
  final bool isFreeGrid;
  final String source;
  final String page;
  final String allowed;
  final String notes;
  final String notesColor;

  LifestyleQuality({
    required this.sourceId,
    required this.guid,
    required this.name,
    required this.category,
    required this.extra,
    required this.cost,
    required this.multiplier,
    required this.baseMultiplier,
    required this.lp,
    required this.areaMaximum,
    required this.comfortsMaximum,
    required this.securityMaximum,
    required this.area,
    required this.comforts,
    required this.security,
    required this.useLpCost,
    required this.print,
    required this.lifestyleQualityType,
    required this.lifestyleQualitySource,
    required this.free,
    required this.isFreeGrid,
    required this.source,
    required this.page,
    required this.allowed,
    required this.notes,
    required this.notesColor,
  });

  factory LifestyleQuality.fromXml(XmlElement xmlElement) {
    return LifestyleQuality(
      sourceId: xmlElement.getString('sourceid'),
      guid: xmlElement.getString('guid'),
      name: xmlElement.getString('name'),
      category: xmlElement.getString('category'),
      extra: xmlElement.getString('extra'),
      cost: xmlElement.getInt('cost'),
      multiplier: xmlElement.getInt('multiplier'),
      baseMultiplier: xmlElement.getInt('basemultiplier'),
      lp: xmlElement.getInt('lp'),
      areaMaximum: xmlElement.getInt('areamaximum'),
      comfortsMaximum: xmlElement.getInt('comfortsmaximum'),
      securityMaximum: xmlElement.getInt('securitymaximum'),
      area: xmlElement.getInt('area'),
      comforts: xmlElement.getInt('comforts'),
      security: xmlElement.getInt('security'),
      useLpCost: xmlElement.getBool('uselpcost'),
      print: xmlElement.getBool('print'),
      lifestyleQualityType: xmlElement.getString('lifestylequalitytype'),
      lifestyleQualitySource: xmlElement.getString('lifestylequalitysource'),
      free: xmlElement.getBool('free'),
      isFreeGrid: xmlElement.getBool('isfreegrid'),
      source: xmlElement.getString('source'),
      page: xmlElement.getString('page'),
      allowed: xmlElement.getString('allowed'),
      notes: xmlElement.getString('notes'),
      notesColor: xmlElement.getString('notesColor'),
    );
  }

  @override
  String toString() {
    return 'LifestyleQuality(name: $name, category: $category, cost: $cost, lp: $lp)';
  }
}
