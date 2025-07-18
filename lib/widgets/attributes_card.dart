import 'package:flutter/material.dart';
import '../models/shadowrun_character.dart';
import '../utils/responsive_layout.dart';
import 'package:chummer5x/models/attributes.dart';

class AttributesCard extends StatelessWidget {
  final ShadowrunCharacter character;

  const AttributesCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attributes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildAttributeGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeGrid(BuildContext context) {
    // Map standard Shadowrun attributes to categories for better organization
    String getAttributeCategory(String name) {
      final physicalAttributes = ['BOD', 'AGI', 'REA', 'STR', 'Body', 'Agility', 'Reaction', 'Strength'];
      final mentalAttributes = ['CHA', 'INT', 'LOG', 'WIL', 'Charisma', 'Intuition', 'Logic', 'Willpower'];
      final specialAttributes = ['EDG', 'MAG', 'MAGAdept', 'RES', 'ESS', 'DEP', 'Edge', 'Magic', 'Resonance', 'Essence'];
      
      if (physicalAttributes.contains(name)) return 'Physical';
      if (mentalAttributes.contains(name)) return 'Mental';
      if (specialAttributes.contains(name)) return 'Special';
      return 'Other';
    }

    // Filter attributes based on enabled flags and display rules
    List<Attribute> filterAttributes(List<Attribute> attributes) {
      return attributes.where((attr) {
        // Always hide MAGAdept - no reason to display it
        if (attr.name == 'MAGAdept') return false;
        
        // Only display DEP if depEnabled is true
        if (attr.name == 'DEP') {
          return character.depEnabled;
        }
        
        // Only display MAG if magEnabled is true  
        if (attr.name == 'MAG') {
          return character.magEnabled;
        }
        
        // Only display RES if resEnabled is true
        if (attr.name == 'RES') {
          return character.resEnabled;
        }
        if (attr.name == 'ESS') {
          //never show ESS, it's not an attribute that should be displayed
          return false;
        }
        return true;
      }).toList();
    }
    
    final physicalAttributes = filterAttributes(character.attributes.where((attr) => getAttributeCategory(attr.name) == 'Physical').toList());
    final mentalAttributes = filterAttributes(character.attributes.where((attr) => getAttributeCategory(attr.name) == 'Mental').toList());
    final specialAttributes = filterAttributes(character.attributes.where((attr) => getAttributeCategory(attr.name) == 'Special').toList());
    final otherAttributes = filterAttributes(character.attributes.where((attr) => getAttributeCategory(attr.name) == 'Other').toList());

    final allAttributes = [...physicalAttributes, ...mentalAttributes, ...specialAttributes, ...otherAttributes];
    
    if (allAttributes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No attributes found',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveLayout.getAttributeGridColumns(context),
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: allAttributes.length,
      itemBuilder: (context, index) {
        final attribute = allAttributes[index];
        final totalValue = (attribute.totalValue + (attribute.adeptMod ?? 0)).toInt();
        final color = _getAttributeColor(totalValue);
        
        return GestureDetector(
          onTap: () => _showAttributeDetails(context, attribute),
          child: Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              border: Border.all(color: color, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  totalValue.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (attribute.adeptMod != null && attribute.adeptMod! > 0) ...[
                  Text(
                    '(+${attribute.adeptMod})',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  attribute.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Show base + karma breakdown
                // if (attribute.base > 0 || attribute.karma > 0)
                //   Text(
                //     '${attribute.base}+${attribute.karma}',
                //     style: TextStyle(
                //       fontSize: 10,
                //       color: Theme.of(context).colorScheme.onSurfaceVariant,
                //     ),
                //   ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getAttributeColor(int value) {
    if (value >= 6) {
      return Colors.purple; // Exceptional
    } else if (value >= 4) {
      return Colors.green; // Good
    } else if (value >= 3) {
      return Colors.orange; // Average
    } else {
      return Colors.red; // Poor
    }
  }

  void _showAttributeDetails(BuildContext context, Attribute attribute) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${attribute.name} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Category', attribute.metatypeCategory),
              _buildDetailRow('Total Value', attribute.totalValue.toInt().toString()),
              _buildDetailRow('Base', attribute.base.toInt().toString()),
              _buildDetailRow('Karma', attribute.karma.toInt().toString()),
              _buildDetailRow('Metatype Min', attribute.metatypeMin.toInt().toString()),
              _buildDetailRow('Metatype Max', attribute.metatypeMax.toInt().toString()),
              _buildDetailRow('Aug Max', attribute.metatypeAugMax.toInt().toString()),
              if (attribute.adeptMod != null)
                _buildDetailRow('Adept Mod', '+${attribute.adeptMod}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
}
