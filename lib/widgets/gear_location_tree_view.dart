import 'package:flutter/material.dart';
import 'package:chummer5x/models/items/gear.dart';
import 'package:chummer5x/models/items/location.dart';

class GearLocationTreeView extends StatelessWidget {
  final Map<String, Location> allLocations;
  final List<Gear> allGears;

  const GearLocationTreeView({
    super.key,
    required this.allLocations,
    required this.allGears,
  });

  // Helper to group gears by their location GUID
  Map<String, List<Gear>> _groupGearsByLocation() {
    final Map<String, List<Gear>> groupedGears = {};

    for (var gear in allGears) {
      final String locationGuid = gear.locationGuid ?? defaultGearLocationGuid; // Assuming 'location' field holds the GUID
      if (!groupedGears.containsKey(locationGuid)) {
        groupedGears[locationGuid] = [];
      }
      groupedGears[locationGuid]!.add(gear);
    }
    return groupedGears;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Gear>> groupedGears = _groupGearsByLocation();

    // Sort locations to ensure consistent display order
    final List<Location> sortedLocations = allLocations.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final Location location = sortedLocations[index];
              final List<Gear> gearsInLocation = groupedGears[location.guid] ?? [];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ExpansionTile(
                  key: PageStorageKey<String>(location.guid), // Important for state preservation
                  title: Text(
                    location.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${gearsInLocation.length} items'),
                  children: gearsInLocation.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No gear in this location.'),
                          ),
                        ]
                      : gearsInLocation.map((gear) {
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