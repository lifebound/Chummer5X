import 'package:flutter/material.dart';
import '../models/shadowrun_character.dart';

class SkillsScreen extends StatelessWidget {
  final ShadowrunCharacter character;

  const SkillsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (character.skills.isNotEmpty) ...[
              _buildSkillsCard(),
              const SizedBox(height: 16),
            ],
            if (character.spells.isNotEmpty) ...[
              _buildSpellsCard(),
              const SizedBox(height: 16),
            ],
            if (character.adeptPowers.isNotEmpty) ...[
              _buildAdeptPowersCard(),
              const SizedBox(height: 16),
            ],
            if (character.gear.isNotEmpty) ...[
              _buildGearCard(),
              const SizedBox(height: 16),
            ],
            if (character.skills.isEmpty && 
                character.spells.isEmpty && 
                character.adeptPowers.isEmpty && 
                character.gear.isEmpty) ...[
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, size: 50, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        'Enhanced Data Not Available',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'This character file may be using basic parsing. Skills, spells, and detailed equipment data are not available with the current parser.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: character.skills.length,
              itemBuilder: (context, index) {
                final skill = character.skills[index];
                final baseValue = int.tryParse(skill.base ?? '0') ?? 0;
                final karmaValue = int.tryParse(skill.karma ?? '0') ?? 0;
                final totalValue = baseValue + karmaValue + (skill.adeptMod ?? 0);
                
                return ListTile(
                  title: Text(skill.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (skill.adeptMod != null && skill.adeptMod! > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '+${skill.adeptMod}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        totalValue.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  subtitle: skill.skillGroupName.isNotEmpty 
                      ? Text('Group: ${skill.skillGroupName}')
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpellsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spells',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: character.spells.length,
              itemBuilder: (context, index) {
                final spell = character.spells[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getSpellCategoryColor(spell.category),
                    child: Text(
                      spell.category[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(spell.name),
                  subtitle: Text(spell.category),
                  trailing: spell.grade != null 
                      ? Text('Grade ${spell.grade}')
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdeptPowersCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adept Powers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: character.adeptPowers.length,
              itemBuilder: (context, index) {
                final power = character.adeptPowers[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.psychology, color: Colors.white),
                  ),
                  title: Text(power.name),
                  subtitle: power.extra != null ? Text(power.extra!) : null,
                  trailing: power.rating != null 
                      ? Text('Rating ${power.rating}')
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGearCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gear & Equipment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: character.gear.length,
              itemBuilder: (context, index) {
                final item = character.gear[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.equipped ? Colors.green : Colors.grey,
                    child: Icon(
                      item.equipped ? Icons.check : Icons.inventory,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(item.name.toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${item.category}'),
                      Text('Rating: ${item.rating}'),
                      Text('Quantity: ${item.qty}'),
                    ],
                  ),
                  trailing: item.equipped 
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getSpellCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'combat':
        return Colors.red;
      case 'detection':
        return Colors.blue;
      case 'health':
        return Colors.green;
      case 'illusion':
        return Colors.purple;
      case 'manipulation':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
