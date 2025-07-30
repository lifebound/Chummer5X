import 'package:flutter/material.dart';
import 'package:chummer5x/models/items/gear.dart';
import 'package:chummer5x/models/items/location.dart';


//TODO: THIS CODE IS NOT USED YET, IT IS A WORK IN PROGRESS

class GearSliverTreeView extends StatefulWidget {
  

  @override
  State<GearSliverTreeView> createState() => _GearSliverTreeViewState();

  final Map<String, Location> allLocations;
  final List<Gear> allGears;

  const GearSliverTreeView({
    super.key,
    required this.allLocations,
    required this.allGears,
  });

}

List<TreeSliverNode<Gear>> buildGearTreeNodes(List<Gear> gearList) {
  
  return gearList.map((gear) {
    return TreeSliverNode<Gear>(
      gear, 
      children: buildGearTreeNodes(gear.children ?? []),
    );
  }).toList(); 
}


class _GearSliverTreeViewState extends State<GearSliverTreeView> {
  late TreeSliverController controller;
  late List<TreeSliverNode<Gear>> _tree;


  @override
  void initState() {
    super.initState();
    _tree = buildGearTreeNodes(widget.allGears);
    controller = TreeSliverController();
  }
  
  // @override 
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return TreeSliver<Gear>(
            tree: _tree, // Provide the list of TreeSliverNodes
            controller: controller, // Attach the controller
            // This builder defines how each individual TreeSliverNode (which contains a Gear object)
            // should be rendered visually.
            treeNodeBuilder: (context, node, animationStyle) {
              final Gear gear = node.content as Gear; // Access your custom Gear object from the node
              final isExpanded = node.isExpanded; // Check if the node is currently expanded
              final hasAttachments = node.children.isNotEmpty; // Check if this gear has attachments

              return InkWell(
                onTap: () {
                  // If the gear has attachments, toggle its expanded state when tapped.
                  if (hasAttachments) {
                    controller.toggleNode(node);
                  }
                },
                child: Padding(
                  // Apply left padding based on the node's depth (level) in the tree.
                  // This creates the visual indentation for nested items.
                  padding: EdgeInsets.only(left: 16.0 * (node.depth ?? 0)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: node.depth!.isEven ? Colors.grey.shade50 : Colors.white,
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [
                        // Show an expand/collapse icon if the gear has attachments.
                        if (hasAttachments)
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                            size: 20.0,
                            color: Colors.deepPurple,
                          )
                        else
                          // If no children, use a SizedBox to maintain alignment with other rows.
                          const SizedBox(width: 20.0),
                        const SizedBox(width: 12.0), // Spacer between icon/spacer and text
                        Expanded(
                          child: Text(
                            gear.name,
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: node.depth == 0 ? FontWeight.bold : FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        // Display the ID of the gear item.
                        Text(
                          'ID: ${gear.source}',
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            // Define the height of each row. You might need to adjust this
            // if your treeNodeBuilder creates widgets of varying heights.
            treeRowExtentBuilder: (context, node) {
              return 60.0; // A fixed height for all rows in this example
            },
            // Optional: Customize the animation for expanding/collapsing nodes.
            toggleAnimationStyle: const AnimationStyle(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
            ),
          );
  }
}