import 'package:flutter/material.dart';
import 'package:xml/xml.dart'; // Import the xml package


 // Abstract base class for all Shadowrun items
// This class defines the common properties and methods that all Shadowrun items should have
// It is not meant to be instantiated directly, but rather serves as a foundation for specific item
// types like Gear, Armor, Weapon, etc.
// Each subclass should implement the fromXml factory method to parse XML data into a specific item type
// The class also provides methods for filtering items based on search queries and displaying item details
// The getIcon method can be overridden in subclasses to provide specific icons for different item types
// The class also includes methods for evaluating rating and ability expressions, which are common in Shadowrun
// This allows for dynamic calculation of item properties based on character attributes or item ratings
// The class is designed to be flexible and extensible, allowing for easy addition of new item types
// and properties as needed in the Shadowrun universe.
abstract class ShadowrunItem {
  final String? sourceId;
  final String? locationGuid;
  final String name;
  final String category;
  final String avail;
  final String source;
  final String page;
  bool equipped;
  bool active;
  final bool homeNode;
  // TODO: This should be int? instead of String? - device rating is always an integer
  final String? deviceRating;
  final String? programLimit;
  final String? overclocked;
  final String? attack;
  final String? sleaze;
  final String? dataProcessing;
  final String? firewall;
  final List<String>? attributeArray; // Assuming this is a list of strings
  final String? modAttack;
  final String? modSleaze;
  final String? modDataProcessing;
  final String? modFirewall;
  final List<String>? modAttributeArray; // Assuming this is a list of strings
  final bool canSwapAttributes;
  final int matrixCmFilled;
  final int matrixCmBonus;
  bool wirelessOn;
  final bool? canFormPersona;
  final String? notes;
  final String? notesColor;
  final bool discountedCost;
  final int sortOrder;
  final bool stolen;
  final double cost;

  ShadowrunItem({
    this.sourceId,
    this.locationGuid,
    required this.name,
    required this.category,
    required this.source,
    required this.page,
    this.equipped = false,
    this.active = false,
    this.homeNode = false,
    this.deviceRating,
    this.programLimit,
    this.overclocked,
    this.attack,
    this.sleaze,
    this.dataProcessing,
    this.firewall,
    this.attributeArray,
    this.modAttack,
    this.modSleaze,
    this.modDataProcessing,
    this.modFirewall,
    this.modAttributeArray,
    this.canSwapAttributes = false,
    this.matrixCmFilled = 0,
    this.matrixCmBonus = 0,
    this.wirelessOn = false,
    this.canFormPersona,
    this.notes,
    this.notesColor,
    this.discountedCost = false,
    this.sortOrder = 0,
    this.stolen = false,
    required this.avail,
    required this.cost,
  });

  // Factory constructor to create an item from an XmlElement (to be implemented in subclasses)
  factory ShadowrunItem.fromXml(XmlElement xmlElement) {
    throw UnimplementedError('fromXml not implemented for ShadowrunItem');
  }

  Icon getIcon(Color? color) {
    // Default icon, can be overridden in subclasses
    return const Icon(Icons.inventory_2_outlined);
  }

  /// Virtual method that child classes can override for type-specific search logic
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    final String lowerQuery = query.toLowerCase();
    
    // Check basic fields that all items have
    return name.toLowerCase().contains(lowerQuery) ||
           category.toLowerCase().contains(lowerQuery);
  }

  /// Static helper for filtering lists of any ShadowrunItem type
  static List<T> filterItems<T extends ShadowrunItem>(List<T> items, String query) {
    if (query.isEmpty) return items;
    return items.where((item) => item.matchesSearch(query)).toList();
  }

  /// Virtual method for hierarchy-preserving filtering that child classes can override
  /// Returns null if this item and its children don't match the query
  ShadowrunItem? filterWithHierarchy(String query) {
    if (query.isEmpty) return this;
    
    // Base implementation: include this item if it matches, exclude if it doesn't
    return matchesSearch(query) ? this : null;
  }

  /// Getter for brief item details - overrideable by subclasses
  /// Returns a brief string with basic item information
  String get details {
    return 'Category: $category, Source: $source p. $page, Cost: $cost¥, Availability: $avail';
  }

  /// Returns a detailed Column widget for display - overrideable by subclasses
  /// This can include toggles, more verbose information, etc.
  Widget getDetailsContent(BuildContext context, {Function? onUpdate, Map<String, int>? characterAttributes}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDetailRow(context, 'Category', category),
        buildDetailRow(context, 'Source', '$source p. $page'),
        buildDetailRow(context, 'Availability', avail),
        buildDetailRow(context, 'Cost', '$cost¥'),
        const Divider(height: 24, thickness: 1),
        buildToggleRow(context, 'Equipped', equipped, (value) {
          if (onUpdate != null) {
            onUpdate(this, equipped: value);
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

  /// Helper method to build detail rows
  @protected
  Widget buildDetailRow(BuildContext context, String label, String value, {
    int? rating,
    Map<String, int>? attributes,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          buildEvaluatedText(
            context, 
            value, 
            rating: rating, 
            attributes: attributes,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  /// Helper method to build toggle rows
  @protected
  Widget buildToggleRow(BuildContext context, String label, bool value,
      ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  /// Evaluates rating expressions like "(Rating * 3)F" and returns both the calculated value
  /// and the original expression for tooltip display.
  /// Returns a Map with 'display' (calculated result) and 'tooltip' (original expression).
  static Map<String, String> evaluateRatingExpression(String input, int rating) {
    // Check if this matches a rating expression pattern: (Rating * number)[letter]?
    final ratingPattern = RegExp(r'^\(Rating\s*\*\s*(\d+)\)([A-Z]?)$', caseSensitive: false);
    final match = ratingPattern.firstMatch(input);
    
    if (match != null) {
      final multiplier = int.tryParse(match.group(1) ?? '1') ?? 1;
      final suffix = match.group(2) ?? '';
      final calculatedValue = rating * multiplier;
      
      return {
        'display': '$calculatedValue$suffix',
        'tooltip': input, // Original expression for tooltip
      };
    }
    
    // Return unchanged if not a rating expression
    return {
      'display': input,
      'tooltip': input,
    };
  }

  /// Evaluates ability score expressions like "({STR}+1)P" and returns both the calculated value
  /// and the original expression for tooltip display.
  /// Returns a Map with 'display' (calculated result) and 'tooltip' (original expression).
  /// 
  /// Note: This method currently uses default attribute values. To get actual character attributes,
  /// the character context needs to be passed down to the item display methods.
  static Map<String, String> evaluateAbilityExpression(String input, {Map<String, int>? attributes}) {
    // Default attribute values if no character context provided
    final defaultAttributes = {
      'STR': 1, 'BOD': 1, 'AGI': 1, 'REA': 1,
      'CHA': 1, 'INT': 1, 'LOG': 1, 'WIL': 1,
      'EDG': 1, 'MAG': 0, 'RES': 0,
    };
    
    final effectiveAttributes = attributes ?? defaultAttributes;
    
    // Pattern to match expressions like ({STR}+1)P, ({STR})S - suffix is required
    final abilityPattern = RegExp(r'^\(\{([A-Z]{3})\}([+-]\d+)?\)([A-Z]+)$', caseSensitive: false);
    final match = abilityPattern.firstMatch(input);
    
    if (match != null) {
      final attributeName = match.group(1)?.toUpperCase() ?? '';
      final modifier = match.group(2) ?? '';
      final suffix = match.group(3) ?? '';
      
      final baseValue = effectiveAttributes[attributeName] ?? 0;
      int calculatedValue = baseValue;
      
      // Apply modifier if present
      if (modifier.isNotEmpty) {
        final modifierValue = int.tryParse(modifier) ?? 0;
        calculatedValue = baseValue + modifierValue;
      }
      
      return {
        'display': '$calculatedValue$suffix',
        'tooltip': input, // Original expression for tooltip
      };
    }
    
    // Return unchanged if not an ability expression
    return {
      'display': input,
      'tooltip': input,
    };
  }

  /// Helper method to create a widget with tooltip support for expressions
  @protected
  Widget buildExpressionText(BuildContext context, String text, {TextStyle? style}) {
    return Tooltip(
      message: text,
      child: Text(text, style: style),
    );
  }

  /// Helper method to evaluate and display a string that might contain rating or ability expressions
  /// This method combines both rating and ability expression evaluation
  @protected
  Widget buildEvaluatedText(BuildContext context, String input, {
    int? rating,
    Map<String, int>? attributes,
    TextStyle? style,
  }) {
    String displayText = input;
    String tooltipText = input;
    
    // First try rating expression evaluation
    if (rating != null) {
      final ratingResult = evaluateRatingExpression(input, rating);
      if (ratingResult['display'] != input) {
        displayText = ratingResult['display']!;
        tooltipText = ratingResult['tooltip']!;
      }
    }
    
    // If not a rating expression, try ability expression evaluation
    if (displayText == input) {
      final abilityResult = evaluateAbilityExpression(input, attributes: attributes);
      if (abilityResult['display'] != input) {
        displayText = abilityResult['display']!;
        tooltipText = abilityResult['tooltip']!;
      }
    }
    
    // If we have an evaluated expression, show tooltip; otherwise just show text
    if (displayText != input) {
      return Tooltip(
        message: tooltipText,
        child: Text(displayText, style: style),
      );
    } else {
      return Text(displayText, style: style);
    }
  }
  
}