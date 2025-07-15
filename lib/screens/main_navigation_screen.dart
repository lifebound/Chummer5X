import 'package:flutter/material.dart';
import '../models/shadowrun_character.dart';
import '../services/enhanced_chumer_xml_service.dart';
import '../utils/responsive_layout.dart';
import '../utils/skill_attribute_map.dart';
import '../widgets/character_info_card.dart';
import '../widgets/attributes_card.dart';
import '../widgets/skills_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chummer5x/models/spells.dart';
import 'package:chummer5x/models/complex_forms.dart';
import 'package:chummer5x/models/adept_powers.dart';
import 'package:chummer5x/models/qualities.dart';
import 'package:chummer5x/models/initiation.dart';
import 'package:chummer5x/models/submersion.dart';
import 'package:chummer5x/models/metamagic.dart';
import 'package:chummer5x/models/critter_base.dart';
import 'package:chummer5x/models/gear.dart';
import 'package:chummer5x/models/spirit.dart';
import 'package:chummer5x/models/sprite.dart';

enum NavigationSection {
  overview,
  attributes,
  qualities,
  skills,
  spells,
  spirits,
  adeptPowers,
  complexForms,
  sprites,
  initiationGrades,
  submersionGrades,
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

          // ListTile(
          //   leading: const Icon(Icons.person_add),
          //   title: const Text('Create Sample Character'),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     _createSampleCharacter();
          //   },
          // ),

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
              NavigationSection.qualities,
              Icons.star,
              'Qualities',
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
            if (_currentCharacter!.shouldShowInitiationGradesTab)
              _buildNavigationTile(
                context,
                NavigationSection.initiationGrades,
                Icons.trending_up,
                'Initiation',
              ),
            if (_currentCharacter!.shouldShowSubmersionGradesTab)
              _buildNavigationTile(
                context,
                NavigationSection.submersionGrades,
                Icons.trending_up,
                'Submersion',
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
                  // OutlinedButton.icon(
                  //   onPressed: _createSampleCharacter,
                  //   icon: const Icon(Icons.person_add),
                  //   label: const Text('Create Sample'),
                  // ),
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
      case NavigationSection.qualities:
        return _buildQualitiesView(context);
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
      case NavigationSection.initiationGrades:
        return _buildInitiationGradesView(context);
      case NavigationSection.submersionGrades:
        return _buildSubmersionGradesView(context);
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

  Widget _buildQualitiesView(BuildContext context) {
    final qualities = _currentCharacter!.qualities ?? [];
    final positiveQualities = qualities.where((q) => q.qualityType == QualityType.positive).toList();
    final negativeQualities = qualities.where((q) => q.qualityType == QualityType.negative).toList();
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Positive Qualities Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.add_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Positive Qualities',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (positiveQualities.isEmpty)
                    Text(
                      'No positive qualities',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else
                    ...positiveQualities.map((quality) => _buildQualityCard(context, quality)).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Negative Qualities Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.remove_circle, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Negative Qualities',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (negativeQualities.isEmpty)
                    Text(
                      'No negative qualities',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else
                    ...negativeQualities.map((quality) => _buildQualityCard(context, quality)).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
  Widget _buildAdeptPowersView(BuildContext context) {
    return _buildMagicalListView<AdeptPower>(
      context: context,
      items: _currentCharacter!.adeptPowers,
      icon: Icons.auto_fix_high,
      title: 'Adept Powers',
      singularLabel: 'adept power',
      emptyMessage: 'No adept powers known',
      itemBuilder: _buildAdeptPowersCard,
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
  Widget _buildAdeptPowersCard(BuildContext context, AdeptPower power) {
    return _buildMagicalCard(
      context: context,
      name: power.name,
      hasCompleteInfo: power.hasCompleteInfo,
      incompleteMessage: 'Incomplete adept power information',
      fields: [
        MapEntry('Rating', power.rating?.toString() ?? 'N/A'),
        MapEntry('Action', power.action?.toString() ?? 'N/A'),
        MapEntry('Source', '${power.source} (${power.page})'),
      ],
      chipBuilder: _buildPowerDetailChip,
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
  Widget _buildPowerDetailChip(
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
  
  Widget _buildQualityCard(BuildContext context, Quality quality) {
    Color categoryColor;
    String categoryLabel;
    
    switch (quality.qualityType) {
      case QualityType.positive:
        categoryColor = Colors.green;
        categoryLabel = 'Positive';
        break;
      case QualityType.negative:
        categoryColor = Colors.red;
        categoryLabel = 'Negative';
        break;
    }

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
                  quality.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  categoryLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: categoryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Quality details
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildQualityDetailChip(context, 'Karma Cost', quality.karmaCost.toString()),
              if (quality.source.isNotEmpty)
                _buildQualityDetailChip(context, 'Source', quality.source),
              if (quality.page.isNotEmpty)
                _buildQualityDetailChip(context, 'Page', quality.page),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualityDetailChip(BuildContext context, String label, String value) {
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

  Widget _buildInitiationGradesView(BuildContext context) {
    final grades = _currentCharacter!.initiationGrades;
    
    // Sort grades from highest to lowest
    final sortedGrades = [...grades]..sort((a, b) => b.grade.compareTo(a.grade));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.trending_up, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Initiation Grades',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                Text(
                  '${grades.length} grade${grades.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (grades.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No initiation grades',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...sortedGrades.map((grade) => _buildInitiationGradeItem(context, grade)).toList(),
        ],
      ),
    );
  }

  Widget _buildSubmersionGradesView(BuildContext context) {
    final grades = _currentCharacter!.submersionGrades;
    
    // Sort grades from highest to lowest
    final sortedGrades = [...grades]..sort((a, b) => b.grade.compareTo(a.grade));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.trending_up, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Submersion Grades',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                Text(
                  '${grades.length} grade${grades.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (grades.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No submersion grades',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...sortedGrades.map((grade) => _buildSubmersionGradeItem(context, grade)).toList(),
        ],
      ),
    );
  }

  Widget _buildInitiationGradeItem(BuildContext context, InitiationGrade grade) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Grade ${grade.grade}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              // Grade type chips
              if (grade.group) _buildGradeChip(context, 'group', Colors.blue),
              if (grade.ordeal) _buildGradeChip(context, 'ordeal', Colors.orange),
              if (grade.schooling) _buildGradeChip(context, 'schooling', Colors.green),
            ],
          ),
          // Metamagic display
          if (grade.metamagics != null && grade.metamagics!.isNotEmpty) ...[
            const SizedBox(height: 12),
            // Build a metamagic item for each item in the list
            ...grade.metamagics!.map((metamagic) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildMetamagicItem(context, metamagic),
            )).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmersionGradeItem(BuildContext context, SubmersionGrade grade) {
    debugPrint('creating submerion grade item $grade');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Grade ${grade.grade}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              // Grade type chips (with submersion-specific labels)
              if (grade.group) _buildGradeChip(context, 'network', Colors.blue),
              if (grade.ordeal) _buildGradeChip(context, 'task', Colors.orange),
              if (grade.schooling) _buildGradeChip(context, 'schooling', Colors.green),
            ],
          ),
          // Metamagic display (these would be Echo powers for submersion)
          if (grade.metamagics != null && grade.metamagics!.isNotEmpty) ...[
            const SizedBox(height: 12),
            // Build a metamagic item for each item in the list
            ...grade.metamagics!.map((metamagic) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildMetamagicItem(context, metamagic),
            )).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildGradeChip(BuildContext context, String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildMetamagicItem(BuildContext context, Metamagic metamagic) {
    debugPrint('entering build metamagic Item $metamagic');
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_fix_high,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              metamagic.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          if (metamagic.source.isNotEmpty) ...[
            Text(
              '${metamagic.source}${metamagic.page.isNotEmpty ? ' p${metamagic.page}' : ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
              ),
            ),
          ],
        ],
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
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDerivedAttribute(
                      'Astral Limit', _currentCharacter!.astralLimit),
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

  Widget _buildCritterListView<T extends Critter>({
    required BuildContext context,
    required List<T> critters,
    required IconData icon,
    required String title,
    required String singularLabel,
    required String emptyMessage,
    required Widget Function(BuildContext, T) itemBuilder,
  }) {
    final itemCountText =
        '${critters.length} $singularLabel${critters.length == 1 ? '' : 's'}';

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
            if (critters.isEmpty)
              Text(
                emptyMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
              )
            else
              ...critters.map((critter) => itemBuilder(context, critter)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpiritsView(BuildContext context) {
    final spirits = _currentCharacter!.spirits;

    return _buildCritterListView<Spirit>(
      context: context,
      critters: spirits,
      icon: Icons.pets,
      title: 'Spirits',
      singularLabel: 'spirit',
      emptyMessage: 'No spirits summoned',
      itemBuilder: _buildSpiritCard,
    );
  }

  Widget _buildSpritesView(BuildContext context) {
    final sprites = _currentCharacter!.sprites;

    return _buildCritterListView<Sprite>(
      context: context,
      critters: sprites,
      icon: Icons.computer,
      title: 'Sprites',
      singularLabel: 'sprite',
      emptyMessage: 'No sprites compiled',
      itemBuilder: _buildSpriteCard,
    );
  }

  Widget _buildCritterCard({
    required BuildContext context,
    required Critter critter,
    required List<MapEntry<String, String>> primaryFields,
    required List<MapEntry<String, String>> secondaryFields,
    required String typeLabel,
    required Color typeColor,
    required String serviceNameSingle,
    required ShadowrunCharacter character,
  }) {
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      critter.crittername?.isNotEmpty == true
                          ? critter.crittername!
                          : critter.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      ),
                  ),
                  if (critter.crittername?.isNotEmpty == true)
                    Text(
                    '  (${critter.name})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: typeColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$typeLabel • Force ${critter.force}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: typeColor,
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
            children: primaryFields
                .where((entry) => entry.value.isNotEmpty)
                .map((entry) => _buildCritterStatChip(context, entry.key, entry.value))
                .toList(),
          ),
          
          // Skills section
          if (critter.baseSkills.isNotEmpty) ...[
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
              children: _buildCritterSkillChips(context, critter),
            ),
          ],
          
          // Powers section
          if (critter.powers.isNotEmpty) ...[
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
              children: critter.powers
                  .map((power) => _buildPowerChip(context, power))
                  .toList(),
            ),
          ],
          
          // Secondary stats row
          if (secondaryFields.any((entry) => entry.value.isNotEmpty)) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: secondaryFields
                  .where((entry) => entry.value.isNotEmpty)
                  .map((entry) => _buildCritterDetailChip(context, entry.key, entry.value))
                  .toList(),
            ),
          ],
          
          // Special abilities
          if (critter.special?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
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
                      critter.special!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          critter.services == 0
            ? StatefulBuilder(
                builder: (context, setLocalState) {
                  final controller = TextEditingController();
                  
                  void setServices() {
                    final parsed = int.tryParse(controller.text);
                    if (parsed != null && parsed > 0) {
                      setState(() {
                        critter.services = parsed;
                      });
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
                  Text('Services: ${critter.services}'),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (critter.services > 0) {
                          critter.services = critter.services - 1;
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        critter.services = critter.services + 1;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Reset',
                    onPressed: () {
                      setState(() {
                        critter.services = 0;
                      });
                    },
                  ),
                ],
              ),
          
          // Switches section
          const SizedBox(height: 12),
          
          // Bound/Registered switch
          Row(
            children: [
              Text(
                critter.type == CritterType.spirit ? 'Bound' : 'Registered',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: critter.bound,
                onChanged: (value) {
                  setState(() {
                    critter.bound = value;
                    // Update the character's list to trigger UI rebuild
                    if (critter.type == CritterType.spirit) {
                      _currentCharacter = _currentCharacter!.copyWith(
                        spirits: List.from(_currentCharacter!.spirits),
                      );
                    } else {
                      _currentCharacter = _currentCharacter!.copyWith(
                        sprites: List.from(_currentCharacter!.sprites),
                      );
                    }
                  });
                },
              ),
            ],
          ),
          
          // Fettered/Pet switch (conditional)
          if ((critter.type == CritterType.spirit && character.canFetterSpirit) ||
              (critter.type == CritterType.sprite && character.canFetterSprite)) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  critter.type == CritterType.spirit ? 'Fettered' : 'Sprite Pet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: critter.fettered,
                  onChanged: (value) {
                    setState(() {
                      critter.fettered = value;
                      // Update the character's list to trigger UI rebuild
                      if (critter.type == CritterType.spirit) {
                        _currentCharacter = _currentCharacter!.copyWith(
                          spirits: List.from(_currentCharacter!.spirits),
                        );
                      } else {
                        _currentCharacter = _currentCharacter!.copyWith(
                          sprites: List.from(_currentCharacter!.sprites),
                        );
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpiritCard(BuildContext context, Spirit spirit) {
    return _buildCritterCard(
      context: context,
      critter: spirit,
      typeLabel: 'Spirit',
      typeColor: Colors.purple,
      primaryFields: [
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
      secondaryFields: [
        MapEntry('Initiative', spirit.initiative),
        MapEntry('Astral Initiative', spirit.astralInitiative),
        MapEntry('Initiative Type', spirit.initiativeType),
      ],
      serviceNameSingle: 'service',
      character: _currentCharacter!,
    );
  }

  Widget _buildSpriteCard(BuildContext context, Sprite sprite) {
    return _buildCritterCard(
      context: context,
      critter: sprite,
      typeLabel: 'Sprite',
      typeColor: Colors.cyan,
      primaryFields: [
        MapEntry('ATK', sprite.atk.toString()),
        MapEntry('SLZ', sprite.slz.toString()),
        MapEntry('DP', sprite.dp.toString()),
        MapEntry('FWL', sprite.fwl.toString()),
      ],
      secondaryFields: [
        MapEntry('Matrix Initiative', sprite.initiative),
      ],
      serviceNameSingle: 'task',
      character: _currentCharacter!,
    );
  }

  Widget _buildCritterStatChip(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
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

  Widget _buildCritterDetailChip(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.7),
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
        .map((skillEntry) => _buildCritterSkillChip(context, critter, skillEntry.key, skillEntry.value))
        .toList();
  }

  /// Builds a single skill chip for a critter
  Widget _buildCritterSkillChip(BuildContext context, Critter critter, String skillName, int skillRating) {
    final dicePool = _calculateCritterSkillDicePool(critter, skillName, skillRating);
    final isDefaulting = _isCritterSkillDefaulting(skillName, skillRating);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDefaulting 
            ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.3)
            : Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.7),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDefaulting 
              ? Theme.of(context).colorScheme.error.withOpacity(0.5)
              : Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
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
                  ? Theme.of(context).colorScheme.error.withOpacity(0.2)
                  : Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
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
  int _calculateCritterSkillDicePool(Critter critter, String skillName, int skillRating) {
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
        return sprite.dp;  // LOG→DP
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
