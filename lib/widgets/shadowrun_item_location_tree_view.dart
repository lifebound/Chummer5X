// shadowrun_item_location_tree_view.dart (New file or renamed)
import 'package:flutter/material.dart';
import 'package:chummer5x/models/items/location.dart';
import 'package:chummer5x/models/items/shadowrun_item.dart';
import 'package:chummer5x/models/items/gear.dart'; // Still needed for type checking/casting if children exist
import 'package:chummer5x/models/items/armor.dart';
import 'package:chummer5x/models/items/weapon.dart';
import 'package:chummer5x/models/items/vehicle.dart';

class ShadowrunItemLocationTreeView<T extends ShadowrunItem>
    extends StatefulWidget {
  final Map<String, Location> allLocations;
  final List<T> allItems; // Generic list of ShadowrunItem

  const ShadowrunItemLocationTreeView({
    super.key,
    required this.allLocations,
    required this.allItems,
  });

  @override
  State<ShadowrunItemLocationTreeView<T>> createState() =>
      _ShadowrunItemLocationTreeViewState<T>();
}

class _ShadowrunItemLocationTreeViewState<T extends ShadowrunItem>
    extends State<ShadowrunItemLocationTreeView<T>> {
  String _searchQuery = '';
  ShadowrunItem? _selectedItemForDetails;
  static const breakpoint = 600.0; // Define your breakpoint for "large" vs "small" screen

  @override
  void initState() {
    super.initState();
    debugPrint(
        'ShadowrunItemLocationTreeView constructor called with ${widget.allLocations.length} locations and ${widget.allItems.length} items');
  }

  // Helper to group items by their location GUID
  Map<String, List<T>> _groupItemsByLocation() {
    debugPrint(
        '_groupItemsByLocation: Starting to group ${widget.allItems.length} items');
    final Map<String, List<T>> groupedItems = {};

    for (var item in widget.allItems) {
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

  // Helper method to check if an item or its children match the search query
  bool _itemMatchesSearch(ShadowrunItem item, String query) {
    if (query.isEmpty) return true;

    final String lowerQuery = query.toLowerCase();

    // Check if current item matches
    if (item.name.toLowerCase().contains(lowerQuery) ||
        item.category.toLowerCase().contains(lowerQuery)) {
      return true;
    }

    // Check if any child matches recursively (only applicable to Gear, Vehicle, Weapon)
    if (item is Gear && item.children != null) {
      for (var child in item.children!) {
        if (_itemMatchesSearch(child, query)) {
          return true;
        }
      }
    } else if (item is Vehicle) {
      // Check Vehicle's nested items (mods, mounts, gears, weapons)
      for (var mod in item.mods) {
        if (mod.name.toLowerCase().contains(lowerQuery)) return true;
      }
      for (var mount in item.weaponMounts) {
        if (mount.name.toLowerCase().contains(lowerQuery)) return true;
      }
      for (var gear in item.gears) {
        if (_itemMatchesSearch(gear, query))
          return true; // Recursively check nested gear
      }
      if (item.weapons != null) {
        for (var weapon in item.weapons!) {
          if (_itemMatchesSearch(weapon, query))
            return true; // Recursively check nested weapon
        }
      }
    } else if (item is Armor) {
      if (item.armorMods != null) {
        for (var mod in item.armorMods!) {
          if (mod.name.toLowerCase().contains(lowerQuery)) return true;
        }
      }
    } else if (item is Weapon) {
      if (item.accessories != null) {
        for (var acc in item.accessories!) {
          if (acc.name.toLowerCase().contains(lowerQuery)) return true;
        }
      }
    }

    return false;
  }

  // Helper method to filter item list based on search query
  List<ShadowrunItem> _filterItems(List<ShadowrunItem> items, String query) {
    if (query.isEmpty) return items;

    List<ShadowrunItem> filteredItems = [];

    for (var item in items) {
      if (_itemMatchesSearch(item, query)) {
        // If this item or its children match, include it but filter its children
        // This part becomes tricky as creating a "filtered copy" requires knowing the specific type
        // For now, we'll add the original item. If deep filtering of children is needed,
        // you'd need to create a new instance of the specific item type with filtered children.
        // This is a simplification to make the genericization easier.
        // For complex nested structures, consider a separate 'copyWith' method on each ShadowrunItem subclass.

        // For Gear, we can still filter children explicitly because we know the type and it has 'children'.
        if (item is Gear && item.children != null) {
          Gear originalGear = item;
          Gear filteredGear = Gear(
            sourceId: originalGear.sourceId,
            locationGuid: originalGear.locationGuid,
            name: originalGear.name,
            category: originalGear.category,
            source: originalGear.source,
            page: originalGear.page,
            equipped: originalGear.equipped,
            wirelessOn: originalGear.wirelessOn,
            stolen: originalGear.stolen,
            capacity: originalGear.capacity,
            armorCapacity: originalGear.armorCapacity,
            minRating: originalGear.minRating,
            maxRating: originalGear.maxRating,
            rating: originalGear.rating,
            qty: originalGear.qty,
            avail: originalGear.avail,
            cost: originalGear.cost,
            weight: originalGear.weight,
            extra: originalGear.extra,
            bonded: originalGear.bonded,
            forcedValue: originalGear.forcedValue,
            parentId: originalGear.parentId,
            allowRename: originalGear.allowRename,
            children: _filterItems(originalGear.children!.cast<T>(), query)
                .cast<Gear>(), // Recursive call for children
            location: originalGear.location,
            notes: originalGear.notes,
            notesColor: originalGear.notesColor,
            discountedCost: originalGear.discountedCost,
            sortOrder: originalGear.sortOrder,
          ); // Cast back to T for adding to list
          filteredItems.add(filteredGear);
        } else {
          // For other types, we just add the item if it matches.
          // Filtering of nested items (like Vehicle mods) is handled by _itemMatchesSearch
          // determining if the parent should be included. We don't modify the nested lists here.
          filteredItems.add(item);
        }
      }
    }
    return filteredItems;
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
      // } else if (item is Armor &&
      //     item.armorMods != null &&
      //     item.armorMods!.isNotEmpty) {
      //   hasExpandableChildren = true;
      //   childrenToDisplay = item.armorMods!;
      // } else if (item is Weapon &&
      //     item.accessories != null &&
      //     item.accessories!.isNotEmpty) {
      //   hasExpandableChildren = true;
      //   childrenToDisplay = item.accessories!;
      // }

      final EdgeInsets padding = EdgeInsets.only(left: indentLevel * 16.0);

      // Check if this specific item matches the search (for highlighting)
      final bool itemMatches = _searchQuery.isNotEmpty &&
          (item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.category.toLowerCase().contains(_searchQuery.toLowerCase()));

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
              initiallyExpanded:
                  _searchQuery.isNotEmpty, // Auto-expand when searching or at root level
              leading: _getLeadingIcon(item, itemMatches),
              title: Row( // Use a Row to place title text and the info icon
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: itemMatches ? FontWeight.bold : FontWeight.normal,
                      color: itemMatches ? Theme.of(context).colorScheme.primary : null,
                    ),
                  ),
                ),
                // The info icon for details
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  color: Theme.of(context).colorScheme.onSurfaceVariant, // Or a more neutral color
                  onPressed: () {
                    debugPrint('Tapped info icon on expandable item "${item.name}"');
                    _showItemDetails(item, breakpoint); // Call the detail display method
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
      return item.children != null && item.children!.isNotEmpty
          ? Icon(Icons.folder_outlined, color: color)
          : Icon(Icons.inventory_2_outlined, color: color);
    } else if (item is Armor) {
      return Icon(Icons.shield_outlined, color: color);
    } else if (item is Weapon) {
      return Icon(Icons.gavel_outlined,
          color: color); // Or a more weapon-appropriate icon
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
                : ItemDetailsPanel(item: _selectedItemForDetails!),
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
              _filterItems(itemsInLocation, _searchQuery);

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
              initiallyExpanded:
                  _searchQuery.isNotEmpty || index == 0, // Auto-expand when searching or at root level
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
          return ItemDetailsModal(item: item);
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

  const ItemDetailsPanel({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // You'll need to use 'is' checks to display type-specific details
    // similar to how you build the subtitle in your tree view.
    String details = '';
    if (item is Gear) {
      // Details are now handled by _GearDetailsContent
    } else if (item is Armor) {
      final detailItem = item as Armor;
      details =
          'Category: ${detailItem.category}\nArmor Value: ${detailItem.armorValue}\nCost: ${detailItem.cost}¥\nDamage: ${detailItem.damage}\nNotes: ${detailItem.notes ?? 'None'}';
      // Add more Armor specific details
    }
    // ... similarly for Weapon and Vehicle

    return Padding(
      padding: const EdgeInsets.all(16.0),
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
          if (item is Gear)
            _GearDetailsContent(gear: item as Gear)
          else
            Text(details),
          // You can add more complex widgets here to display nested lists (mods, children, etc.)
          // For example, if item is a Vehicle, display its mods and mounts in sub-sections.
        ],
      ),
    );
  }
}

class ItemDetailsModal extends StatelessWidget {
  final ShadowrunItem item;

  const ItemDetailsModal({super.key, required this.item});

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
          // Display details here, using the new shared widget
          if (item is Gear)
            _GearDetailsContent(gear: item as Gear)
          else ...[
            // Fallback for other item types
            Text('Category: ${item.category}'),
            //if (item is Armor) Text('Armor Value: ${item.armorValue}'),
            // ... and so on for all relevant fields based on type
          ],
          const SizedBox(height: 20), // Padding at the bottom for modal
        ],
      ),
    );
  }
}

/// A shared widget to display the detailed content for a Gear item.
class _GearDetailsContent extends StatelessWidget {
  final Gear gear;

  const _GearDetailsContent({required this.gear});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(context, 'Category', gear.category),
        _buildDetailRow(context, 'Source', '${gear.source} p. ${gear.page}'),
        _buildDetailRow(context, 'Availability', gear.avail),
        _buildDetailRow(context, 'Cost', '${gear.cost}¥'),
        _buildDetailRow(context, 'Quantity', gear.qty.toString()),
        const Divider(height: 24, thickness: 1),
        _buildToggleRow(context, 'Equipped', gear.equipped, (value) {
          // TODO: Implement state change logic
          debugPrint('Equipped toggled to: $value');
        }),
        _buildToggleRow(context, 'Wireless', gear.wirelessOn, (value) {
          // TODO: Implement state change logic
          debugPrint('Wireless toggled to: $value');
        }),
        if (gear.category.toLowerCase() == 'commlinks')
          _buildToggleRow(context, 'Active Commlink', false, (value) {
            // TODO: Implement state change logic for active commlink
            debugPrint('Active Commlink toggled to: $value');
          }),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildToggleRow(BuildContext context, String label, bool value, ValueChanged<bool> onChanged) {
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
}
