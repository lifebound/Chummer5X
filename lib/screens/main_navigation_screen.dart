import 'package:flutter/material.dart';
import '../models/shadowrun_character.dart';
import '../services/enhanced_chumer_xml_service.dart';
import '../utils/responsive_layout.dart';
import '../widgets/character_info_card.dart';
import '../widgets/attributes_card.dart';
import '../widgets/skills_card.dart';
import 'package:file_picker/file_picker.dart';

enum NavigationSection {
  overview,
  attributes,
  skills,
  spells,
  spirits,
  adeptPowers,
  complexForms,
  sprites,
  gear,
  combat,
  contacts,
  notes,
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  List<ShadowrunCharacter> _characters = [];
  ShadowrunCharacter? _currentCharacter;
  NavigationSection _currentSection = NavigationSection.overview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentCharacter?.name ?? 'Chummer5X'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: _buildNavigationDrawer(context),
      body: _currentCharacter != null
          ? _buildCharacterContent(context)
          : _buildEmptyState(context),
    );
  }

  Widget _buildCharacterContent(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveLayout.getContentMaxWidth(context),
        ),
        child: SingleChildScrollView(
          padding: ResponsiveLayout.getPagePadding(context),
          child: _buildCurrentView(context),
        ),
      ),
    );
  }

  Widget _buildNavigationDrawer(BuildContext context) {
    debugPrint("Building navigation drawer");
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_currentCharacter != null) ...[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: Text(
                      (_currentCharacter!.name?.isNotEmpty == true)
                          ? _currentCharacter!.name![0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentCharacter!.name ?? 'Unknown',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_currentCharacter!.alias?.isNotEmpty == true)
                    Text(
                      '"${_currentCharacter!.alias}"',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.8),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ] else ...[
                  Icon(
                    Icons.account_circle,
                    size: 60,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chummer5X',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Shadowrun Character Viewer',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Character Management Section
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Load Character'),
            onTap: () {
              Navigator.of(context).pop();
              _loadCharacterFile();
            },
          ),

          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Create Sample Character'),
            onTap: () {
              Navigator.of(context).pop();
              _createSampleCharacter();
            },
          ),

          // Character Sections (only show if character is loaded)
          if (_currentCharacter != null) ...[
            const Divider(),
            _buildNavigationTile(
              context,
              NavigationSection.overview,
              Icons.dashboard,
              'Overview',
            ),
            _buildNavigationTile(
              context,
              NavigationSection.attributes,
              Icons.fitness_center,
              'Attributes',
            ),
            _buildNavigationTile(
              context,
              NavigationSection.skills,
              Icons.school,
              'Skills',
            ),

            // Dynamic navigation tiles based on character type
            if (_currentCharacter!.shouldShowSpellsTab)
              _buildNavigationTile(
                context,
                NavigationSection.spells,
                Icons.auto_fix_high,
                'Spells',
              ),
            if (_currentCharacter!.shouldShowSpiritsTab)
              _buildNavigationTile(
                context,
                NavigationSection.spirits,
                Icons.pets,
                'Spirits',
              ),
            if (_currentCharacter!.shouldShowAdeptPowersTab)
              _buildNavigationTile(
                context,
                NavigationSection.adeptPowers,
                Icons.flash_on,
                'Adept Powers',
              ),
            if (_currentCharacter!.shouldShowComplexFormsTab)
              _buildNavigationTile(
                context,
                NavigationSection.complexForms,
                Icons.memory,
                'Complex Forms',
              ),
            if (_currentCharacter!.shouldShowSpritesTab)
              _buildNavigationTile(
                context,
                NavigationSection.sprites,
                Icons.computer,
                'Sprites',
              ),

            _buildNavigationTile(
              context,
              NavigationSection.gear,
              Icons.inventory,
              'Gear',
            ),
            _buildNavigationTile(
              context,
              NavigationSection.combat,
              Icons.gps_fixed,
              'Combat',
            ),
            _buildNavigationTile(
              context,
              NavigationSection.contacts,
              Icons.people,
              'Contacts',
            ),
            _buildNavigationTile(
              context,
              NavigationSection.notes,
              Icons.note,
              'Notes',
            ),
          ],

          // Character List (if multiple characters loaded)
          if (_characters.length > 1) ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Characters',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            // Character list
            ..._characters.map((character) => ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      (character.name?.isNotEmpty == true)
                          ? character.name![0].toUpperCase()
                          : '?',
                    ),
                  ),
                  title: Text(character.name ?? 'Unknown'),
                  subtitle: character.alias?.isNotEmpty == true
                      ? Text('"${character.alias}"')
                      : null,
                  selected: _currentCharacter == character,
                  onTap: () {
                    setState(() {
                      _currentCharacter = character;
                      _currentSection =
                          NavigationSection.overview; // Reset to overview
                    });
                    Navigator.of(context).pop();
                  },
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveLayout.getContentMaxWidth(context),
        ),
        child: Padding(
          padding: ResponsiveLayout.getPagePadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: 120,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 24),
              Text(
                'No Characters Loaded',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Load a Chummer character file or create a sample character to get started',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _loadCharacterFile,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Load Character File'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: _createSampleCharacter,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Create Sample'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadCharacterFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml', 'chum5'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final xmlContent = String.fromCharCodes(result.files.single.bytes!);
        final character =
            EnhancedChumerXmlService.parseCharacterXml(xmlContent);

        if (character != null) {
          setState(() {
            if (!_characters.contains(character)) {
              _characters.add(character);
            }
            _currentCharacter = character;
            _currentSection = NavigationSection.overview; // Reset to overview
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to parse character file'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _createSampleCharacter() {
    const sampleCharacter = ShadowrunCharacter(
      name: 'Sample Runner',
      alias: 'Chrome',
      metatype: 'Human',
      skills: [
        Skill(
          name: 'Pistols',
          base: '4',
          karma: '2',
          skillGroupName: 'Firearms',
          skillGroupTotal: 0,
          isPrioritySkill: true, // Priority skill gets +2
          specializations: [
            SkillSpecialization(name: 'Semi-Automatics'),
          ],
        ),
        Skill(
          name: 'Infiltration',
          base: '3',
          karma: '1',
          skillGroupName: 'Stealth',
          skillGroupTotal: 0,
        ),
        Skill(
          name: 'Hacking',
          base: '5',
          karma: '1',
          skillGroupName: 'Cracking',
          skillGroupTotal: 0,
          isPrioritySkill: true, // Priority skill gets +2
        ),
        Skill(
          name: 'Perception',
          base: '2',
          karma: '2',
          skillGroupName: '',
          skillGroupTotal: 0,
        ),
        Skill(
          name: 'Palming',
          base: '1',
          karma: '3',
          skillGroupName: 'Stealth',
          skillGroupTotal: 0,
          specializations: [
            SkillSpecialization(name: 'Pickpocket'),
            SkillSpecialization(name: 'Legerdemain'),
          ],
        ),
      ],
      limits: {}, // Empty for now
      attributes: [
        Attribute(
          name: 'Body',
          metatypeCategory: 'Physical',
          totalValue: 4,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 1,
        ),
        Attribute(
          name: 'Agility',
          metatypeCategory: 'Physical',
          totalValue: 5,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 4,
          karma: 1,
        ),
        Attribute(
          name: 'Reaction',
          metatypeCategory: 'Physical',
          totalValue: 4,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 1,
        ),
        Attribute(
          name: 'Strength',
          metatypeCategory: 'Physical',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 2,
          karma: 1,
        ),
        Attribute(
          name: 'Charisma',
          metatypeCategory: 'Mental',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 2,
          karma: 1,
        ),
        Attribute(
          name: 'Intuition',
          metatypeCategory: 'Mental',
          totalValue: 4,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 1,
        ),
        Attribute(
          name: 'Logic',
          metatypeCategory: 'Mental',
          totalValue: 5,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 4,
          karma: 1,
        ),
        Attribute(
          name: 'Willpower',
          metatypeCategory: 'Mental',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 2,
          karma: 1,
        ),
        Attribute(
          name: 'Edge',
          metatypeCategory: 'Special',
          totalValue: 2,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 2,
          karma: 0,
        ),
      ],
      conditionMonitor: ConditionMonitor(
        physicalCM: 10,
        physicalCMFilled: 2,
        physicalCMOverflow: 4,
        stunCM: 10,
        stunCMFilled: 1,
      ),
      magEnabled: false, // Sample character doesn't have magic enabled
      resEnabled: false, // Sample character doesn't have resonance enabled
      depEnabled: false, // Sample character doesn't have depth enabled
    );

    setState(() {
      if (!_characters.contains(sampleCharacter)) {
        _characters.add(sampleCharacter);
      }
      _currentCharacter = sampleCharacter;
      _currentSection = NavigationSection.overview; // Reset to overview
    });
  }

  Widget _buildNavigationTile(BuildContext context, NavigationSection section,
      IconData icon, String title) {
    final isSelected = _currentSection == section;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      selected: isSelected,
      selectedTileColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      onTap: () {
        setState(() {
          _currentSection = section;
        });
        Navigator.of(context).pop(); // Close drawer after selection
      },
    );
  }

  Widget _buildCurrentView(BuildContext context) {
    if (_currentCharacter == null) {
      return const SizedBox.shrink();
    }

    switch (_currentSection) {
      case NavigationSection.overview:
        return _buildOverviewView(context);
      case NavigationSection.attributes:
        return _buildAttributesView(context);
      case NavigationSection.skills:
        return _buildSkillsView(context);
      case NavigationSection.spells:
        return _buildSpellsView(context);
      case NavigationSection.spirits:
        return _buildSpiritsView(context);
      case NavigationSection.adeptPowers:
        return _buildAdeptPowersView(context);
      case NavigationSection.complexForms:
        return _buildComplexFormsView(context);
      case NavigationSection.sprites:
        return _buildSpritesView(context);
      case NavigationSection.gear:
        return _buildGearView(context);
      case NavigationSection.combat:
        return _buildCombatView(context);
      case NavigationSection.contacts:
        return _buildContactsView(context);
      case NavigationSection.notes:
        return _buildNotesView(context);
    }
  }

  Widget _buildOverviewView(BuildContext context) {
    final spacing = ResponsiveLayout.getCardSpacing(context);

    return Column(
      children: [
        CharacterInfoCard(character: _currentCharacter!),
        SizedBox(height: spacing),
        AttributesCard(character: _currentCharacter!),
        SizedBox(height: spacing),
        _buildConditionMonitorCard(),
        SizedBox(height: spacing),
        _buildDerivedAttributesCard(),
      ],
    );
  }

  Widget _buildAttributesView(BuildContext context) {
    return AttributesCard(character: _currentCharacter!);
  }

  Widget _buildSkillsView(BuildContext context) {
    return SkillsCard(character: _currentCharacter!);
  }

  Widget _buildMagicalListView<T>({
    required BuildContext context,
    required List<T> items,
    required IconData icon,
    required String title,
    required String singularLabel,
    required String emptyMessage,
    required Widget Function(BuildContext, T) itemBuilder,
    }) 
    { 
      final itemCountText =
          '${items.length} $singularLabel${items.length == 1 ? '' : 's'}';

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              if (items.isEmpty)
                Text(
                  emptyMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                )
              else
                ...items.map((e) => itemBuilder(context, e)).toList(),
            ],
          ),
        ),
      );
  }

  Widget _buildSpellsView(BuildContext context) {
    final spells = _currentCharacter!.spells;

    return _buildMagicalListView<Spell>(
      context: context,
      items: spells,
      icon: Icons.auto_fix_high,
      title: 'Spells',
      singularLabel: 'spell',
      emptyMessage: 'No spells known',
      itemBuilder: _buildSpellCard,
    );
  }

  Widget _buildComplexFormsView(BuildContext context) {
    final complexForms = _currentCharacter!.complexForms;

    return _buildMagicalListView<ComplexForm>(
      context: context,
      items: complexForms,
      icon: Icons.auto_fix_high,
      title: 'Complex Forms',
      singularLabel: 'complex form',
      emptyMessage: 'No complex forms known',
      itemBuilder: _buildComplexFormCard,
    );
  }

  Widget _buildMagicalCard({
    required BuildContext context,
    required String name,
    String? category,
    required bool hasCompleteInfo,
    required List<MapEntry<String, String>> fields, // label -> value
    required String incompleteMessage,
    required Widget Function(BuildContext, String label, String value) chipBuilder,
    }) 
    {
      return Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (category != null && category.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
            if (hasCompleteInfo) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: fields
                    .where((entry) => entry.value.isNotEmpty)
                    .map((entry) => chipBuilder(context, entry.key, entry.value))
                    .toList(),
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text(
                incompleteMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.orange[700],
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ],
        ),
      );
  }

  Widget _buildSpellCard(BuildContext context, Spell spell) {
    return _buildMagicalCard(
    context: context,
    name: spell.name,
    category: spell.category,
    hasCompleteInfo: spell.hasCompleteInfo,
    incompleteMessage: 'Incomplete spell information',
    fields: [
      MapEntry('Range', spell.range),
      MapEntry('Duration', spell.duration),
      MapEntry('Drain', spell.drain),
      MapEntry('Source', spell.source),
    ],
    chipBuilder: _buildSpellDetailChip,
    );
  }
  
  Widget _buildComplexFormCard(BuildContext context, ComplexForm form) {
    return _buildMagicalCard(
    context: context,
    name: form.name,
    category: null,
    hasCompleteInfo: form.hasCompleteInfo,
    incompleteMessage: 'Incomplete complex form information',
    fields: [
      MapEntry('Target', form.target),
      MapEntry('Duration', form.duration),
      MapEntry('Fading', form.fading),
      MapEntry('Source', form.source),
    ],
    chipBuilder: _buildComplexFormDetailChip,
    );
  }

  Widget _buildSpellDetailChip(
      BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildComplexFormDetailChip(
      BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSpiritsView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spirits',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Spirits section coming soon...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdeptPowersView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adept Powers',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Adept Powers section coming soon...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpritesView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sprites',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Sprites section coming soon...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGearView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gear',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Gear section coming soon...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombatView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Combat',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Combat section coming soon...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contacts',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Contacts section coming soon...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Notes section coming soon...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionMonitorCard() {
    final cm = _currentCharacter!.conditionMonitor;
    final cmPenalty = _currentCharacter!.conditionMonitorPenalty;
    debugPrint(
        "Condition Monitor: ${cm.physicalCMFilled}/${cm.physicalCMTotal} Physical, ${cm.stunCMFilled}/${cm.stunCMTotal} Stun, CM Penalty: $cmPenalty");

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Condition Monitors',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                // CM Penalty indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: cmPenalty < 0
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: cmPenalty < 0
                          ? Colors.red.shade400
                          : Colors.green.shade400,
                    ),
                  ),
                  child: Text(
                    'CM Penalty: ${cmPenalty >= 0 ? '+' : ''}$cmPenalty',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: cmPenalty < 0
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildConditionMonitor(
                    'Physical',
                    cm.physicalCMFilled,
                    cm.physicalCMTotal,
                    cm.physicalCMOverflow,
                    cm.physicalStatus,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildConditionMonitor(
                    'Stun',
                    cm.stunCMFilled,
                    cm.stunCMTotal,
                    0, // Stun has no overflow
                    cm.stunStatus,
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

  Widget _buildConditionMonitor(String label, int filled, int total,
      int overflow, String status, Color color) {
    // Calculate if we're in overflow state
    final isInOverflow = filled > total;
    final overflowAmount = isInOverflow ? filled - total : 0;
    final normalFilled = isInOverflow ? total : filled;
    final isNearDeath = overflowAmount >= overflow && overflow > 0;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isNearDeath
              ? Colors.red.shade800
              : isInOverflow
                  ? Colors.red.shade600
                  : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: isNearDeath ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isNearDeath ? Colors.red.shade800 : null,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (total > 0) ...[
            // Normal condition monitor progress bar
            LinearProgressIndicator(
              value: (normalFilled / total).clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
            // Overflow progress bar (if applicable)
            if (overflow > 0 && label == 'Physical') ...[
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: overflow > 0
                    ? (overflowAmount / overflow).clamp(0.0, 1.0)
                    : 0.0,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isNearDeath ? Colors.red.shade800 : Colors.red.shade600,
                ),
                minHeight: 4,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$normalFilled / $total',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isInOverflow && label == 'Physical')
                      Text(
                        'Overflow: $overflowAmount / $overflow',
                        style: TextStyle(
                          fontSize: 10,
                          color: isNearDeath
                              ? Colors.red.shade800
                              : Colors.red.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                if (isNearDeath)
                  Icon(
                    Icons.warning,
                    color: Colors.red.shade800,
                    size: 16,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Add increment/decrement controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: filled > 0
                      ? () => _adjustConditionMonitor(label, -1)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                  iconSize: 20,
                  padding: const EdgeInsets.all(4),
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                  style: IconButton.styleFrom(
                    foregroundColor: filled > 0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: (label == 'Physical'
                          ? filled < (total + overflow)
                          : filled < total)
                      ? () => _adjustConditionMonitor(label, 1)
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 20,
                  padding: const EdgeInsets.all(4),
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                  style: IconButton.styleFrom(
                    foregroundColor: (label == 'Physical'
                            ? filled < (total + overflow)
                            : filled < total)
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Show placeholder when no condition monitor data
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'No data available',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'dead':
        return Colors.red.shade800;
      case 'down':
      case 'unconscious':
        return Colors.red.shade600;
      case 'up':
      case 'conscious':
        return Colors.green.shade600;
      default:
        return Colors.grey;
    }
  }

  Widget _buildDerivedAttributesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Derived Attributes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDerivedAttribute(
                      'Physical Limit', _currentCharacter!.physicalLimit),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDerivedAttribute(
                      'Mental Limit', _currentCharacter!.mentalLimit),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDerivedAttribute(
                      'Social Limit', _currentCharacter!.socialLimit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDerivedAttribute(String label, int value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _adjustConditionMonitor(String monitorType, int delta) {
    if (_currentCharacter == null) return;

    final isPhysical = monitorType == 'Physical';
    final increment = delta > 0;

    final updatedCharacter = _currentCharacter!.adjustConditionMonitor(
      isPhysical: isPhysical,
      increment: increment,
    );

    setState(() {
      // Update the character in our list
      final characterIndex = _characters.indexOf(_currentCharacter!);
      if (characterIndex != -1) {
        _characters[characterIndex] = updatedCharacter;
        _currentCharacter = updatedCharacter;
      }
    });

    debugPrint("Adjusted $monitorType condition monitor by $delta");
  }
}
