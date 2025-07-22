import 'package:flutter/material.dart';
import 'package:chummer5x/models/items/weapon.dart';
import 'package:chummer5x/models/items/location.dart';

class WeaponLocationTreeView extends StatefulWidget {
  final Map<String, Location> allLocations;
  final List<Weapon> allWeapons;

  const WeaponLocationTreeView({
    super.key,
    required this.allLocations,
    required this.allWeapons,
  });

  @override
  State<WeaponLocationTreeView> createState() => _WeaponLocationTreeViewState();
}

class _WeaponLocationTreeViewState extends State<WeaponLocationTreeView> {
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    debugPrint('WeaponLocationTreeView constructor called with ${widget.allLocations.length} locations and ${widget.allWeapons.length} weapons');
  }

  // Helper to group weapons by their location GUID
  Map<String, List<Weapon>> _groupWeaponsByLocation() {
    debugPrint('_groupWeaponsByLocation: Starting to group ${widget.allWeapons.length} weapons');
    final Map<String, List<Weapon>> groupedWeapons = {};

    for (var weapon in widget.allWeapons) {
      final String locationGuid = weapon.locationGuid ?? defaultGearLocationGuid;
      debugPrint('_groupWeaponsByLocation: Weapon "${weapon.name}" has locationGuid: $locationGuid');
      if (!groupedWeapons.containsKey(locationGuid)) {
        groupedWeapons[locationGuid] = [];
        debugPrint('_groupWeaponsByLocation: Created new group for locationGuid: $locationGuid');
      }
      groupedWeapons[locationGuid]!.add(weapon);
    }
    debugPrint('_groupWeaponsByLocation: Grouped weapons into ${groupedWeapons.length} locations:');
    groupedWeapons.forEach((locationGuid, weapons) {
      debugPrint('  Location $locationGuid: ${weapons.length} items - ${weapons.map((w) => w.name).join(', ')}');
    });
    return groupedWeapons;
  }

  // Helper method to check if a weapon or its accessories match the search query
  bool _weaponMatchesSearch(Weapon weapon, String query) {
    if (query.isEmpty) return true;
    
    final String lowerQuery = query.toLowerCase();
    
    // Check if current weapon matches
    if (weapon.name.toLowerCase().contains(lowerQuery) ||
        weapon.category.toLowerCase().contains(lowerQuery)) {
      return true;
    }
    
    // Check if any accessory matches
    if (weapon.accessories != null) {
      for (var accessory in weapon.accessories!) {
        if (accessory.name.toLowerCase().contains(lowerQuery) ||
            accessory.mount.toLowerCase().contains(lowerQuery)) {
          return true;
        }
      }
    }
    
    return false;
  }

  // Helper method to filter weapon list based on search query
  List<Weapon> _filterWeapons(List<Weapon> weapons, String query) {
    if (query.isEmpty) return weapons;
    
    List<Weapon> filteredWeapons = [];
    
    for (var weapon in weapons) {
      if (_weaponMatchesSearch(weapon, query)) {
        filteredWeapons.add(weapon);
      }
    }
    
    return filteredWeapons;
  }

  // Helper method to recursively build weapon tiles with nested accessories
  List<Widget> _buildWeaponTilesRecursively(BuildContext context, List<Weapon> weapons, {int indentLevel = 0}) {
    final List<Widget> widgets = [];
    
    for (var weapon in weapons) {
      debugPrint('WeaponLocationTreeView._buildWeaponTilesRecursively: Building weapon tile for "${weapon.name}" (indent: $indentLevel, accessories: ${weapon.accessories?.length ?? 0})');
      
      final bool hasAccessories = weapon.accessories != null && weapon.accessories!.isNotEmpty;
      final EdgeInsets padding = EdgeInsets.only(left: indentLevel * 16.0);
      
      // Check if this specific weapon matches the search (for highlighting)
      final bool weaponMatches = _searchQuery.isNotEmpty && 
          (weapon.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
           weapon.category.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      if (hasAccessories) {
        // Create an ExpansionTile for weapon with accessories
        widgets.add(
          Padding(
            padding: padding,
            child: ExpansionTile(
              key: PageStorageKey<String>('weapon_${weapon.sourceId}'),
              initiallyExpanded: _searchQuery.isNotEmpty,
              leading: Icon(
                Icons.gps_fixed_outlined,
                color: weaponMatches ? Theme.of(context).colorScheme.primary : null,
              ),
              title: Text(
                weapon.name,
                style: TextStyle(
                  fontWeight: weaponMatches ? FontWeight.bold : FontWeight.normal,
                  color: weaponMatches ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              subtitle: Text(
                'Category: ${weapon.category}, Damage: ${weapon.damage}, Cost: ${weapon.cost}¥ (${weapon.accessories!.length} accessories)',
                style: TextStyle(
                  color: weaponMatches ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              onExpansionChanged: (expanded) {
                debugPrint('WeaponLocationTreeView: Weapon "${weapon.name}" ${expanded ? 'expanded' : 'collapsed'}');
              },
              children: weapon.accessories!.map((accessory) {
                final bool accessoryMatches = _searchQuery.isNotEmpty && 
                    (accessory.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                     accessory.mount.toLowerCase().contains(_searchQuery.toLowerCase()));
                
                return Padding(
                  padding: EdgeInsets.only(left: (indentLevel + 1) * 16.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.extension_outlined,
                      color: accessoryMatches ? Theme.of(context).colorScheme.primary : null,
                    ),
                    title: Text(
                      accessory.name,
                      style: TextStyle(
                        fontWeight: accessoryMatches ? FontWeight.bold : FontWeight.normal,
                        color: accessoryMatches ? Theme.of(context).colorScheme.primary : null,
                      ),
                    ),
                    subtitle: Text(
                      'Mount: ${accessory.mount}, Cost: ${accessory.cost}',
                      style: TextStyle(
                        color: accessoryMatches ? Theme.of(context).colorScheme.primary : null,
                      ),
                    ),
                    onTap: () {
                      debugPrint('WeaponLocationTreeView: User tapped on weapon accessory "${accessory.name}"');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped on ${accessory.name}')),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      } else {
        // Create a regular ListTile for weapon without accessories
        widgets.add(
          Padding(
            padding: padding,
            child: ListTile(
              leading: Icon(
                Icons.gps_fixed_outlined,
                color: weaponMatches ? Theme.of(context).colorScheme.primary : null,
              ),
              title: Text(
                weapon.name,
                style: TextStyle(
                  fontWeight: weaponMatches ? FontWeight.bold : FontWeight.normal,
                  color: weaponMatches ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              subtitle: Text(
                'Category: ${weapon.category}, Damage: ${weapon.damage}, Cost: ${weapon.cost}¥',
                style: TextStyle(
                  color: weaponMatches ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              onTap: () {
                debugPrint('WeaponLocationTreeView: User tapped on weapon "${weapon.name}"');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped on ${weapon.name}')),
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
    debugPrint('WeaponLocationTreeView.build: Building widget with search query: "$_searchQuery"');
    final Map<String, List<Weapon>> groupedWeapons = _groupWeaponsByLocation();

    // Sort locations to ensure consistent display order
    final List<Location> sortedLocations = widget.allLocations.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    
    debugPrint('WeaponLocationTreeView.build: Available locations:');
    for (var location in sortedLocations) {
      debugPrint('  Location: "${location.name}" (GUID: ${location.guid}, sortOrder: ${location.sortOrder})');
    }
    
    debugPrint('WeaponLocationTreeView.build: Building UI with ${sortedLocations.length} locations');

    return CustomScrollView(
      slivers: [
        // Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search weapons...',
                hintText: 'Enter weapon name or category',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                          debugPrint('WeaponLocationTreeView: Search cleared');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                debugPrint('WeaponLocationTreeView: Search query changed to: "$value"');
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
        
        // Weapon locations list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final Location location = sortedLocations[index];
              final List<Weapon> weaponsInLocation = groupedWeapons[location.guid] ?? [];
              
              // Apply search filter
              final List<Weapon> filteredWeapons = _filterWeapons(weaponsInLocation, _searchQuery);
              
              // Skip locations with no matching weapons when filtering
              if (_searchQuery.isNotEmpty && filteredWeapons.isEmpty) {
                return const SizedBox.shrink();
              }
              
              debugPrint('WeaponLocationTreeView.build: Building location tile $index: "${location.name}" with ${filteredWeapons.length} filtered items (${weaponsInLocation.length} total)');

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
                      ? '${filteredWeapons.length} matching items (${weaponsInLocation.length} total)'
                      : '${weaponsInLocation.length} items'),
                  children: filteredWeapons.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No weapons in this location.'),
                          ),
                        ]
                      : _buildWeaponTilesRecursively(context, filteredWeapons),
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