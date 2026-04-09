import 'package:flutter/material.dart';
import 'package:chummer5x/models/shadowrun_character.dart';
import 'package:chummer5x/models/spirit.dart';
import 'package:chummer5x/models/sprite.dart';
import 'package:chummer5x/widgets/critter_list_widget.dart';
import 'package:chummer5x/widgets/add_critter_modal.dart';

class CritterScreen extends StatefulWidget {
  final ShadowrunCharacter character;
  final bool isSpirit;
  final Function(ShadowrunCharacter) onCharacterUpdated;

  const CritterScreen({
    super.key,
    required this.character,
    required this.isSpirit,
    required this.onCharacterUpdated,
  });

  @override
  State<CritterScreen> createState() => _CritterScreenState();
}

class _CritterScreenState extends State<CritterScreen> {
  late ShadowrunCharacter _currentCharacter;

  @override
  void initState() {
    super.initState();
    _currentCharacter = widget.character;
  }

  void _updateCharacter(ShadowrunCharacter newCharacter) {
    setState(() {
      _currentCharacter = newCharacter;
    });
    widget.onCharacterUpdated(newCharacter);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: widget.isSpirit ? _buildSpiritsView(context) : _buildSpritesView(context),
    );
  }

  Widget _buildSpiritsView(BuildContext context) {
    final spirits = _currentCharacter.spirits;

    return CritterListWidget<Spirit>(
      critters: spirits,
      icon: Icons.pets,
      title: 'Spirits',
      singularLabel: 'spirit',
      emptyMessage: 'No spirits summoned',
      typeLabel: 'Spirit',
      typeColor: Colors.purple,
      character: _currentCharacter,
      onCharacterUpdated: _updateCharacter,
      primaryFieldsBuilder: (spirit) => [
        MapEntry('BOD', spirit.bod.toString()),
        MapEntry('AGI', spirit.agi.toString()),
        MapEntry('REA', spirit.rea.toString()),
        MapEntry('STR', spirit.str.toString()),
        MapEntry('WIL', spirit.wil.toString()),
        MapEntry('LOG', spirit.log.toString()),
        MapEntry('INT', spirit.intu.toString()),
        MapEntry('CHA', spirit.cha.toString()),
        MapEntry('EDG', spirit.edg.toString()),
      ],
      secondaryFieldsBuilder: (spirit) => [
        MapEntry('Initiative', spirit.initiative),
        MapEntry('Astral Initiative', spirit.astralInitiative),
        MapEntry('Initiative Type', spirit.initiativeType),
      ],
      serviceNameSingle: 'service',
    );
  }

  Widget _buildSpritesView(BuildContext context) {
    final sprites = _currentCharacter.sprites;

    return CritterListWidget<Sprite>(
      critters: sprites,
      icon: Icons.computer,
      title: 'Sprites',
      singularLabel: 'sprite',
      emptyMessage: 'No sprites compiled',
      typeLabel: 'Sprite',
      typeColor: Colors.cyan,
      character: _currentCharacter,
      onCharacterUpdated: _updateCharacter,
      primaryFieldsBuilder: (sprite) => [
        MapEntry('ATK', sprite.atk.toString()),
        MapEntry('SLZ', sprite.slz.toString()),
        MapEntry('DP', sprite.dp.toString()),
        MapEntry('FWL', sprite.fwl.toString()),
      ],
      secondaryFieldsBuilder: (sprite) => [
        MapEntry('Matrix Initiative', sprite.initiative),
      ],
      serviceNameSingle: 'task',
    );
  }
}