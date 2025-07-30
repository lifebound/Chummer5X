import 'package:flutter/material.dart';
import 'package:chummer5x/models/items/vehicle.dart';
import 'package:chummer5x/models/items/location.dart';

class VehicleLocationTreeView extends StatefulWidget {
  final Map<String, Location> allLocations;
  final List<Vehicle> allVehicles;

  const VehicleLocationTreeView({
    super.key,
    required this.allLocations,
    required this.allVehicles,
  });

  @override
  State<VehicleLocationTreeView> createState() => _VehicleLocationTreeViewState();
}

class _VehicleLocationTreeViewState extends State<VehicleLocationTreeView> {
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    debugPrint('VehicleLocationTreeView constructor called with ${widget.allLocations.length} locations and ${widget.allVehicles.length} vehicles');
  }

  // Helper to group vehicles by their location GUID
  Map<String, List<Vehicle>> _groupVehiclesByLocation() {
    debugPrint('_groupVehiclesByLocation: Starting to group ${widget.allVehicles.length} vehicles');
    final Map<String, List<Vehicle>> groupedVehicles = {};

    for (var vehicle in widget.allVehicles) {
      final String locationGuid = vehicle.locationGuid ?? defaultGearLocationGuid;
      debugPrint('_groupVehiclesByLocation: Vehicle "${vehicle.name}" has locationGuid: $locationGuid');
      if (!groupedVehicles.containsKey(locationGuid)) {
        groupedVehicles[locationGuid] = [];
        debugPrint('_groupVehiclesByLocation: Created new group for locationGuid: $locationGuid');
      }
      groupedVehicles[locationGuid]!.add(vehicle);
    }
    debugPrint('_groupVehiclesByLocation: Grouped vehicles into ${groupedVehicles.length} locations:');
    groupedVehicles.forEach((locationGuid, vehicles) {
      debugPrint('  Location $locationGuid: ${vehicles.length} items - ${vehicles.map((v) => v.name).join(', ')}');
    });
    return groupedVehicles;
  }

  // Helper method to check if a vehicle or its components match the search query
  bool _vehicleMatchesSearch(Vehicle vehicle, String query) {
    if (query.isEmpty) return true;
    
    final String lowerQuery = query.toLowerCase();
    
    // Check if current vehicle matches
    if (vehicle.name.toLowerCase().contains(lowerQuery) ||
        vehicle.category.toLowerCase().contains(lowerQuery)) {
      return true;
    }
    
    // Check if any mod matches
    for (var mod in vehicle.mods) {
      if (mod.name.toLowerCase().contains(lowerQuery) ||
          mod.category.toLowerCase().contains(lowerQuery)) {
        return true;
      }
    }
    
    // Check if any weapon mount matches
    for (var mount in vehicle.weaponMounts) {
      if (mount.name.toLowerCase().contains(lowerQuery)) {
        return true;
      }
    }
    
    // Check if any gear matches (recursively since gear can have children)
    for (var gear in vehicle.gears) {
      if (_gearMatchesSearchRecursive(gear, lowerQuery)) {
        return true;
      }
    }
    
    // Check if any weapon matches
    if (vehicle.weapons != null) {
      for (var weapon in vehicle.weapons!) {
        if (weapon.name.toLowerCase().contains(lowerQuery) ||
            weapon.category.toLowerCase().contains(lowerQuery)) {
          return true;
        }
      }
    }
    
    return false;
  }

  // Helper to recursively search gear (since gear can have children)
  bool _gearMatchesSearchRecursive(dynamic gear, String lowerQuery) {
    if (gear.name.toLowerCase().contains(lowerQuery) ||
        gear.category.toLowerCase().contains(lowerQuery)) {
      return true;
    }
    
    // If gear has children, search them too
    if (gear.children != null) {
      for (var child in gear.children!) {
        if (_gearMatchesSearchRecursive(child, lowerQuery)) {
          return true;
        }
      }
    }
    
    return false;
  }

  // Helper method to filter vehicle list based on search query
  List<Vehicle> _filterVehicles(List<Vehicle> vehicles, String query) {
    if (query.isEmpty) return vehicles;
    
    List<Vehicle> filteredVehicles = [];
    
    for (var vehicle in vehicles) {
      if (_vehicleMatchesSearch(vehicle, query)) {
        filteredVehicles.add(vehicle);
      }
    }
    
    return filteredVehicles;
  }

  // Helper method to recursively build vehicle tiles with nested components
  List<Widget> _buildVehicleTilesRecursively(BuildContext context, List<Vehicle> vehicles, {int indentLevel = 0}) {
    final List<Widget> widgets = [];
    
    for (var vehicle in vehicles) {
      debugPrint('VehicleLocationTreeView._buildVehicleTilesRecursively: Building vehicle tile for "${vehicle.name}" (indent: $indentLevel)');
      
      final EdgeInsets padding = EdgeInsets.only(left: indentLevel * 16.0);
      
      // Check if this specific vehicle matches the search (for highlighting)
      final bool vehicleMatches = _searchQuery.isNotEmpty && 
          (vehicle.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
           vehicle.category.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      // Vehicle always has components, so always use ExpansionTile
      widgets.add(
        Padding(
          padding: padding,
          child: ExpansionTile(
            key: PageStorageKey<String>('vehicle_${vehicle.sourceId}'),
            initiallyExpanded: _searchQuery.isNotEmpty,
            leading: Icon(
              Icons.directions_car_outlined,
              color: vehicleMatches ? Theme.of(context).colorScheme.primary : null,
            ),
            title: Text(
              vehicle.name,
              style: TextStyle(
                fontWeight: vehicleMatches ? FontWeight.bold : FontWeight.normal,
                color: vehicleMatches ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
            subtitle: Text(
              'Category: ${vehicle.category}, Body: ${vehicle.body}, Cost: ${vehicle.cost}¥',
              style: TextStyle(
                color: vehicleMatches ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
            onExpansionChanged: (expanded) {
              debugPrint('VehicleLocationTreeView: Vehicle "${vehicle.name}" ${expanded ? 'expanded' : 'collapsed'}');
            },
            children: [
              // Vehicle Mods Section
              if (vehicle.mods.isNotEmpty)
                ExpansionTile(
                  leading: const Icon(Icons.build_outlined),
                  title: const Text('Vehicle Modifications'),
                  subtitle: Text('${vehicle.mods.length} mods'),
                  children: vehicle.mods.map((mod) {
                    final bool modMatches = _searchQuery.isNotEmpty && 
                        (mod.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                         mod.category.toLowerCase().contains(_searchQuery.toLowerCase()));
                    
                    return ListTile(
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
                        debugPrint('VehicleLocationTreeView: User tapped on vehicle mod "${mod.name}"');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tapped on ${mod.name}')),
                        );
                      },
                    );
                  }).toList(),
                ),
              
              // Weapon Mounts Section
              if (vehicle.weaponMounts.isNotEmpty)
                ExpansionTile(
                  leading: const Icon(Icons.gps_fixed_outlined),
                  title: const Text('Weapon Mounts'),
                  subtitle: Text('${vehicle.weaponMounts.length} mounts'),
                  children: vehicle.weaponMounts.map((mount) {
                    final bool mountMatches = _searchQuery.isNotEmpty && 
                        mount.name.toLowerCase().contains(_searchQuery.toLowerCase());
                    
                    return ListTile(
                      leading: Icon(
                        Icons.my_location_outlined,
                        color: mountMatches ? Theme.of(context).colorScheme.primary : null,
                      ),
                      title: Text(
                        mount.name,
                        style: TextStyle(
                          fontWeight: mountMatches ? FontWeight.bold : FontWeight.normal,
                          color: mountMatches ? Theme.of(context).colorScheme.primary : null,
                        ),
                      ),
                      subtitle: Text('Slots: ${mount.slots}, Cost: ${mount.cost}'),
                      onTap: () {
                        debugPrint('VehicleLocationTreeView: User tapped on weapon mount "${mount.name}"');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tapped on ${mount.name}')),
                        );
                      },
                    );
                  }).toList(),
                ),
              
              // Vehicle Gear Section
              if (vehicle.gears.isNotEmpty)
                ExpansionTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: const Text('Vehicle Gear'),
                  subtitle: Text('${vehicle.gears.length} items'),
                  children: _buildGearList(context, vehicle.gears),
                ),
              
              // Vehicle Weapons Section
              if (vehicle.weapons != null && vehicle.weapons!.isNotEmpty)
                ExpansionTile(
                  leading: const Icon(Icons.gps_fixed),
                  title: const Text('Vehicle Weapons'),
                  subtitle: Text('${vehicle.weapons!.length} weapons'),
                  children: vehicle.weapons!.map((weapon) {
                    final bool weaponMatches = _searchQuery.isNotEmpty && 
                        (weapon.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                         weapon.category.toLowerCase().contains(_searchQuery.toLowerCase()));
                    
                    return ListTile(
                      leading: Icon(
                        Icons.gps_fixed,
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
                        'Category: ${weapon.category}, Damage: ${weapon.damage}',
                        style: TextStyle(
                          color: weaponMatches ? Theme.of(context).colorScheme.primary : null,
                        ),
                      ),
                      onTap: () {
                        debugPrint('VehicleLocationTreeView: User tapped on vehicle weapon "${weapon.name}"');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tapped on ${weapon.name}')),
                        );
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      );
    }
    
    return widgets;
  }

  // Helper to build gear list (recursively for nested gear)
  List<Widget> _buildGearList(BuildContext context, List<dynamic> gears) {
    return gears.map((gear) {
      final bool gearMatches = _searchQuery.isNotEmpty && 
          (gear.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
           gear.category.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      final bool hasChildren = gear.children != null && gear.children!.isNotEmpty;
      
      if (hasChildren) {
        return ExpansionTile(
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
          children: _buildGearList(context, gear.children!),
        );
      } else {
        return ListTile(
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
            debugPrint('VehicleLocationTreeView: User tapped on vehicle gear "${gear.name}"');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped on ${gear.name}')),
            );
          },
        );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('VehicleLocationTreeView.build: Building widget with search query: "$_searchQuery"');
    final Map<String, List<Vehicle>> groupedVehicles = _groupVehiclesByLocation();

    // Sort locations to ensure consistent display order
    final List<Location> sortedLocations = widget.allLocations.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    
    debugPrint('VehicleLocationTreeView.build: Available locations:');
    for (var location in sortedLocations) {
      debugPrint('  Location: "${location.name}" (GUID: ${location.guid}, sortOrder: ${location.sortOrder})');
    }
    
    debugPrint('VehicleLocationTreeView.build: Building UI with ${sortedLocations.length} locations');

    return CustomScrollView(
      slivers: [
        // Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search vehicles...',
                hintText: 'Enter vehicle name or category',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                          debugPrint('VehicleLocationTreeView: Search cleared');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                debugPrint('VehicleLocationTreeView: Search query changed to: "$value"');
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
        
        // Vehicle locations list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final Location location = sortedLocations[index];
              final List<Vehicle> vehiclesInLocation = groupedVehicles[location.guid] ?? [];
              
              // Apply search filter
              final List<Vehicle> filteredVehicles = _filterVehicles(vehiclesInLocation, _searchQuery);
              
              // Skip locations with no matching vehicles when filtering
              if (_searchQuery.isNotEmpty && filteredVehicles.isEmpty) {
                return const SizedBox.shrink();
              }
              
              debugPrint('VehicleLocationTreeView.build: Building location tile $index: "${location.name}" with ${filteredVehicles.length} filtered items (${vehiclesInLocation.length} total)');

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
                      ? '${filteredVehicles.length} matching items (${vehiclesInLocation.length} total)'
                      : '${vehiclesInLocation.length} items'),
                  children: filteredVehicles.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No vehicles in this location.'),
                          ),
                        ]
                      : _buildVehicleTilesRecursively(context, filteredVehicles),
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