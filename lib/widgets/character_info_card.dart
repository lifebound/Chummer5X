import 'package:flutter/material.dart';
import '../models/shadowrun_character.dart';

class CharacterInfoCard extends StatelessWidget {
  final ShadowrunCharacter character;

  const CharacterInfoCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    character.name.isNotEmpty ? character.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (character.alias.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          '"${character.alias}"',
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        character.metatype,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGrid() {
    final infoItems = [
      if (character.ethnicity.isNotEmpty) ('Ethnicity', character.ethnicity),
      if (character.age.isNotEmpty) ('Age', character.age),
      if (character.sex.isNotEmpty) ('Sex', character.sex),
      if (character.height.isNotEmpty) ('Height', character.height),
      if (character.weight.isNotEmpty) ('Weight', character.weight),
      ('Karma', character.karma),
      ('Total Karma', character.totalKarma),
      if (character.streetCred.isNotEmpty) ('Street Cred', character.streetCred),
      if (character.notoriety.isNotEmpty) ('Notoriety', character.notoriety),
      if (character.publicAwareness.isNotEmpty) ('Public Awareness', character.publicAwareness),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: infoItems.length,
      itemBuilder: (context, index) {
        final (label, value) = infoItems[index];
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
