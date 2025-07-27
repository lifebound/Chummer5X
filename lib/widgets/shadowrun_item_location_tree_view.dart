// shadowrun_item_location_tree_view.dart (New file or renamed)
import 'package:chummer5x/models/items/weapon_accessory.dart';
import 'package:flutter/material.dart';
import 'package:chummer5x/models/items/location.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:chummer5x/models/items/gear.dart'; // Still needed for type checking/casting if children exist
import 'package:chummer5x/models/items/armor.dart';
import 'package:chummer5x/models/items/weapon.dart';
import 'package:chummer5x/models/items/vehicle.dart';
import 'package:chummer5x/models/shadowrun_character.dart';

class ShadowrunItemLocationTreeView<T extends ShadowrunItem>
    extends StatefulWidget {
  final Map<String, Location> allLocations;
  final List<T> allItems; // Generic list of ShadowrunItem
  final ShadowrunCharacter? character; // Add character for attribute access

  const ShadowrunItemLocationTreeView({
    super.key,
    required this.allLocations,
    required this.allItems,
    this.character, // Optional character parameter
  });

  @override
  State<ShadowrunItemLocationTreeView<T>> createState() =>
      _ShadowrunItemLocationTreeViewState<T>();
}

class _ShadowrunItemLocationTreeViewState<T extends ShadowrunItem>
    extends State<ShadowrunItemLocationTreeView<T>> {
  String _searchQuery = '';
  ShadowrunItem? _selectedItemForDetails;
  late List<T> _items;
  static const breakpoint =
      600.0; // Define your breakpoint for "large" vs "small" screen

  @override
  void initState() {
    super.initState();
    _items = List<T>.from(widget.allItems);
    debugPrint(
        'ShadowrunItemLocationTreeView constructor called with ${widget.allLocations.length} locations and ${widget.allItems.length} items');
  }

  // Helper to group items by their location GUID
  Map<String, List<T>> _groupItemsByLocation() {
    debugPrint(
        '_groupItemsByLocation: Starting to group ${_items.length} items');
    final Map<String, List<T>> groupedItems = {};

    for (var item in _items) {
      // Determine the default GUID based on the item type if locationGuid is null
      String locationGuid = item.locationGuid ?? _getDefaultLocationGuid(item);
      debugPrint(
          '_groupItemsByLocation: Item "${item.name}" (Type: ${item.runtimeType}) has locationGuid: $locationGuid');

      if (!groupedItems.containsKey(locationGuid)) {
        groupedItems[locationGuid] = [];
        debugPrint(
            '_groupItemsByLocation: Created new group for locationGuid: $locationGuid');
      }
      groupedItems[locationGuid]!.add(item);
    }
    debugPrint(
        '_groupItemsByLocation: Grouped items into ${groupedItems.length} locations:');
    groupedItems.forEach((locationGuid, items) {
      debugPrint(
          '  Location $locationGuid: ${items.length} items - ${items.map((g) => g.name).join(', ')}');
    });
    return groupedItems;
  }

  String _getDefaultLocationGuid(ShadowrunItem item) {
    if (item is Gear) {
      return defaultGearLocationGuid;
    } else if (item is Armor) {
      return defaultArmorLocationGuid;
    } else if (item is Weapon) {
      return defaultWeaponLocationGuid;
    } else if (item is Vehicle) {
      return defaultVehicleLocationGuid;
    }
    return defaultGearLocationGuid; // Fallback, though ideally all types are covered
  }

  // Helper method to filter items using the polymorphic approach
  List<ShadowrunItem> _filterItemsByType(List<ShadowrunItem> items, String query) {
    if (query.isEmpty) return items;

    List<ShadowrunItem> filteredItems = [];
    
    // Use hierarchy filtering for all items
    for (final item in items) {
      final filteredItem = item.filterWithHierarchy(query);
      if (filteredItem != null) {
        filteredItems.add(filteredItem);
      }
    }
    
    return filteredItems;
  }

  // Helper method to check if an individual item matches the search (for highlighting)
  bool _itemMatchesForHighlighting(ShadowrunItem item, String query) {
    // Only highlight if there's actually a search query
    if (query.isEmpty) return false;
    
    return item.matchesSearch(query);
  }

  // Helper method to recursively build item tiles with nested children
  List<Widget> _buildItemTilesRecursively(
      BuildContext context, List<ShadowrunItem> items,
      {int indentLevel = 0}) {
    final List<Widget> widgets = [];

    for (var item in items) {
      debugPrint(
          'ShadowrunItemLocationTreeView._buildItemTilesRecursively: Building item tile for "${item.name}" (indent: $indentLevel, type: ${item.runtimeType})');

      // Determine if the item has children that can be expanded
      bool hasExpandableChildren = false;
      List<ShadowrunItem> childrenToDisplay = [];

      if (item is Gear && item.children != null && item.children!.isNotEmpty) {
        hasExpandableChildren = true;
        childrenToDisplay = item.children!;
      }
      else if (item is WeaponAccessory &&
          item.gears != null &&
          item.gears!.isNotEmpty) {
        hasExpandableChildren = true;
        childrenToDisplay = item.gears!;
      }
      // else if (item is Vehicle &&
      //     (item.mods.isNotEmpty ||
      //         item.weaponMounts.isNotEmpty ||
      //         item.gears.isNotEmpty ||
      //         (item.weapons != null && item.weapons!.isNotEmpty))) {
      //   hasExpandableChildren = true;
      //   // Combine all nested lists for display under the ExpansionTile
      //   childrenToDisplay = [
      //     ...item.mods,
      //     ...item.weaponMounts,
      //     ...item.gears,
      //     ...(item.weapons ?? []),
      //   ];
      // } 
      else if (item is Armor &&
          item.armorMods != null &&
          item.armorMods!.isNotEmpty) {
        hasExpandableChildren = true;
        childrenToDisplay = item.armorMods!;
      } 
      else if (item is Weapon &&
          item.accessories != null &&
          item.accessories!.isNotEmpty) {
        hasExpandableChildren = true;
        childrenToDisplay = item.accessories!;
      }

      final EdgeInsets padding = EdgeInsets.only(left: indentLevel * 16.0);

      // Check if this specific item matches the search (for highlighting)
      final bool itemMatches = _itemMatchesForHighlighting(item, _searchQuery);

      // Dynamic subtitle based on item type
      String subtitleText = 'Category: ${item.category}';
      if (item is Gear) {
        subtitleText += ', Cost: ${item.cost}¥';
        if (hasExpandableChildren) {
          subtitleText += ' (${item.children!.length} items)';
        }
      } else if (item is Armor) {
        subtitleText += ', Armor: ${item.armorValue}, Cost: ${item.cost}¥';
        if (hasExpandableChildren) {
          subtitleText += ' (${item.armorMods!.length} mods)';
        }
      } else if (item is Weapon) {
        subtitleText +=
            ', Damage: ${item.damage}, AP: ${item.ap}, Cost: ${item.cost}¥';
        if (hasExpandableChildren) {
          subtitleText += ' (${item.accessories!.length} accessories)';
        }
      } else if (item is Vehicle) {
        subtitleText +=
            ', Pilot: ${item.pilot}, Body: ${item.body}, Armor: ${item.armor}, Cost: ${item.cost}¥';
        if (hasExpandableChildren) {
          final int totalNested = item.mods.length +
              item.weaponMounts.length +
              item.gears.length +
              (item.weapons?.length ?? 0);
          subtitleText += ' ($totalNested nested items)';
        }
      }

      if (hasExpandableChildren) {
        widgets.add(
          Padding(
            padding: padding,
            child: ExpansionTile(
              key: PageStorageKey<String>(
                  'item_${item.sourceId ?? item.name}_$indentLevel'), // Unique key
              initiallyExpanded: _searchQuery
                  .isNotEmpty, // Auto-expand when searching or at root level
              leading: _getLeadingIcon(item, itemMatches),
              
              title: Row(
                // Use a Row to place title text and the info icon
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontWeight:
                            itemMatches ? FontWeight.bold : FontWeight.normal,
                        color: itemMatches
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                  ),
                  // The info icon for details
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant, // Or a more neutral color
                    onPressed: () {
                      debugPrint(
                          'Tapped info icon on expandable item "${item.name}"');
                      _showItemDetails(
                          item, breakpoint); // Call the detail display method
                    },
                    tooltip: 'Show details', // Add a tooltip for desktop users
                  ),
                ],
              ),
              subtitle: Text(
                subtitleText,
                style: TextStyle(
                  color: itemMatches
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
              onExpansionChanged: (expanded) {
                debugPrint(
                    'ShadowrunItemLocationTreeView: Item "${item.name}" ${expanded ? 'expanded' : 'collapsed'}');
              },

              children: _buildItemTilesRecursively(context, childrenToDisplay,
                  indentLevel: indentLevel + 1),
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: padding,
            child: ListTile(
              leading: _getLeadingIcon(item, itemMatches),
              title: Text(
                item.name,
                style: TextStyle(
                  fontWeight: itemMatches ? FontWeight.bold : FontWeight.normal,
                  color: itemMatches
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
              subtitle: Text(
                subtitleText,
                style: TextStyle(
                  color: itemMatches
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
              onTap: () {
                debugPrint(
                    'ShadowrunItemLocationTreeView: User tapped on item "${item.name}" (Type: ${item.runtimeType})');
              },
              onLongPress: () {
                _showItemDetails(item, breakpoint);
                debugPrint(
                    'ShadowrunItemLocationTreeView: User long-pressed on item "${item.name}" (Type: ${item.runtimeType})');
              },
              trailing: IconButton(
                icon: const Icon(Icons.info_outline), // Or Icons.more_vert
                onPressed: () {
                  debugPrint('Tapped info icon for ${item.name}');
                  _showItemDetails(item, breakpoint);
                },
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  // Helper to determine the appropriate icon based on item type
  Icon _getLeadingIcon(ShadowrunItem item, bool isMatch) {
    Color? color = isMatch ? Theme.of(context).colorScheme.primary : null;
    if (item is Gear) {
      return item.getIcon(color);
    } else if (item is Armor) {
      return item.getIcon(color);
    } else if (item is Weapon) {
      return item.getIcon(color);
    } else if (item is Vehicle) {
      return Icon(Icons.directions_car_outlined, color: color);
    }
    // For nested mods/mounts which are not ShadowrunItem directly, or other unknown types
    return Icon(Icons.circle_outlined, color: color);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final Map<String, List<ShadowrunItem>> groupedItems =
        _groupItemsByLocation();
    final List<Location> sortedLocations = widget.allLocations.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name)); // Sort locations

    if (screenWidth > breakpoint) {
      // Large screen layout (two-pane)
      return Row(
        children: [
          // Left pane: Your existing SliverList for locations and items
          Expanded(
            flex: 2, // Adjust flex as needed
            child: CustomScrollView(
              slivers: [
                _buildSearchBar(),
                if (_searchQuery.isNotEmpty) _buildSearchResultsSummary(),
                _buildLocationSliverList(sortedLocations, groupedItems),
              ],
            ),
          ),
          // Right pane: Detail view
          Expanded(
            flex: 1, // Adjust flex as needed
            child: _selectedItemForDetails == null
                ? const Center(child: Text('Select an item for details'))
                : ItemDetailsPanel(
                    item: _selectedItemForDetails!,
                    onUpdateGear: _updateGearState,
                    character: widget.character),
          ),
        ],
      );
    } else {
      // Small screen layout (single pane + modal)
      return CustomScrollView(
        slivers: [
          _buildSearchBar(),
          if (_searchQuery.isNotEmpty) _buildSearchResultsSummary(),
          _buildLocationSliverList(sortedLocations, groupedItems),
        ],
      );
      // The modal popover will be triggered by a gesture
    }
  }

  void _updateGearState(Gear gear,
      {bool? equipped, bool? wireless, bool? active}) {
    setState(() {
      final index = _items.indexWhere((item) => item.sourceId == gear.sourceId);
      if (index != -1) {
        final oldGear = _items[index] as Gear;
        _items[index] = oldGear.copyWith(
          equipped: equipped ?? oldGear.equipped,
          wirelessOn: wireless ?? oldGear.wirelessOn,
          active: active ?? oldGear.active,
        ) as T;

        // Also update the selected item if it's the one being changed
        if (_selectedItemForDetails?.sourceId == gear.sourceId) {
          _selectedItemForDetails = _items[index];
        }
      }
    });
  }

  // Helper methods for your slivers (extract them from the original build method)
  SliverToBoxAdapter _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Search items...',
            hintText: 'Enter item name or category',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                      });
                      debugPrint(
                          'ShadowrunItemLocationTreeView: Search cleared');
                    },
                  )
                : null,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            debugPrint(
                'ShadowrunItemLocationTreeView: Search query changed to: "$value"');
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSearchResultsSummary() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Text(
          'Showing results for: "$_searchQuery"',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
      ),
    );
  }

  SliverList _buildLocationSliverList(List<Location> sortedLocations,
      Map<String, List<ShadowrunItem>> groupedItems) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final Location location = sortedLocations[index];
          final List<ShadowrunItem> itemsInLocation =
              groupedItems[location.guid] ?? [];

          // Apply search filter
          final List<ShadowrunItem> filteredItems =
              _filterItemsByType(itemsInLocation, _searchQuery);

          // Skip locations with no matching items when filtering
          if (_searchQuery.isNotEmpty && filteredItems.isEmpty) {
            return const SizedBox.shrink();
          }

          debugPrint(
              'ShadowrunItemLocationTreeView.build: Building location tile $index: "${location.name}" with ${filteredItems.length} filtered items (${itemsInLocation.length} total)');

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ExpansionTile(
              key: PageStorageKey<String>(
                  location.guid), // Important for state preservation
              initiallyExpanded: _searchQuery.isNotEmpty ||
                  index == 0, // Auto-expand when searching or at root level
              title: Text(
                location.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_searchQuery.isNotEmpty
                  ? '${filteredItems.length} matching items (${itemsInLocation.length} total)'
                  : '${itemsInLocation.length} items'),
              children: filteredItems.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No items in this location.'),
                      ),
                    ]
                  : _buildItemTilesRecursively(
                      context, filteredItems), // Pass filteredItems directly
            ),
          );
        },
        childCount: sortedLocations.length,
      ),
    );
  }

  // Method to show item details (called from gesture handler)
  void _showItemDetails(ShadowrunItem item, breakpoint) {
    if (MediaQuery.of(context).size.width > breakpoint) {
      setState(() {
        _selectedItemForDetails = item;
      });
    } else {
      // Show modal popover
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return ItemDetailsModal(
            item: item,
            onUpdateGear: _updateGearState,
            character: widget.character,
          );
        },
      );
      // Or showDialog for a full-screen dialog
      /*
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ItemDetailsModal(item: item),
          );
        },
      );
      */
    }
  }
}

class ItemDetailsPanel extends StatelessWidget {
  final ShadowrunItem item;
  final Function(Gear, {bool? equipped, bool? wireless, bool? active})
      onUpdateGear;
  final ShadowrunCharacter? character; // Add character parameter

  const ItemDetailsPanel({
    super.key, 
    required this.item, 
    required this.onUpdateGear,
    this.character, // Optional character parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              item.runtimeType
                  .toString()
                  .split(' ')
                  .last, // Display the actual class name
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
            const Divider(),
            item.getDetailsContent(context, onUpdate: (ShadowrunItem updatedItem, {bool? equipped, bool? wireless, bool? active}) {
              if (updatedItem is Gear) {
                onUpdateGear(updatedItem, equipped: equipped, wireless: wireless, active: active);
              }
            }, characterAttributes: _getCharacterAttributes()),
            // You can add more complex widgets here to display nested lists (mods, children, etc.)
            // For example, if item is a Vehicle, display its mods and mounts in sub-sections.
          ],
        ),
      ),
    );
  }

  /// Helper method to extract character attributes into a Map format for expression evaluation
  Map<String, int>? _getCharacterAttributes() {
    if (character == null) return null;
    
    return {
      'STR': character!.strength,
      'BOD': character!.body,
      'AGI': character!.agility,
      'REA': character!.reaction,
      'CHA': character!.charisma,
      'INT': character!.intuition,
      'LOG': character!.logic,
      'WIL': character!.willpower,
      'EDG': character!.edge,
      'MAG': character!.magic,
      'RES': character!.resonance,
    };
  }
}

class ItemDetailsModal extends StatelessWidget {
  final ShadowrunItem item;
  final Function(Gear, {bool? equipped, bool? wireless, bool? active})
      onUpdateGear;
  final ShadowrunCharacter? character; // Add character parameter

  const ItemDetailsModal({
    super.key, 
    required this.item, 
    required this.onUpdateGear,
    this.character, // Optional character parameter
  });

  @override
  Widget build(BuildContext context) {
    // Content will be very similar to ItemDetailsPanel, just wrapped in a modal context.
    // Use a SingleChildScrollView if content can be long.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Essential for showModalBottomSheet
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Text(
            item.runtimeType.toString().split(' ').last,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontStyle: FontStyle.italic),
          ),
          const Divider(),
          // Display details here, using the new ShadowrunItem methods
          item.getDetailsContent(context, onUpdate: (ShadowrunItem updatedItem, {bool? equipped, bool? wireless, bool? active}) {
            if (updatedItem is Gear) {
              onUpdateGear(updatedItem, equipped: equipped, wireless: wireless, active: active);
            }
          }, characterAttributes: _getCharacterAttributes()),
          const SizedBox(height: 20), // Padding at the bottom for modal
        ],
      ),
    );
  }

  /// Helper method to extract character attributes into a Map format for expression evaluation
  Map<String, int>? _getCharacterAttributes() {
    if (character == null) return null;
    
    return {
      'STR': character!.strength,
      'BOD': character!.body,
      'AGI': character!.agility,
      'REA': character!.reaction,
      'CHA': character!.charisma,
      'INT': character!.intuition,
      'LOG': character!.logic,
      'WIL': character!.willpower,
      'EDG': character!.edge,
      'MAG': character!.magic,
      'RES': character!.resonance,
    };
  }
}


