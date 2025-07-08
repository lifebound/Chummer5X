import 'package:flutter/material.dart';
import '../models/shadowrun_character.dart';

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
            _buildAttributeGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeGrid() {
    final attributes = [
      ('Body', character.body, _getAttributeColor(character.body)),
      ('Agility', character.agility, _getAttributeColor(character.agility)),
      ('Reaction', character.reaction, _getAttributeColor(character.reaction)),
      ('Strength', character.strength, _getAttributeColor(character.strength)),
      ('Charisma', character.charisma, _getAttributeColor(character.charisma)),
      ('Intuition', character.intuition, _getAttributeColor(character.intuition)),
      ('Logic', character.logic, _getAttributeColor(character.logic)),
      ('Willpower', character.willpower, _getAttributeColor(character.willpower)),
      ('Edge', character.edge, _getAttributeColor(character.edge)),
      if (character.magic > 0) ('Magic', character.magic, _getAttributeColor(character.magic)),
      if (character.resonance > 0) ('Resonance', character.resonance, _getAttributeColor(character.resonance)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: attributes.length,
      itemBuilder: (context, index) {
        final (label, value, color) = attributes[index];
        return Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
}
