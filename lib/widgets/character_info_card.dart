import 'package:flutter/material.dart';
import '../models/shadowrun_character.dart';
import '../utils/responsive_layout.dart';

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
                //_buildCharacterAvatar(context),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character.name ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (character.alias?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          '"${character.alias}"',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        character.metatype ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
            _buildInfoGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    final infoItems = [
      // if (character.ethnicity?.isNotEmpty == true) ('Ethnicity', character.ethnicity!),
      // if (character.age?.isNotEmpty == true) ('Age', character.age!),
      // if (character.sex?.isNotEmpty == true) ('Sex', character.sex!),
      // if (character.height?.isNotEmpty == true) ('Height', character.height!),
      // if (character.weight?.isNotEmpty == true) ('Weight', character.weight!),
      if (character.karma?.isNotEmpty == true) ('Karma', character.karma!),
      if (character.totalKarma?.isNotEmpty == true) ('Total Karma', character.totalKarma!),
      if (character.streetCred?.isNotEmpty == true) ('Street Cred', character.streetCred!),
      if (character.notoriety?.isNotEmpty == true) ('Notoriety', character.notoriety!),
      if (character.publicAwareness?.isNotEmpty == true) ('Public Awareness', character.publicAwareness!),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveLayout.responsive(
          context,
          phone: 2,     // 2 columns on phone (current)
          tablet: 3,    // 3 columns on tablet
          desktop: 4,   // 4 columns on desktop
          fourK: 5,     // 5 columns on 4K
        ),
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
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget _buildCharacterAvatar(BuildContext context) {
  //   // If character has a mugshot, display it as a circular avatar
  //   if (character.mugshot != null) {
  //     return CircleAvatar(
  //       radius: 30,
  //       backgroundImage: MemoryImage(character.mugshot!.imageData),
  //       backgroundColor: Theme.of(context).colorScheme.primary,
  //       onBackgroundImageError: (exception, stackTrace) {
  //         // If image fails to load, fall back to letter avatar
  //         debugPrint('Failed to load mugshot image: $exception');
  //       },
  //       child: null, // No child when showing image
  //     );
  //   }

  //   // Fallback to letter avatar when no mugshot is available
  //   return CircleAvatar(
  //     radius: 30,
  //     backgroundColor: Theme.of(context).colorScheme.primary,
  //     child: Text(
  //       (character.name?.isNotEmpty == true) ? character.name![0].toUpperCase() : '?',
  //       style: TextStyle(
  //         fontSize: 24,
  //         fontWeight: FontWeight.bold,
  //         color: Theme.of(context).colorScheme.onPrimary,
  //       ),
  //     ),
  //   );
  // }
}
