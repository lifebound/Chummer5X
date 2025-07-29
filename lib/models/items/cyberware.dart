import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'shadowrun_item.dart'; // Import the base class
import 'location.dart'; // Import for default location GUIDs
import 'package:chummer5x/models/items/cyberware_grades.dart';
import 'package:math_expressions/math_expressions.dart';


class Cyberware extends ShadowrunItem {
  final String? guid;
  final String? limbslot;
  final int? limbslotcount;
  final bool inheritattributes;
  final double ess; // Can be a fixed value or an expression like "Rating * 0.2"
  final String capacity; // Can be a fixed value or an expression like "[2]"
  final String? weight;
  final String? parentid;
  final bool hasmodularmount;
  final bool plugsintomodularmount;
  final String? blocksmounts;
  final bool forced;
  final int rating;
  final int minagility;
  final int minstrength;
  // TODO: These should be int? instead of String? - ratings are always integers
  final String? minrating;
  final String? maxrating;
  final String ratinglabel;
  final String? subsystems;
  final String grade;
  final String? location;
  final String? extra;
  final bool suite;
  final String essdiscount;
  final String extraessadditivemultiplier;
  final String extraessmultiplicativemultiplier;
  final String? forcegrade;
  final bool prototypetranshuman;
  // Bonus, PairBonus, WirelessBonus, WirelessPairBonus can be complex,
  // represented as raw XmlElement for now or more specific classes if needed.
  final XmlElement? bonus;
  final XmlElement? pairbonus;
  final XmlElement? wirelessbonus;
  final XmlElement? wirelesspairbonus;
  final String improvementSource;
  final List<String> pairinclude;
  final List<String> wirelesspairinclude;

  Cyberware({
    this.guid,
    this.limbslot,
    this.limbslotcount,
    this.inheritattributes = false,
    required this.ess,
    required this.capacity,
    this.weight,
    this.parentid,
    this.hasmodularmount = false,
    this.plugsintomodularmount = false,
    this.blocksmounts,
    this.forced = false,
    this.rating = 0,
    this.minagility = 0,
    this.minstrength = 0,
    this.minrating,
    this.maxrating,
    this.ratinglabel = 'String_Rating',
    this.subsystems,
    required this.grade,
    this.location,
    this.extra,
    this.suite = false,
    this.essdiscount = '0',
    this.extraessadditivemultiplier = '0',
    this.extraessmultiplicativemultiplier = '1',
    this.forcegrade,
    this.prototypetranshuman = false,
    this.bonus,
    this.pairbonus,
    this.wirelessbonus,
    this.wirelesspairbonus,
    required this.improvementSource,
    required this.pairinclude,
    required this.wirelesspairinclude,
    // ShadowrunItem fields
    required super.name,
    required super.category,
    required super.avail,
    required super.cost,
    required super.source,
    required super.page,
    super.sourceId,
    super.locationGuid,
    super.equipped,
    super.active,
    super.homeNode,
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
    super.matrixCmFilled,
    super.matrixCmBonus,
    super.wirelessOn,
    super.canFormPersona,
    super.notes,
    super.notesColor,
    super.discountedCost,
    super.sortOrder,
    super.stolen, 
    bool isgeneware = false, required bool addtoparentess, required bool addtoparentcapacity,
  });

  factory Cyberware.fromXml(XmlElement xmlElement) {
    // Helper to safely get string value from an element
    String? getText(XmlElement element, String tagName) {
      return element.findElements(tagName).firstOrNull?.innerText;
    }

    // Helper to safely get boolean value from an element
    bool getBool(XmlElement element, String tagName) {
      return getText(element, tagName)?.toLowerCase() == 'true';
    }

    // Helper to safely get int value from an element
    int getInt(XmlElement element, String tagName, {int defaultValue = 0}) {
      return int.tryParse(getText(element, tagName) ?? '') ?? defaultValue;
    }
    double getDouble(XmlElement element, String tagName, {double defaultValue = 0.0}) {
      return double.tryParse(getText(element, tagName) ?? '') ?? defaultValue;
    }

    // Helper to get list of names from a parent element like <pairinclude>
    List<String> getIncludedNames(XmlElement parentElement, String tagName) {
      final List<String> names = [];
      for (final element in parentElement.findElements(tagName)) {
        final name = element.findElements('name').firstOrNull?.innerText;
        if (name != null) {
          names.add(name);
        }
      }
      return names;
    }

    final improvementSource = getText(xmlElement, 'improvementsource') ?? 'Cyberware'; // Default to Cyberware

    
    //get the value of improvementSource. if its 'cyberware', set locationGuid to defaultCyberwareLocationGuid. if its 'bioware', set locationGuid to defaultBiowareLocationGuid.
    String locationGuid;
    Grade cyberwareGrade;
    final name = getText(xmlElement, 'name')!;
    if (improvementSource == 'Cyberware' && name != 'Essence Hole') {
      locationGuid = defaultCyberwareLocationGuid; // Switch to Cyberware location
      cyberwareGrade = GradeTypeDetails.fromName(getText(xmlElement, 'grade') ?? 'Standard',isCyberware: true).details;
    }
    else{
      locationGuid = defaultBiowareLocationGuid; // Switch to Bioware location
      cyberwareGrade = GradeTypeDetails.fromName(getText(xmlElement, 'grade') ?? 'Standard',isCyberware: false).details;
    }
    
    int rating = _calculateTrueRating(cyberwareGrade, getInt(xmlElement, 'rating', defaultValue: 1));
    String availString = getText(xmlElement, 'avail') ?? '0';
    String essString = getText(xmlElement, 'ess') ?? '0';
    String costString = getText(xmlElement, 'cost') ?? '0';


    String avail = _calculateAvailability(cyberwareGrade, rating, availString);
    double essenceValue = _calculateEssence(cyberwareGrade, rating, essString);
    double costValue = _calculateCost(cyberwareGrade, rating, costString);

    return Cyberware(
      guid: getText(xmlElement, 'guid'),
      sourceId: getText(xmlElement, 'sourceid'),
      name: name,
      category: getText(xmlElement, 'category')!,
      limbslot: getText(xmlElement, 'limbslot'),
      limbslotcount: getInt(xmlElement, 'limbslotcount', defaultValue: 1),
      inheritattributes: getBool(xmlElement, 'inheritattributes'),
      ess: essenceValue,
      capacity: getText(xmlElement, 'capacity')!,
      avail: avail,
      cost: costValue,
      weight: getText(xmlElement, 'weight'),
      source: getText(xmlElement, 'source')!,
      page: getText(xmlElement, 'page')!,
      parentid: getText(xmlElement, 'parentid'),
      hasmodularmount: getBool(xmlElement, 'hasmodularmount'),
      plugsintomodularmount: getBool(xmlElement, 'plugsintomodularmount'),
      blocksmounts: getText(xmlElement, 'blocksmounts'),
      forced: getBool(xmlElement, 'forced'),
      rating: getInt(xmlElement, 'rating'),
      minagility: getInt(xmlElement, 'minagility', defaultValue: 3),
      minstrength: getInt(xmlElement, 'minstrength', defaultValue: 3),
      minrating: getText(xmlElement, 'minrating'),
      maxrating: getText(xmlElement, 'maxrating'),
      ratinglabel: getText(xmlElement, 'ratinglabel') ?? 'String_Rating',
      subsystems: getText(xmlElement, 'subsystems'),
      wirelessOn: getBool(xmlElement, 'wirelesson'),
      grade: getText(xmlElement, 'grade') ?? 'Standard',
      location: getText(xmlElement, 'location'),
      extra: getText(xmlElement, 'extra'),
      suite: getBool(xmlElement, 'suite'),
      stolen: getBool(xmlElement, 'stolen'),
      essdiscount: getText(xmlElement, 'essdiscount') ?? '0',
      extraessadditivemultiplier: getText(xmlElement, 'extraessadditivemultiplier') ?? '0',
      extraessmultiplicativemultiplier: getText(xmlElement, 'extraessmultiplicativemultiplier') ?? '1',
      forcegrade: getText(xmlElement, 'forcegrade'),
      matrixCmFilled: getInt(xmlElement, 'matrixcmfilled'),
      matrixCmBonus: getInt(xmlElement, 'matrixcmbonus'),
      prototypetranshuman: getBool(xmlElement, 'prototypetranshuman'),
      bonus: xmlElement.findElements('bonus').firstOrNull,
      pairbonus: xmlElement.findElements('pairbonus').firstOrNull,
      wirelessbonus: xmlElement.findElements('wirelessbonus').firstOrNull,
      wirelesspairbonus: xmlElement.findElements('wirelesspairbonus').firstOrNull,
      improvementSource: getText(xmlElement, 'improvementsource') ?? 'Cyberware', // Default to Cyberware
      pairinclude: getIncludedNames(xmlElement, 'pairinclude'),
      wirelesspairinclude: getIncludedNames(xmlElement, 'wirelesspairinclude'),
      notes: getText(xmlElement, 'notes'),
      notesColor: getText(xmlElement, 'notesColor'),
      discountedCost: getBool(xmlElement, 'discountedcost'),
      addtoparentess: getBool(xmlElement, 'addtoparentess'),
      addtoparentcapacity: getBool(xmlElement, 'addtoparentcapacity'),
      isgeneware: getBool(xmlElement, 'isgeneware'),
      active: getBool(xmlElement, 'active'),
      homeNode: getBool(xmlElement, 'homenode'),
      deviceRating: cyberwareGrade.deviceRating.toString(),
      programLimit: getText(xmlElement, 'programlimit'),
      overclocked: getText(xmlElement, 'overclocked'),
      canFormPersona: getText(xmlElement, 'canformpersona')?.toLowerCase() == 'true' ? true : (getText(xmlElement, 'canformpersona')?.toLowerCase() == 'false' ? false : null),
      attack: getText(xmlElement, 'attack'),
      sleaze: getText(xmlElement, 'sleaze'),
      dataProcessing: getText(xmlElement, 'dataprocessing'),
      firewall: getText(xmlElement, 'firewall'),
      attributeArray: getText(xmlElement, 'attributearray')?.split(','), // Assuming comma separated
      modAttack: getText(xmlElement, 'modattack'),
      modSleaze: getText(xmlElement, 'modsleaze'),
      modDataProcessing: getText(xmlElement, 'moddataprocessing'),
      modFirewall: getText(xmlElement, 'modfirewall'),
      modAttributeArray: getText(xmlElement, 'modattributearray')?.split(','), // Assuming comma separated
      canSwapAttributes: getBool(xmlElement, 'canswapattributes'),
      sortOrder: getInt(xmlElement, 'sortorder'),
      locationGuid: locationGuid,
    );
  }

  @override
  Icon getIcon(Color? color) {
    // You can customize icons based on category or improvementSource here
    if (improvementSource == "Bioware") {
      return Icon(Icons.medical_services_outlined, color: color);
    } else if (category == "Cyberlimb Enhancement") {
      return Icon(Icons.hardware_outlined, color: color);
    }
    return Icon(Icons.medical_information_outlined, color: color);
  }

  @override
  String get details {
    return 'Category: $category, Essence: $ess, Grade: $grade, Source: $source p. $page, Cost: $cost¥, Availability: $avail';
  }

  @override
  Widget getDetailsContent(BuildContext context, {Map<String, int>? characterAttributes, Function? onUpdate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDetailRow(context, 'Category', category),
        buildDetailRow(context, 'Improvement Source', improvementSource),
        buildDetailRow(context, 'Essence Cost', ess.toString()),
        buildDetailRow(context, 'Capacity', capacity),
        buildDetailRow(context, 'Grade', grade),
        if (rating > 0) buildDetailRow(context, 'Rating', rating.toString()),
        if (ratinglabel != 'String_Rating') buildDetailRow(context, 'Rating Label', ratinglabel),
        buildDetailRow(context, 'Source', '$source p. $page'),
        buildDetailRow(context, 'Availability', avail),
        buildDetailRow(context, 'Cost', '$cost¥'),
        if (weight != null) buildDetailRow(context, 'Weight', weight!),
        if (location != null) buildDetailRow(context, 'Location', location!),
        const Divider(height: 24, thickness: 1),
        buildToggleRow(context, 'Equipped', equipped, (value) {
          if (onUpdate != null) {
            onUpdate(this, equipped: value);
          }
        }),
        buildToggleRow(context, 'Wireless', wirelessOn, (value) {
          if (onUpdate != null) {
            onUpdate(this, wireless: value);
          }
        }),
        buildToggleRow(context, 'Active', active, (value) {
          if (onUpdate != null) {
            onUpdate(this, active: value);
          }
        }),
      ],
    );
  }

  static String _calculateAvailability(Grade gradeType, int rating, String availText) {
    // availability has a few options on how it can be formatted, so we need to handle that.
    //it can be a simple number (eg: "10"), it can a number and a restriction indicator (eg: "10R"),
    // or it can be a formulaa like "Rating + 2" or "Rating - 1".
    // if its a formlua, we need to parse it, and use math_expressions to evaluate it.
    
    //first check if we're using FixedValues, which is a special case.
    //we need that value to continue parsing the availability.
    if(availText.contains(RegExp(r'FixedValues\('))) {
      // Parse the fixed values and return the value corresponding to the rating
      availText = _parseFixedValue(availText, rating).toString();
    }

    String avail;

      var context = ContextModel()
        ..bindVariableName('Rating', Number(rating)); // Bind the variable name "Rating" to the rating value
    if (availText.contains(RegExp(r'[+-/*\\/]'))) {
      // Parse the formula, e.g., "Rating + 2"
      final expression = GrammarParser().parse(availText.replaceAll(' ', '')); // Remove spaces for parsing

      
      final evaluator = RealEvaluator(context);
      avail = evaluator.evaluate(expression).toString(); // Evaluate the expression
    } else {
      avail = availText; // Directly use the text if no formula
    }
    // now we need to split the availability into a number and a restriction indicator if it has one.
    final availParts = avail.split(RegExp(r'(?<=[0-9])(?=[a-zA-Z])'));
    final availNumber = availParts[0];
    final availRestriction = availParts.length > 1 ? availParts[1] : '';

    // the cyberware grade availability is a string, so we need to use that with math_expressions to modify the availNumber
    final gradeAvail = gradeType.avail;
    String finalAvail;
    final availExpression = GrammarParser().parse('$availNumber + $gradeAvail');
    final availEvaluator = RealEvaluator(context);
    final availResult = availEvaluator.evaluate(availExpression);
    finalAvail = availResult.toInt().toString();

    return finalAvail + availRestriction;
  }
  static double _calculateEssence(Grade gradeType, int rating, String essenceText) {

    // essence can be a fixed value, or it can be a formula like "Rating * 0.2" or "Rating - 1".
    // if its a formula, we need to parse it, and use math_expressions to evaluate it.
    
    //first check if we're using FixedValues, which is a special case.
    //we need that value to continue parsing the essence.
    if(essenceText.contains(RegExp(r'FixedValues\('))) {
      // Parse the fixed values and return the value corresponding to the rating
      essenceText = _parseFixedValue(essenceText, rating).toString();
    }

   //use math_expressions to evaluate the essenceText
    double essenceValue;
    if (essenceText.contains(RegExp(r'[+-/*\\/]'))) {
     //parse the formulae to use in math_expressions
      final context = ContextModel()
        ..bindVariableName('Rating', Number(rating)); // Bind the variable name "Rating" to the rating value
      final expression = GrammarParser().parse(essenceText.replaceAll(' ', '')); // Remove spaces for parsing
      
      final evaluator = RealEvaluator(context);
      essenceValue = evaluator.evaluate(expression).toDouble(); // Evaluate the expression
    } else {
      essenceValue = double.tryParse(essenceText) ?? 0.0; // Fallback to direct parsing
    }
    double finalEssenceValue = essenceValue * gradeType.ess;

    //we need to restrict the final value to a maximum of 2 decimal places.
    finalEssenceValue = double.parse(finalEssenceValue.toStringAsFixed(2));
    return finalEssenceValue;

  }
  static double _calculateCost(Grade gradeType, int rating, String costText) {

    // first check if we're using FixedValues, which is a special case.
    // we need that value to continue parsing the cost.
    if(costText.contains(RegExp(r'FixedValues\('))) {
      // Parse the fixed values and return the value corresponding to the rating
      costText = _parseFixedValue(costText, rating).toString();
    }

    // Use math_expressions to evaluate the costText
    int costValue;
    if (costText.contains(RegExp(r'[+-/*\\/]'))) {
      final context = ContextModel()
        ..bindVariableName('Rating', Number(rating)); // Bind the variable name "Rating" to the rating value
      final expression = GrammarParser().parse(costText.replaceAll(' ', '')); // Remove spaces for parsing
      
      final evaluator = RealEvaluator(context);
      costValue = evaluator.evaluate(expression).toInt(); // Evaluate the expression
    } else {
      costValue = int.tryParse(costText) ?? 0; // Fallback to direct parsing
    }
    return costValue * gradeType.cost;
  }
  static int _calculateTrueRating(Grade gradeType, int rating) {
    return (rating + gradeType.deviceRating).toInt();
  }
  static num _parseFixedValue(String value, int rating) {
   //sometimes a String comes ascross as "FixedValues(1,2,3,4)" or similar.
   // we should treat what's inside the parentheses as a list of fixed values,
   //and return the value that corresponds to the current rating.
   final match = RegExp(r'FixedValues\(([^)]+)\)').firstMatch(value);
   if (match != null) {
     final fixedValues = match.group(1)?.split(',').map((v) => int.tryParse(v.trim()) ?? 0).toList() ?? [];
     if (rating > 0 && rating <= fixedValues.length) {
       return fixedValues[rating - 1];
     }
   }
   return 0;
  }
}