import 'package:xml/xml.dart';
import 'package:chummer5x/utils/xml_element_extensions.dart';
import 'package:chummer5x/models/lifestyle_quality.dart';

class Lifestyle {
  final String sourceId;
  final String guid;
  final String name;
  final int cost;
  final int dice;
  final int lp;
  final String baseLifestyle;
  final int multiplier;
  final int months;
  final int roommates;
  final double percentage;
  final int area;
  final int comforts;
  final int security;
  final int baseArea;
  final int baseComforts;
  final int baseSecurity;
  final int maxArea;
  final int maxComforts;
  final int maxSecurity;
  final int costForArea;
  final int costForComforts;
  final int costForSecurity;
  final bool allowBonusLp;
  final int bonusLp;
  final String source;
  final String page;
  final bool trustFund;
  final bool splitCostWithRoommates;
  final String type;
  final String increment;
  final String city;
  final String district;
  final String borough;
  final List<LifestyleQuality> lifestyleQualities;
  final String notes;
  final String notesColor;
  final int sortOrder;

  Lifestyle({
    required this.sourceId,
    required this.guid,
    required this.name,
    required this.cost,
    required this.dice,
    required this.lp,
    required this.baseLifestyle,
    required this.multiplier,
    required this.months,
    required this.roommates,
    required this.percentage,
    required this.area,
    required this.comforts,
    required this.security,
    required this.baseArea,
    required this.baseComforts,
    required this.baseSecurity,
    required this.maxArea,
    required this.maxComforts,
    required this.maxSecurity,
    required this.costForArea,
    required this.costForComforts,
    required this.costForSecurity,
    required this.allowBonusLp,
    required this.bonusLp,
    required this.source,
    required this.page,
    required this.trustFund,
    required this.splitCostWithRoommates,
    required this.type,
    required this.increment,
    required this.city,
    required this.district,
    required this.borough,
    required this.lifestyleQualities,
    required this.notes,
    required this.notesColor,
    required this.sortOrder,
  });

  factory Lifestyle.fromXml(XmlElement xmlElement) {
    // Parse lifestyle qualities
    final lifestyleQualities = xmlElement.parseList<LifestyleQuality>(
      collectionTagName: 'lifestylequalities',
      itemTagName: 'lifestylequality',
      fromXml: LifestyleQuality.fromXml,
    );

    return Lifestyle(
      sourceId: xmlElement.getString('sourceid'),
      guid: xmlElement.getString('guid'),
      name: xmlElement.getString('name'),
      cost: xmlElement.getInt('cost'),
      dice: xmlElement.getInt('dice'),
      lp: xmlElement.getInt('lp'),
      baseLifestyle: xmlElement.getString('baselifestyle'),
      multiplier: xmlElement.getInt('multiplier'),
      months: xmlElement.getInt('months'),
      roommates: xmlElement.getInt('roommates'),
      percentage: xmlElement.getDouble('percentage'),
      area: xmlElement.getInt('area'),
      comforts: xmlElement.getInt('comforts'),
      security: xmlElement.getInt('security'),
      baseArea: xmlElement.getInt('basearea'),
      baseComforts: xmlElement.getInt('basecomforts'),
      baseSecurity: xmlElement.getInt('basesecurity'),
      maxArea: xmlElement.getInt('maxarea'),
      maxComforts: xmlElement.getInt('maxcomforts'),
      maxSecurity: xmlElement.getInt('maxsecurity'),
      costForArea: xmlElement.getInt('costforearea'),
      costForComforts: xmlElement.getInt('costforcomforts'),
      costForSecurity: xmlElement.getInt('costforsecurity'),
      allowBonusLp: xmlElement.getBool('allowbonuslp'),
      bonusLp: xmlElement.getInt('bonuslp'),
      source: xmlElement.getString('source'),
      page: xmlElement.getString('page'),
      trustFund: xmlElement.getBool('trustfund'),
      splitCostWithRoommates: xmlElement.getBool('splitcostwithroommates'),
      type: xmlElement.getString('type'),
      increment: xmlElement.getString('increment'),
      city: xmlElement.getString('city'),
      district: xmlElement.getString('district'),
      borough: xmlElement.getString('borough'),
      lifestyleQualities: lifestyleQualities,
      notes: xmlElement.getString('notes'),
      notesColor: xmlElement.getString('notesColor'),
      sortOrder: xmlElement.getInt('sortorder'),
    );
  }

  @override
  String toString() {
    return 'Lifestyle(name: $name, baseLifestyle: $baseLifestyle, cost: $cost, months: $months)';
  }

  /// Calculate the total monthly cost including all modifiers
  int get totalMonthlyCost {
    int baseCost = cost;
    
    // Add costs for area, comforts, and security improvements
    baseCost += (area * costForArea);
    baseCost += (comforts * costForComforts);
    baseCost += (security * costForSecurity);
    
    // Add lifestyle quality costs
    for (final quality in lifestyleQualities) {
      if (!quality.free) {
        baseCost += quality.cost;
      }
    }
    
    // Apply multiplier
    baseCost = (baseCost * multiplier ~/ 100);
    
    // Split with roommates if applicable
    if (splitCostWithRoommates && roommates > 0) {
      baseCost = baseCost ~/ (roommates + 1);
    }
    
    // Apply percentage modifier
    baseCost = (baseCost * percentage / 100).round();
    
    return baseCost;
  }

  /// Calculate the total lifestyle points
  int get totalLifestylePoints {
    int totalLp = lp + bonusLp;
    
    // Add lifestyle quality LP
    for (final quality in lifestyleQualities) {
      totalLp += quality.lp;
    }
    
    return totalLp;
  }

  /// Get the effective area rating (base + improvements)
  int get effectiveArea => baseArea + area;
  
  /// Get the effective comforts rating (base + improvements)
  int get effectiveComforts => baseComforts + comforts;
  
  /// Get the effective security rating (base + improvements)
  int get effectiveSecurity => baseSecurity + security;
}
