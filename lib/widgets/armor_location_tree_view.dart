import 'package:flutter/material.dart';
import 'package:chummer5x/models/items/armor.dart';
import 'package:chummer5x/models/items/location.dart';

class ArmorLocationTreeView extends StatefulWidget {
  final Map<String, Location> allLocations;
  final List<Armor> allArmors;

  const ArmorLocationTreeView({
    super.key,
    required this.allLocations,
    required this.allArmors,
  });

  @override
  State<ArmorLocationTreeView> createState() => _ArmorLocationTreeViewState();
}

class _ArmorLocationTreeViewState extends State<ArmorLocationTreeView> {
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    debugPrint('ArmorLocationTreeView constructor called with ${widget.allLocations.length} locations and ${widget.allArmors.length} armors');
  }

  // Helper to group armors by their location GUID
  Map<String, List<Armor>> _groupArmorsByLocation() {
    debugPrint('_groupArmorsByLocation: Starting to group ${widget.allArmors.length} armors');
    final Map<String, List<Armor>> groupedArmors = {};

    for (var armor in widget.allArmors) {
      final String locationGuid = armor.locationGuid ?? defaultGearLocationGuid;
      debugPrint('_groupArmorsByLocation: Armor "${armor.name}" has locationGuid: $locationGuid');
      if (!groupedArmors.containsKey(locationGuid)) {
        groupedArmors[locationGuid] = [];
        debugPrint('_groupArmorsByLocation: Created new group for locationGuid: $locationGuid');
      }
      groupedArmors[locationGuid]!.add(armor);
    }
    debugPrint('_groupArmorsByLocation: Grouped armors into ${groupedArmors.length} locations:');
    groupedArmors.forEach((locationGuid, armors) {
      debugPrint('  Location $locationGuid: ${armors.length} items - ${armors.map((a) => a.name).join(', ')}');
    });
    return groupedArmors;
  }

  // Helper method to check if an armor or its mods match the search query
  bool _armorMatchesSearch(Armor armor, String query) {
    if (query.isEmpty) return true;
    
    final String lowerQuery = query.toLowerCase();
    
    // Check if current armor matches
    if (armor.name.toLowerCase().contains(lowerQuery) ||
        armor.category.toLowerCase().contains(lowerQuery)) {
      return true;
    }
    
    // Check if any armor mod matches
    if (armor.armorMods != null) {
      for (var mod in armor.armorMods!) {
        if (mod.name.toLowerCase().contains(lowerQuery) ||
            mod.category.toLowerCase().contains(lowerQuery)) {
          return true;
        }
      }
    }
    
    return false;
  }

  // Helper method to filter armor list based on search query
  List<Armor> _filterArmors(List<Armor> armors, String query) {
    if (query.isEmpty) return armors;
    
    List<Armor> filteredArmors = [];
    
    for (var armor in armors) {
      if (_armorMatchesSearch(armor, query)) {
        filteredArmors.add(armor);
      }
    }
    
    return filteredArmors;
  }

  // Helper method to recursively build armor tiles with nested mods
  List<Widget> _buildArmorTilesRecursively(BuildContext context, List<Armor> armors, {int indentLevel = 0}) {
    final List<Widget> widgets = [];
    
    for (var armor in armors) {
      debugPrint('ArmorLocationTreeView._buildArmorTilesRecursively: Building armor tile for "${armor.name}" (indent: $indentLevel, mods: ${armor.armorMods?.length ?? 0})');
      
      final bool hasMods = armor.armorMods != null && armor.armorMods!.isNotEmpty;
      final EdgeInsets padding = EdgeInsets.only(left: indentLevel * 16.0);
      
      // Check if this specific armor matches the search (for highlighting)
      final bool armorMatches = _searchQuery.isNotEmpty && 
          (armor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
           armor.category.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      if (hasMods) {
        // Create an ExpansionTile for armor with mods
        widgets.add(
          Padding(
            padding: padding,
            child: ExpansionTile(
              key: PageStorageKey<String>('armor_${armor.sourceId}'),
              initiallyExpanded: _searchQuery.isNotEmpty,
              leading: Icon(
                Icons.security_outlined,
                color: armorMatches ? Theme.of(context).colorScheme.primary : null,
              ),
              title: Text(
                armor.name,
                style: TextStyle(
                  fontWeight: armorMatches ? FontWeight.bold : FontWeight.normal,
                  color: armorMatches ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              subtitle: Text(
                'Category: ${armor.category}, Armor: ${armor.armorValue}, Cost: ${armor.cost}¥ (${armor.armorMods!.length} mods)',
                style: TextStyle(
                  color: armorMatches ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              onExpansionChanged: (expanded) {
                debugPrint('ArmorLocationTreeView: Armor "${armor.name}" ${expanded ? 'expanded' : 'collapsed'}');
              },
              children: armor.armorMods!.map((mod) {
                final bool modMatches = _searchQuery.isNotEmpty && 
                    (mod.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                     mod.category.toLowerCase().contains(_searchQuery.toLowerCase()));
                
                return Padding(
                  padding: EdgeInsets.only(left: (indentLevel + 1) * 16.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.extension_outlined,
                      color: modMatches ? Theme.of(context).colorScheme.primary : null,
                    ),
                    title: Text(
                      mod.name,
                      style: TextStyle(
                        fontWeight: modMatches ? FontWeight.bold : FontWeight.normal,
                        color: modMatches ? Theme.of(context).colorScheme.primary : null,
                      ),
                    ),
                    subtitle: Text(
                      'Category: ${mod.category}, Cost: ${mod.cost}¥',
                      style: TextStyle(
                        color: modMatches ? Theme.of(context).colorScheme.primary : null,
                      ),
                    ),
                    onTap: () {
                      debugPrint('ArmorLocationTreeView: User tapped on armor mod "${mod.name}"');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped on ${mod.name}')),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      } else {
        // Create a regular ListTile for armor without mods
        widgets.add(
          Padding(
            padding: padding,
            child: ListTile(
              leading: Icon(
                Icons.security_outlined,
                color: armorMatches ? Theme.of(context).colorScheme.primary : null,
              ),
              title: Text(
                armor.name,
                style: TextStyle(
                  fontWeight: armorMatches ? FontWeight.bold : FontWeight.normal,
                  color: armorMatches ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              subtitle: Text(
                'Category: ${armor.category}, Armor: ${armor.armorValue}, Cost: ${armor.cost}¥',
                style: TextStyle(
                  color: armorMatches ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              onTap: () {
                debugPrint('ArmorLocationTreeView: User tapped on armor "${armor.name}"');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped on ${armor.name}')),
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
    debugPrint('ArmorLocationTreeView.build: Building widget with search query: "$_searchQuery"');
    final Map<String, List<Armor>> groupedArmors = _groupArmorsByLocation();

    // Sort locations to ensure consistent display order
    final List<Location> sortedLocations = widget.allLocations.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    
    debugPrint('ArmorLocationTreeView.build: Available locations:');
    for (var location in sortedLocations) {
      debugPrint('  Location: "${location.name}" (GUID: ${location.guid}, sortOrder: ${location.sortOrder})');
    }
    
    debugPrint('ArmorLocationTreeView.build: Building UI with ${sortedLocations.length} locations');

    return CustomScrollView(
      slivers: [
        // Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search armor...',
                hintText: 'Enter armor name or category',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                          debugPrint('ArmorLocationTreeView: Search cleared');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                debugPrint('ArmorLocationTreeView: Search query changed to: "$value"');
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
        
        // Armor locations list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final Location location = sortedLocations[index];
              final List<Armor> armorsInLocation = groupedArmors[location.guid] ?? [];
              
              // Apply search filter
              final List<Armor> filteredArmors = _filterArmors(armorsInLocation, _searchQuery);
              
              // Skip locations with no matching armor when filtering
              if (_searchQuery.isNotEmpty && filteredArmors.isEmpty) {
                return const SizedBox.shrink();
              }
              
              debugPrint('ArmorLocationTreeView.build: Building location tile $index: "${location.name}" with ${filteredArmors.length} filtered items (${armorsInLocation.length} total)');

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ExpansionTile(
                  key: PageStorageKey<String>(location.guid),
                  initiallyExpanded: _searchQuery.isNotEmpty,
                  title: Text(
                    location.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_searchQuery.isNotEmpty 
                      ? '${filteredArmors.length} matching items (${armorsInLocation.length} total)'
                      : '${armorsInLocation.length} items'),
                  children: filteredArmors.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No armor in this location.'),
                          ),
                        ]
                      : _buildArmorTilesRecursively(context, filteredArmors),
                ),
              );
            },
            childCount: sortedLocations.length,
          ),
        ),
      ],
    );
  }
}