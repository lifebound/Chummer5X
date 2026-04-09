import 'package:flutter/material.dart';
import 'package:chummer5x/models/critter_base.dart';
import 'package:chummer5x/models/shadowrun_character.dart';
import 'package:chummer5x/widgets/critter_card_widget.dart';

class CritterListWidget<T extends Critter> extends StatelessWidget {
  final List<T> critters;
  final IconData icon;
  final String title;
  final String singularLabel;
  final String emptyMessage;
  final String typeLabel;
  final Color typeColor;
  final ShadowrunCharacter character;
  final Function(ShadowrunCharacter) onCharacterUpdated;
  final List<MapEntry<String, String>> Function(T) primaryFieldsBuilder;
  final List<MapEntry<String, String>> Function(T) secondaryFieldsBuilder;
  final String serviceNameSingle;

  const CritterListWidget({
    super.key,
    required this.critters,
    required this.icon,
    required this.title,
    required this.singularLabel,
    required this.emptyMessage,
    required this.typeLabel,
    required this.typeColor,
    required this.character,
    required this.onCharacterUpdated,
    required this.primaryFieldsBuilder,
    required this.secondaryFieldsBuilder,
    required this.serviceNameSingle,
  });

  @override
  Widget build(BuildContext context) {
    final itemCountText =
        '${critters.length} $singularLabel${critters.length == 1 ? '' : 's'}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const Spacer(),
                Text(
                  itemCountText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (critters.isEmpty)
              Text(
                emptyMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
              )
            else
              ...critters.map((critter) => CritterCardWidget(
                    critter: critter,
                    primaryFields: primaryFieldsBuilder(critter),
                    secondaryFields: secondaryFieldsBuilder(critter),
                    typeLabel: typeLabel,
                    typeColor: typeColor,
                    serviceNameSingle: serviceNameSingle,
                    character: character,
                    onCharacterUpdated: onCharacterUpdated,
                  )),
          ],
        ),
      ),
    );
  }
}