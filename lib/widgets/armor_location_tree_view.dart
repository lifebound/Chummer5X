import 'package:flutter/material.dart';
import 'package:chummer5x/models/items/armor.dart';
import 'package:chummer5x/models/items/location.dart';

class ArmorLocationTreeView extends StatelessWidget {
  final Map<String, Location> allLocations;
  final List<Armor> allArmors;

  const ArmorLocationTreeView({
    super.key,
    required this.allLocations,
    required this.allArmors,
  });

  // Helper to group armors by their location GUID
  Map<String, List<Armor>> _groupArmorsByLocation() {
    final Map<String, List<Armor>> groupedArmors = {};

    for (var gear in allArmors) {
      final String locationGuid = gear.locationGuid ?? defaultGearLocationGuid; // Assuming 'location' field holds the GUID
      if (!groupedArmors.containsKey(locationGuid)) {
        groupedArmors[locationGuid] = [];
      }
      groupedArmors[locationGuid]!.add(gear);
    }
    return groupedArmors;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Armor>> groupedArmors = _groupArmorsByLocation();

    // Sort locations to ensure consistent display order
    final List<Location> sortedLocations = allLocations.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final Location location = sortedLocations[index];
              final List<Armor> armorsInLocation = groupedArmors[location.guid] ?? [];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ExpansionTile(
                  key: PageStorageKey<String>(location.guid), // Important for state preservation
                  title: Text(
                    location.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${armorsInLocation.length} items'),
                  children: armorsInLocation.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No gear in this location.'),
                          ),
                        ]
                      : armorsInLocation.map((gear) {
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