import 'package:flutter/material.dart';
import 'package:chummer5x/models/items/gear.dart';
import 'package:chummer5x/models/items/location.dart';

class GearLocationTreeView extends StatefulWidget {
  final Map<String, Location> allLocations;
  final List<Gear> allGears;

  const GearLocationTreeView({
    super.key,
    required this.allLocations,
    required this.allGears,
  });

  @override
  State<GearLocationTreeView> createState() => _GearLocationTreeViewState();
}

class _GearLocationTreeViewState extends State<GearLocationTreeView> {
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    debugPrint('GearLocationTreeView constructor called with ${widget.allLocations.length} locations and ${widget.allGears.length} gears');
  }

  // Helper to group gears by their location GUID
  Map<String, List<Gear>> _groupGearsByLocation() {
    debugPrint('_groupGearsByLocation: Starting to group ${widget.allGears.length} gears');
    final Map<String, List<Gear>> groupedGears = {};

    for (var gear in widget.allGears) {
      final String locationGuid = gear.locationGuid ?? defaultGearLocationGuid; // Assuming 'location' field holds the GUID
      debugPrint('_groupGearsByLocation: Gear "${gear.name}" has locationGuid: $locationGuid');
      if (!groupedGears.containsKey(locationGuid)) {
        groupedGears[locationGuid] = [];
        debugPrint('_groupGearsByLocation: Created new group for locationGuid: $locationGuid');
      }
      groupedGears[locationGuid]!.add(gear);
    }
    debugPrint('_groupGearsByLocation: Grouped gears into ${groupedGears.length} locations:');
    groupedGears.forEach((locationGuid, gears) {
      debugPrint('  Location $locationGuid: ${gears.length} items - ${gears.map((g) => g.name).join(', ')}');
    });
    return groupedGears;
  }

  // Helper method to check if a gear or its children match the search query
  bool _gearMatchesSearch(Gear gear, String query) {
    if (query.isEmpty) return true;
    
    final String lowerQuery = query.toLowerCase();
    
    // Check if current gear matches
    if (gear.name.toLowerCase().contains(lowerQuery) ||
        gear.category.toLowerCase().contains(lowerQuery)) {
      return true;
    }
    
    // Check if any child matches recursively
    if (gear.children != null) {
      for (var child in gear.children!) {
        if (_gearMatchesSearch(child, query)) {
          return true;
        }
      }
    }
    
    return false;
  }

  // Helper method to filter gear list based on search query
  List<Gear> _filterGears(List<Gear> gears, String query) {
    if (query.isEmpty) return gears;
    
    List<Gear> filteredGears = [];
    
    for (var gear in gears) {
      if (_gearMatchesSearch(gear, query)) {
        // If this gear or its children match, include it but filter its children
        Gear filteredGear = Gear(
          sourceId: gear.sourceId,
          locationGuid: gear.locationGuid,
          name: gear.name,
          category: gear.category,
          source: gear.source,
          page: gear.page,
          equipped: gear.equipped,
          wirelessOn: gear.wirelessOn,
          stolen: gear.stolen,
          capacity: gear.capacity,
          armorCapacity: gear.armorCapacity,
          minRating: gear.minRating,
          maxRating: gear.maxRating,
          rating: gear.rating,
          qty: gear.qty,
          avail: gear.avail,
          cost: gear.cost,
          weight: gear.weight,
          extra: gear.extra,
          bonded: gear.bonded,
          forcedValue: gear.forcedValue,
          parentId: gear.parentId,
          allowRename: gear.allowRename,
          children: gear.children != null ? _filterGears(gear.children!, query) : null,
          location: gear.location,
          notes: gear.notes,
          notesColor: gear.notesColor,
          discountedCost: gear.discountedCost,
          sortOrder: gear.sortOrder,
        );
        filteredGears.add(filteredGear);
      }
    }
    
    return filteredGears;
  }

  // Helper method to recursively build gear tiles with nested children
  List<Widget> _buildGearTilesRecursively(BuildContext context, List<Gear> gears, {int indentLevel = 0}) {
    final List<Widget> widgets = [];
    
    for (var gear in gears) {
      debugPrint('GearLocationTreeView._buildGearTilesRecursively: Building gear tile for "${gear.name}" (indent: $indentLevel, children: ${gear.children?.length ?? 0})');
      
      final bool hasChildren = gear.children != null && gear.children!.isNotEmpty;
      final EdgeInsets padding = EdgeInsets.only(left: indentLevel * 16.0);
      
      // Check if this specific gear matches the search (for highlighting)
      final bool gearMatches = _searchQuery.isNotEmpty && 
          (gear.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
           gear.category.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      if (hasChildren) {
        // Create an ExpansionTile for gear with children
        widgets.add(
          Padding(
            padding: padding,
            child: ExpansionTile(
              key: PageStorageKey<String>('gear_${gear.sourceId}'),
              initiallyExpanded: _searchQuery.isNotEmpty, // Auto-expand when searching
              leading: Icon(
                Icons.folder_outlined,
                color: gearMatches ? Theme.of(context).colorScheme.primary : null,
              ),
              title: Text(
                gear.name,
                style: TextStyle(
                  fontWeight: gearMatches ? FontWeight.bold : FontWeight.normal,
                  color: gearMatches ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              subtitle: Text(
                'Category: ${gear.category}, Cost: ${gear.cost}¥ (${gear.children!.length} items)',
                style: TextStyle(
                  color: gearMatches ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              onExpansionChanged: (expanded) {
                debugPrint('GearLocationTreeView: Gear "${gear.name}" ${expanded ? 'expanded' : 'collapsed'}');
              },
              children: _buildGearTilesRecursively(context, gear.children!, indentLevel: indentLevel + 1),
            ),
          ),
        );
      } else {
        // Create a regular ListTile for gear without children
        widgets.add(
          Padding(
            padding: padding,
            child: ListTile(
              leading: Icon(
                Icons.inventory_2_outlined,
                color: gearMatches ? Theme.of(context).colorScheme.primary : null,
              ),
              title: Text(
                gear.name,
                style: TextStyle(
                  fontWeight: gearMatches ? FontWeight.bold : FontWeight.normal,
                  color: gearMatches ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              subtitle: Text(
                'Category: ${gear.category}, Cost: ${gear.cost}¥',
                style: TextStyle(
                  color: gearMatches ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              onTap: () {
                debugPrint('GearLocationTreeView: User tapped on gear "${gear.name}"');
                // Handle tap on a specific gear item, e.g., show details
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped on ${gear.name}')),
                );
              },
              onLongPress: () {
                debugPrint('GearLocationTreeView: User long-pressed on gear "${gear.name}"');
                // Handle long press, e.g., show context menu
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Long pressed on ${gear.name}')),
                );
              },
            ),
          ),
        );
      }
    }
    
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('GearLocationTreeView.build: Building widget with search query: "$_searchQuery"');
    final Map<String, List<Gear>> groupedGears = _groupGearsByLocation();

    // Sort locations to ensure consistent display order
    final List<Location> sortedLocations = widget.allLocations.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    
    debugPrint('GearLocationTreeView.build: Available locations:');
    for (var location in sortedLocations) {
      debugPrint('  Location: "${location.name}" (GUID: ${location.guid}, sortOrder: ${location.sortOrder})');
    }
    
    debugPrint('GearLocationTreeView.build: Building UI with ${sortedLocations.length} locations');

    return CustomScrollView(
      slivers: [
        // Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search gear...',
                hintText: 'Enter gear name or category',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                          debugPrint('GearLocationTreeView: Search cleared');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                debugPrint('GearLocationTreeView: Search query changed to: "$value"');
              },
            ),
          ),
        ),
        
        // Results summary (if searching)
        if (_searchQuery.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                'Showing results for: "$_searchQuery"',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        
        // Gear locations list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final Location location = sortedLocations[index];
              final List<Gear> gearsInLocation = groupedGears[location.guid] ?? [];
              
              // Apply search filter
              final List<Gear> filteredGears = _filterGears(gearsInLocation, _searchQuery);
              
              // Skip locations with no matching gear when filtering
              if (_searchQuery.isNotEmpty && filteredGears.isEmpty) {
                return const SizedBox.shrink();
              }
              
              debugPrint('GearLocationTreeView.build: Building location tile $index: "${location.name}" with ${filteredGears.length} filtered items (${gearsInLocation.length} total)');

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ExpansionTile(
                  key: PageStorageKey<String>(location.guid), // Important for state preservation
                  initiallyExpanded: _searchQuery.isNotEmpty || index == 0, // Auto-expand when searching or if initially showing the default location
                  title: Text(
                    location.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_searchQuery.isNotEmpty 
                      ? '${filteredGears.length} matching items (${gearsInLocation.length} total)'
                      : '${gearsInLocation.length} items'),
                  children: filteredGears.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No gear in this location.'),
                          ),
                        ]
                      : _buildGearTilesRecursively(context, filteredGears),
                ),
              );
            },
            childCount: sortedLocations.length,
          ),
        ),
      ],
    );
    // Note: This debugPrint won't execute because we return above, but it shows the structure
    // debugPrint('GearLocationTreeView.build: Widget building completed');
  }
  
}