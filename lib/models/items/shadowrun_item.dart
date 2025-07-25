import 'package:flutter/material.dart';
import 'package:xml/xml.dart'; // Import the xml package

// Abstract base class for all items
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
  final int cost;

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
}