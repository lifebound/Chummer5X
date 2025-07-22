import 'package:flutter/material.dart';
import 'package:chummer5x/models/items/vehicle.dart';
import 'package:chummer5x/models/items/location.dart';

class VehicleLocationTreeView extends StatelessWidget {
  final Map<String, Location> allLocations;
  final List<Vehicle> allVehicles;

  const VehicleLocationTreeView({
    super.key,
    required this.allLocations,
    required this.allVehicles,
  });

  // Helper to group vehicles by their location GUID
  Map<String, List<Vehicle>> _groupVehiclesByLocation() {
    final Map<String, List<Vehicle>> groupedVehicles = {};

    for (var gear in allVehicles) {
      final String locationGuid = gear.locationGuid ?? defaultGearLocationGuid; // Assuming 'location' field holds the GUID
      if (!groupedVehicles.containsKey(locationGuid)) {
        groupedVehicles[locationGuid] = [];
      }
      groupedVehicles[locationGuid]!.add(gear);
    }
    return groupedVehicles;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Vehicle>> groupedVehicles = _groupVehiclesByLocation();

    // Sort locations to ensure consistent display order
    final List<Location> sortedLocations = allLocations.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final Location location = sortedLocations[index];
              final List<Vehicle> vehiclesInLocation = groupedVehicles[location.guid] ?? [];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ExpansionTile(
                  key: PageStorageKey<String>(location.guid), // Important for state preservation
                  title: Text(
                    location.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${vehiclesInLocation.length} items'),
                  children: vehiclesInLocation.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No gear in this location.'),
                          ),
                        ]
                      : vehiclesInLocation.map((gear) {
                          return ListTile(
                            leading: const Icon(Icons.inventory_2_outlined), // Generic gear icon
                            title: Text(gear.name),
                            subtitle: Text('Category: ${gear.category}, Cost: ${gear.cost}¥'),
                            onTap: () {
                              // Handle tap on a specific gear item, e.g., show details
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Tapped on ${gear.name}')),
                              );
                            },
                          );
                        }).toList(),
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