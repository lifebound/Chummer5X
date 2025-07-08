import 'package:flutter/material.dart';
import '../models/shadowrun_character.dart';
import '../widgets/character_info_card.dart';
import '../widgets/attributes_card.dart';

class CharacterDetailScreen extends StatelessWidget {
  final ShadowrunCharacter character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CharacterInfoCard(character: character),
            const SizedBox(height: 16),
            AttributesCard(character: character),
            const SizedBox(height: 16),
            _buildConditionMonitorCard(),
            const SizedBox(height: 16),
            _buildDerivedAttributesCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionMonitorCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Condition Monitors',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildConditionMonitor(
                    'Physical',
                    character.physicalDamage,
                    character.physicalBoxes,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildConditionMonitor(
                    'Stun',
                    character.stunDamage,
                    character.stunBoxes,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionMonitor(String label, int damage, int total, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: total > 0 ? damage / total : 0,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 4),
        Text(
          '$damage / $total',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDerivedAttributesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Derived Attributes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDerivedAttributeGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildDerivedAttributeGrid() {
    final derivedAttributes = [
      ('Initiative', character.initiative.toString()),
      ('Physical Limit', character.physicalLimit.toString()),
      ('Mental Limit', character.mentalLimit.toString()),
      ('Social Limit', character.socialLimit.toString()),
      ('Composure', character.composure.toString()),
      ('Judge Intentions', character.judgeIntentions.toString()),
      ('Memory', character.memory.toString()),
      ('Lift/Carry', character.liftCarry.toString()),
      ('Movement', character.movement.toString()),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: derivedAttributes.length,
      itemBuilder: (context, index) {
        final (label, value) = derivedAttributes[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
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
}
