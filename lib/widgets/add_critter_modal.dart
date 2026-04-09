import 'dart:ffi';
import 'dart:math' as math;

import 'package:chummer5x/models/skills.dart';
import 'package:flutter/material.dart';
import 'package:chummer5x/models/critter_base.dart';
import 'package:chummer5x/models/shadowrun_character.dart';
import 'package:chummer5x/models/critter_factory.dart';
import 'package:chummer5x/models/spirit.dart';
import 'package:chummer5x/models/sprite.dart';

class AddCritterModal extends StatefulWidget {
  final ShadowrunCharacter character;
  final bool isSpirit;
  final Function(Critter) onCritterAdded;

  const AddCritterModal({
    required this.character,
    super.key,
    required this.isSpirit,
    required this.onCritterAdded,
  });

  @override
  State<AddCritterModal> createState() => _AddCritterModalState();
}

class _AddCritterModalState extends State<AddCritterModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _critterNameController = TextEditingController();
  final _forceController = TextEditingController();
  
  String _selectedType = 'Guardian'; // Default spirit type
  bool _isBound = false;
  bool _isFettered = false;
  // Dice rolling state
  int _currentRollStep = 0; // -1 = force prompt, 0 = not started, 1 = summoning roll, 2 = resistance roll, 3 = drain roll, 4 = results, 5+ = registration
  final _userHitsController = TextEditingController();
  final _critterHitsController = TextEditingController();
  final _drainHitsController = TextEditingController();
  final _regUserHitsController = TextEditingController();
  final _regCritterHitsController = TextEditingController();
  final _regDrainHitsController = TextEditingController();
  int? _userHits;
  int? _critterHits;
  int? _drainHits;
  int? _netHits;
  int? _services;
  int? _drainDamage;
  // Registration state
  int? _regUserHits;
  int? _regCritterHits;
  int? _regDrainHits;
  int? _regNetHits;
  int? _regDrainDamage;
  bool _isRegistered = false;

  @override
  void initState() {
    super.initState();
    // Set appropriate default type
    if (!widget.isSpirit) {
      _selectedType = 'Courier'; // Default for sprites
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _critterNameController.dispose();
    _forceController.dispose();
    _userHitsController.dispose();
    _critterHitsController.dispose();
    _drainHitsController.dispose();
    _regUserHitsController.dispose();
    _regCritterHitsController.dispose();
    _regDrainHitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenWidth * 0.9,
        height: screenHeight * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBasicInfoSection(),
                      const SizedBox(height: 24),
                      _buildTypeSelection(),
                      const SizedBox(height: 24),
                      _buildForceSection(),
                      const SizedBox(height: 24),
                      _buildOptionsSection(),
                      const SizedBox(height: 32),
                      _buildRollSection(),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.isSpirit ? Icons.pets : Icons.computer,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Add New ${widget.isSpirit ? "Spirit" : "Sprite"}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Type Name',
            hintText: 'e.g., Guardian, Attack, Fire Sprite',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a type name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _critterNameController,
          decoration: const InputDecoration(
            labelText: 'Custom Name (Optional)',
            hintText: 'e.g., Sparky, Rex, Data',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelection() {
    if (widget.isSpirit) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spirit Type',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Guardian', child: Text('Guardian')),
              DropdownMenuItem(value: 'Guidance', child: Text('Guidance')),
              DropdownMenuItem(value: 'Task', child: Text('Task')),
              DropdownMenuItem(value: 'Combat', child: Text('Combat')),
              DropdownMenuItem(value: 'Detection', child: Text('Detection')),
              DropdownMenuItem(value: 'Health', child: Text('Health')),
              DropdownMenuItem(value: 'Illusion', child: Text('Illusion')),
              DropdownMenuItem(value: 'Manipulation', child: Text('Manipulation')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sprite Type',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Courier', child: Text('Courier')),
              DropdownMenuItem(value: 'Crack', child: Text('Crack')),
              DropdownMenuItem(value: 'Data', child: Text('Data')),
              DropdownMenuItem(value: 'Fault', child: Text('Fault')),
              DropdownMenuItem(value: 'Machine', child: Text('Machine')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
          ),
        ],
      );
    }
  }

  Widget _buildForceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Force/Level',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              width: 120,
              child: TextFormField(
                controller: _forceController,
                decoration: const InputDecoration(
                  labelText: 'Force',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  final force = int.tryParse(value);
                  if (force == null || force < 1 || force > 12) {
                    return 'Force must be 1-12';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Enter the force or level for this ${widget.isSpirit ? "spirit" : "sprite"} (1-12)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Options',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: Text(widget.isSpirit ? 'Bound' : 'Registered'),
          subtitle: Text(
            widget.isSpirit 
                ? 'This spirit is bound to you'
                : 'This sprite is registered to you',
          ),
          value: _isBound,
          onChanged: (value) {
            setState(() {
              _isBound = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          title: Text(widget.isSpirit ? 'Fettered' : 'Sprite Pet'),
          subtitle: Text(
            widget.isSpirit
                ? 'This spirit is fettered'
                : 'This sprite is a sprite pet',
          ),
          value: _isFettered,
          onChanged: (value) {
            setState(() {
              _isFettered = value ?? false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRollSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
              Icon(
                Icons.casino,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.isSpirit ? 'Summoning' : 'Compiling'} Rolls',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRollWizardContent(),
        ],
      ),
    );
  }

  Widget _buildRollWizardContent() {

    final force = int.tryParse(_forceController.text);
    //select the total value of character skill relevant to the roll
    final relevantSkill = widget.character.skills.firstWhere(
      (skill) => skill.name == (widget.isSpirit ? 'Summoning' : 'Compiling')
    );
    //select the relevant attribute value
    final relevantAttribute = widget.character.attributes.firstWhere(
      (attr) => attr.name == (widget.isSpirit ? 'MAG' : 'RES')
    );

    final int dicePool = int.parse(relevantSkill.base!) + (relevantSkill.isPrioritySkill ? 2 : 0) + relevantAttribute.totalValue.toInt();
    // If force/level not set, prompt for it first
    if (force == null || force <= 0) {
      return _buildForcePromptStep();
    }
    
    switch (_currentRollStep) {
      case 0:
        return _buildRollInstructions(force, dicePool);
      case 1:
        return _buildSummoningRollStep(force, dicePool);
      case 2:
        return _buildResistanceRollStep(force);
      case 3:
        return _buildDrainRollStep(force);
      case 4:
        return _buildResultsStep();
      case 5:
        return _buildRegistrationRollStep(force, dicePool);
      case 6:
        return _buildRegistrationResistanceStep(force);
      case 7:
        return _buildRegistrationDrainStep(force);
      case 8:
        return _buildRegistrationResultsStep();
      default:
        return _buildRollInstructions(force, dicePool);
    }
  }

  Widget _buildRollInstructions(int force, int dicePool) {
    String temp = widget.character.name ?? 'Unknown';
    
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.isSpirit ? 'Summoning' : 'Compiling'} Process:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildStepItem('1.', 'Roll ${dicePool} + modifiers'),
        _buildStepItem('2.', '${widget.isSpirit ? 'Spirit' : 'Sprite'} resists with Force/Level $force'),
        _buildStepItem('3.', 'Resist ${widget.isSpirit ? 'Drain' : 'Fade'} (2 DV per critter hit, min 2)'),
        _buildStepItem('4.', 'Calculate services/tasks from net hits'),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _currentRollStep = 1;
                _userHits = null;
                _critterHits = null;  
                _drainHits = null;
                _netHits = null;
                _services = null;
                _drainDamage = null;
                // Clear input controllers
                _userHitsController.clear();
                _critterHitsController.clear();
                _drainHitsController.clear();
              });
            },
            icon: const Icon(Icons.play_arrow),
            label: Text('Start ${widget.isSpirit ? 'Summoning' : 'Compiling'}'),
          ),
        ),
      ],
    );
  }

  Widget _buildForcePromptStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set ${widget.isSpirit ? 'Force' : 'Level'}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'You must set the ${widget.isSpirit ? 'Force' : 'Level'} before rolling.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _forceController,
          decoration: InputDecoration(
            labelText: widget.isSpirit ? 'Force' : 'Level',
            border: const OutlineInputBorder(),
            helperText: 'Maximum: ${widget.isSpirit ? 'Magic' : 'Resonance'} × 2',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a ${widget.isSpirit ? 'force' : 'level'}';
            }
            final number = int.tryParse(value);
            if (number == null || number < 1 || number > 12) {
              return 'Please enter a number between 1 and 12';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final force = int.tryParse(_forceController.text);
              if (force != null && force > 0 && force <= 12) {
                setState(() {
                  // Force is set, continue to instructions
                });
              }
            },
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(String number, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummoningRollStep(int force, int dicePool) {
    // TODO: Get actual dice pool from character - for now show placeholder
    final dicePoolText = '(Character ${widget.isSpirit ? 'Summoning + Magic' : 'Compiling + Resonance'} value)';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 1: Your ${widget.isSpirit ? 'Summoning' : 'Compiling'} Roll',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Roll $dicePool dice',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Add any focus bonuses, mentor spirit bonuses, etc.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _userHitsController,
                decoration: const InputDecoration(
                  labelText: 'Your Hits',
                  border: OutlineInputBorder(),
                  helperText: 'Count 5+ on d6 as hits',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _userHits = int.tryParse(value);
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _userHits != null && _userHits! >= 0 ? () {
                _critterHitsController.clear(); // Clear next step's input
                setState(() {
                  _currentRollStep = 2;
                });
              } : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResistanceRollStep(int force) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 2: ${widget.isSpirit ? 'Spirit' : 'Sprite'} Resistance',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.isSpirit ? 'Spirit' : 'Sprite'} resists with $force dice',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Force/Level = $force | Roll $force dice and count hits (5+ on d6)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_userHits != null) 
          Text(
            'Your hits: $_userHits',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _critterHitsController,
                decoration: InputDecoration(
                  labelText: '${widget.isSpirit ? 'Spirit' : 'Sprite'} Hits',
                  border: const OutlineInputBorder(),
                  helperText: 'Count 5+ on d6 as hits',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _critterHits = int.tryParse(value);
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _critterHits != null && _critterHits! >= 0 ? () {
                _calculateNetHits();
                _drainHitsController.clear(); // Clear next step's input
                setState(() {
                  _currentRollStep = 3;
                });
              } : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDrainRollStep(int force) {
    final drainValue = (_critterHits! * 2).clamp(2, 99);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 3: ${widget.isSpirit ? 'Drain' : 'Fade'} Resistance',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resist $drainValue ${widget.isSpirit ? 'Drain' : 'Fade'} damage',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Roll ${widget.isSpirit ? 'Willpower + Logic' : 'Willpower + Resonance'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Net hits: $_netHits',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _netHits! > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Drain: $_critterHits hits = $drainValue DV',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _drainHitsController,
                decoration: const InputDecoration(
                  labelText: 'Drain Resistance Hits',
                  border: OutlineInputBorder(),
                  helperText: 'Count 5+ on d6 as hits',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _drainHits = int.tryParse(value);
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _drainHits != null && _drainHits! >= 0 ? () {
                _calculateDrain(drainValue);
                setState(() {
                  _currentRollStep = 4;
                });
              } : null,
              child: const Text('Finish'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultsStep() {
    final isSuccess = _services! > 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.cancel,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              isSuccess ? '${widget.isSpirit ? 'Summoning' : 'Compiling'} Successful!' : '${widget.isSpirit ? 'Summoning' : 'Compiling'} Failed',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSuccess ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSuccess 
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSuccess ? Colors.green : Colors.red,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildResultRow('Your Hits', _userHits.toString()),
              _buildResultRow('${widget.isSpirit ? 'Spirit' : 'Sprite'} Hits', _critterHits.toString()),
              _buildResultRow('Net Hits', _netHits.toString()),
              const Divider(),
              _buildResultRow(
                'Services/Tasks', 
                _services.toString(), 
                isHighlighted: true,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              _buildResultRow(
                '${widget.isSpirit ? 'Drain' : 'Fade'} Damage', 
                _drainDamage.toString(),
                color: _drainDamage! > 0 ? Colors.orange : Colors.grey,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (isSuccess) _buildSuccessOptions() else _buildFailureOptions(),
      ],
    );
  }

  Widget _buildSuccessOptions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentRollStep = 0;
                    _userHits = null;
                    _critterHits = null;
                    _drainHits = null;
                    _netHits = null;
                    _services = null;
                    _drainDamage = null;
                    // Clear all input controllers
                    _userHitsController.clear();
                    _critterHitsController.clear();
                    _drainHitsController.clear();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Roll Again'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _createCritter(false); // Create without registration
                },
                icon: const Icon(Icons.add),
                label: Text('Create ${widget.isSpirit ? 'Spirit' : 'Sprite'}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        if (!widget.isSpirit) ...[ // Only show registration option for sprites
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentRollStep = 5; // Move to registration step
                });
              },
              icon: const Icon(Icons.security),
              label: const Text('Register Sprite'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFailureOptions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _currentRollStep = 0;
                _userHits = null;
                _critterHits = null;
                _drainHits = null;
                _netHits = null;
                _services = null;
                _drainDamage = null;
                // Clear all input controllers
                _userHitsController.clear();
                _critterHitsController.clear();
                _drainHitsController.clear();
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, String value, {bool isHighlighted = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? Theme.of(context).colorScheme.primary,
              fontSize: isHighlighted ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  void _calculateNetHits() {
    _netHits = (_userHits ?? 0) - (_critterHits ?? 0);
    _services = _netHits! > 0 ? _netHits : 0;
  }

  void _calculateDrain(int drainValue) {
    _drainDamage = (drainValue - (_drainHits ?? 0)).clamp(0, drainValue);
  }

  Widget _buildRegistrationRollStep(int force, int dicePool) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Registration Roll',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Roll $dicePool dice (Registering + Resonance)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Add any program bonuses, sustaining penalties, etc.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _regUserHitsController,
                decoration: const InputDecoration(
                  labelText: 'Your Hits',
                  border: OutlineInputBorder(),
                  helperText: 'Count 5+ on d6 as hits',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _regUserHits = int.tryParse(value);
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _regUserHits != null && _regUserHits! >= 0 ? () {
                _regCritterHitsController.clear();
                setState(() {
                  _currentRollStep = 6;
                });
              } : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegistrationResistanceStep(int force) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sprite Resistance',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sprite resists with Level + Firewall ($force dice)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'If you get net hits, the sprite gains +1 service',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _regCritterHitsController,
                decoration: const InputDecoration(
                  labelText: 'Sprite Hits',
                  border: OutlineInputBorder(),
                  helperText: 'Count 5+ on d6 as hits',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _regCritterHits = int.tryParse(value);
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _regCritterHits != null && _regCritterHits! >= 0 ? () {
                _calculateRegistrationResult();
                _regDrainHitsController.clear();
                setState(() {
                  _currentRollStep = 7;
                });
              } : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegistrationDrainStep(int force) {
    final drainValue = math.max(2, force ~/ 2);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Registration Fade Resistance',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resist Fade: $drainValue DV',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Roll Resonance + Willpower, reduce DV by hits rolled',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _regDrainHitsController,
                decoration: const InputDecoration(
                  labelText: 'Resistance Hits',
                  border: OutlineInputBorder(),
                  helperText: 'Count 5+ on d6 as hits',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _regDrainHits = int.tryParse(value);
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _regDrainHits != null && _regDrainHits! >= 0 ? () {
                _calculateRegistrationDrain(drainValue);
                setState(() {
                  _currentRollStep = 8;
                });
              } : null,
              child: const Text('Finish'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegistrationResultsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              _isRegistered ? Icons.security : Icons.info,
              color: _isRegistered ? Colors.green : Colors.blue,
            ),
            const SizedBox(width: 8),
            Text(
              _isRegistered ? 'Registration Successful!' : 'Registration Failed',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _isRegistered ? Colors.green : Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isRegistered 
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isRegistered ? Colors.green : Colors.blue,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildResultRow('Your Hits', _regUserHits.toString()),
              _buildResultRow('Sprite Hits', _regCritterHits.toString()),
              _buildResultRow('Net Hits', _regNetHits.toString()),
              const Divider(),
              _buildResultRow(
                'Final Services', 
                '${_services! + (_isRegistered ? 1 : 0)}', 
                isHighlighted: true,
                color: Colors.green,
              ),
              _buildResultRow(
                'Registration Fade', 
                _regDrainDamage.toString(),
                color: _regDrainDamage! > 0 ? Colors.orange : Colors.grey,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentRollStep = 5;
                    _regUserHits = null;
                    _regCritterHits = null;
                    _regDrainHits = null;
                    _regNetHits = null;
                    _regDrainDamage = null;
                    _isRegistered = false;
                    _regUserHitsController.clear();
                    _regCritterHitsController.clear();
                    _regDrainHitsController.clear();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Update services with registration bonus
                  final finalServices = _services! + (_isRegistered ? 1 : 0);
                  setState(() {
                    _services = finalServices;
                  });
                  _createCritter(true);
                },
                icon: const Icon(Icons.add),
                label: const Text('Create Sprite'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _calculateRegistrationResult() {
    _regNetHits = (_regUserHits ?? 0) - (_regCritterHits ?? 0);
    _isRegistered = _regNetHits! > 0;
  }

  void _calculateRegistrationDrain(int drainValue) {
    _regDrainDamage = (drainValue - (_regDrainHits ?? 0)).clamp(0, drainValue);
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _createCritter();
                }
              },
              child: Text('Add ${widget.isSpirit ? "Spirit" : "Sprite"}'),
            ),
          ),
        ],
      ),
    );
  }

  void _createCritter([bool withRegistration = false]) {
    final force = int.tryParse(_forceController.text) ?? 1;
    final services = _services ?? 0;
    final isRegistered = withRegistration && _isRegistered;
    final finalServices = services + (isRegistered ? 1 : 0);
    
    if (widget.isSpirit) {
      // Create spirit
      final spirit = CritterFactory.generateSpirit(
        _selectedType,
        force,
        finalServices,
        false, // bound - could be extended later
        false, // fettered - could be extended later
        nameOverride: _critterNameController.text.isNotEmpty ? _critterNameController.text : null,
      );
      
      if (spirit != null) {
        widget.onCritterAdded(spirit);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Spirit summoned with $finalServices services!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      // Create sprite
      final sprite = CritterFactory.generateSprite(
        _selectedType,
        force,
        finalServices,
        isRegistered, // registered sprites are "bound"
        false, // fettered - could be extended later
        nameOverride: _critterNameController.text.isNotEmpty ? _critterNameController.text : null,
      );
      
      if (sprite != null) {
        widget.onCritterAdded(sprite);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isRegistered 
                  ? 'Sprite compiled and registered with $finalServices services!'
                  : 'Sprite compiled with $finalServices services!'
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}