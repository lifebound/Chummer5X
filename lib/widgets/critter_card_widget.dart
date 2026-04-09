import 'package:flutter/material.dart';
import 'package:chummer5x/models/critter_base.dart';
import 'package:chummer5x/models/shadowrun_character.dart';
import 'package:chummer5x/models/spirit.dart';
import 'package:chummer5x/models/sprite.dart';
import 'package:chummer5x/utils/skill_attribute_map.dart';

class CritterCardWidget extends StatefulWidget {
  final Critter critter;
  final List<MapEntry<String, String>> primaryFields;
  final List<MapEntry<String, String>> secondaryFields;
  final String typeLabel;
  final Color typeColor;
  final String serviceNameSingle;
  final ShadowrunCharacter character;
  final Function(ShadowrunCharacter) onCharacterUpdated;

  const CritterCardWidget({
    super.key,
    required this.critter,
    required this.primaryFields,
    required this.secondaryFields,
    required this.typeLabel,
    required this.typeColor,
    required this.serviceNameSingle,
    required this.character,
    required this.onCharacterUpdated,
  });

  @override
  State<CritterCardWidget> createState() => _CritterCardWidgetState();
}

class _CritterCardWidgetState extends State<CritterCardWidget> {
  void _updateCharacterCritterList() {
    ShadowrunCharacter updatedCharacter;
    if (widget.critter.type == CritterType.spirit) {
      updatedCharacter = widget.character.copyWith(
        spirits: List.from(widget.character.spirits),
      );
    } else {
      updatedCharacter = widget.character.copyWith(
        sprites: List.from(widget.character.sprites),
      );
    }
    widget.onCharacterUpdated(updatedCharacter);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.critter.crittername?.isNotEmpty == true
                          ? widget.critter.crittername!
                          : widget.critter.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (widget.critter.crittername?.isNotEmpty == true)
                      Text(
                        '  (${widget.critter.name})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              color: widget.typeColor.withValues(alpha: 0.3),
                            ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.typeColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${widget.typeLabel} • Force ${widget.critter.force}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.typeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Primary stats row
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: widget.primaryFields
                .where((entry) => entry.value.isNotEmpty)
                .map((entry) =>
                    _buildCritterStatChip(context, entry.key, entry.value))
                .toList(),
          ),

          // Skills section
          if (widget.critter.baseSkills.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Skills',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _buildCritterSkillChips(context, widget.critter),
            ),
          ],

          // Powers section
          if (widget.critter.powers.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Powers',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: widget.critter.powers
                  .map((power) => _buildPowerChip(context, power))
                  .toList(),
            ),
          ],

          // Secondary stats row
          if (widget.secondaryFields.any((entry) => entry.value.isNotEmpty)) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: widget.secondaryFields
                  .where((entry) => entry.value.isNotEmpty)
                  .map((entry) =>
                      _buildCritterDetailChip(context, entry.key, entry.value))
                  .toList(),
            ),
          ],

          // Special abilities
          if (widget.critter.special?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.critter.special!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          _buildServicesSection(),

          // Switches section
          const SizedBox(height: 12),
          _buildSwitchesSection(),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return widget.critter.services == 0
        ? StatefulBuilder(
            builder: (context, setLocalState) {
              final controller = TextEditingController();

              void setServices() {
                final parsed = int.tryParse(controller.text);
                if (parsed != null && parsed > 0) {
                  setState(() {
                    widget.critter.services = parsed;
                  });
                  _updateCharacterCritterList();
                }
              }

              return Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Services',
                        isDense: true,
                      ),
                      onSubmitted: (val) => setServices(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: setServices,
                    child: const Text('Set'),
                  ),
                ],
              );
            },
          )
        : Row(
            children: [
              Text('Services: ${widget.critter.services}'),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (widget.critter.services > 0) {
                      widget.critter.services = widget.critter.services - 1;
                    }
                  });
                  _updateCharacterCritterList();
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    widget.critter.services = widget.critter.services + 1;
                  });
                  _updateCharacterCritterList();
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Reset',
                onPressed: () {
                  setState(() {
                    widget.critter.services = 0;
                  });
                  _updateCharacterCritterList();
                },
              ),
            ],
          );
  }

  Widget _buildSwitchesSection() {
    return Column(
      children: [
        // Bound/Registered switch
        Row(
          children: [
            Text(
              widget.critter.type == CritterType.spirit ? 'Bound' : 'Registered',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: widget.critter.bound,
              onChanged: (value) {
                setState(() {
                  widget.critter.bound = value;
                });
                _updateCharacterCritterList();
              },
            ),
          ],
        ),

        // Fettered/Pet switch (conditional)
        if ((widget.critter.type == CritterType.spirit &&
                widget.character.canFetterSpirit) ||
            (widget.critter.type == CritterType.sprite &&
                widget.character.canFetterSprite)) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                widget.critter.type == CritterType.spirit
                    ? 'Fettered'
                    : 'Sprite Pet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: widget.critter.fettered,
                onChanged: (value) {
                  setState(() {
                    widget.critter.fettered = value;
                  });
                  _updateCharacterCritterList();
                },
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCritterStatChip(
      BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCritterDetailChip(
      BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerChip(BuildContext context, String power) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .secondaryContainer
            .withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        power,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  /// Builds skill chips for critters showing skill name and dice pool
  List<Widget> _buildCritterSkillChips(BuildContext context, Critter critter) {
    final sortedSkills = critter.baseSkills.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sortedSkills
        .map((skillEntry) => _buildCritterSkillChip(
            context, critter, skillEntry.key, skillEntry.value))
        .toList();
  }

  /// Builds a single skill chip for a critter
  Widget _buildCritterSkillChip(BuildContext context, Critter critter,
      String skillName, int skillRating) {
    final dicePool =
        _calculateCritterSkillDicePool(critter, skillName, skillRating);
    final isDefaulting = _isCritterSkillDefaulting(skillName, skillRating);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDefaulting
            ? Theme.of(context)
                .colorScheme
                .errorContainer
                .withValues(alpha: 0.3)
            : Theme.of(context)
                .colorScheme
                .tertiaryContainer
                .withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDefaulting
              ? Theme.of(context).colorScheme.error.withValues(alpha: 0.5)
              : Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skillName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDefaulting
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: isDefaulting
                  ? Theme.of(context).colorScheme.error.withValues(alpha: 0.2)
                  : Theme.of(context)
                      .colorScheme
                      .tertiary
                      .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              dicePool.toString(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isDefaulting
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Calculates the dice pool for a critter skill
  int _calculateCritterSkillDicePool(
      Critter critter, String skillName, int skillRating) {
    // Get the linked attribute for this skill
    final linkedAttributeCode = skillAttributeMap[skillName];
    if (linkedAttributeCode == null) {
      // Unknown skill, return just the skill rating
      return skillRating;
    }

    int attributeValue;

    // Get attribute value based on critter type
    if (critter is Spirit) {
      attributeValue = _getSpiritAttributeValue(critter, linkedAttributeCode);
    } else if (critter is Sprite) {
      attributeValue = _getSpriteAttributeValue(critter, linkedAttributeCode);
    } else {
      // Fallback - shouldn't happen with current implementation
      attributeValue = 1;
    }

    // Handle defaulting
    if (_isCritterSkillDefaulting(skillName, skillRating)) {
      return attributeValue - 1; // Defaulting gives attribute - 1
    }

    return skillRating + attributeValue;
  }

  /// Gets the appropriate attribute value for a Spirit
  int _getSpiritAttributeValue(Spirit spirit, String attributeCode) {
    switch (attributeCode) {
      case 'BOD':
        return spirit.bod;
      case 'AGI':
        return spirit.agi;
      case 'REA':
        return spirit.rea;
      case 'STR':
        return spirit.str;
      case 'WIL':
        return spirit.wil;
      case 'LOG':
        return spirit.log;
      case 'INT':
        return spirit.intu;
      case 'CHA':
        return spirit.cha;
      case 'EDG':
        return spirit.edg;
      default:
        return 1;
    }
  }

  /// Gets the appropriate attribute value for a Sprite with attribute conversion
  int _getSpriteAttributeValue(Sprite sprite, String attributeCode) {
    // Sprites use converted attributes: CHA→ATK, INT→SLZ, LOG→DP, WIL→FWL
    switch (attributeCode) {
      case 'CHA':
        return sprite.atk; // CHA→ATK
      case 'INT':
        return sprite.slz; // INT→SLZ
      case 'LOG':
        return sprite.dp; // LOG→DP
      case 'WIL':
        return sprite.fwl; // WIL→FWL
      // Other attributes don't exist for sprites, use the closest equivalent
      case 'BOD':
      case 'AGI':
      case 'REA':
      case 'STR':
        return sprite.atk; // Use ATK as fallback for physical attributes
      case 'EDG':
        return sprite.force ~/ 2; // Similar to spirit edge calculation
      default:
        return 1;
    }
  }

  /// Checks if a critter skill is defaulting (skill rating is 0)
  bool _isCritterSkillDefaulting(String skillName, int skillRating) {
    // Check if skill doesn't allow defaulting
    if (noDefaultingSkills.contains(skillName)) {
      return false; // Can't default, so if rating is 0, it's just 0
    }

    return skillRating == 0;
  }
}