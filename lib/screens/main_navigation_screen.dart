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
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
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
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
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
            _buildNavigationTile(
              context,
              NavigationSection.spells,
              Icons.auto_fix_high,
              'Spells',
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
                  _currentSection = NavigationSection.overview; // Reset to overview
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
        final character = EnhancedChumerXmlService.parseCharacterXml(xmlContent);
        
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
    final sampleCharacter = ShadowrunCharacter(
      name: 'Sample Runner',
      alias: 'Chrome',
      metatype: 'Human',
      skills: [
        const Skill(
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
        const Skill(
          name: 'Infiltration',
          base: '3',
          karma: '1',
          skillGroupName: 'Stealth',
          skillGroupTotal: 0,
        ),
        const Skill(
          name: 'Hacking',
          base: '5',
          karma: '1',
          skillGroupName: 'Cracking',
          skillGroupTotal: 0,
          isPrioritySkill: true, // Priority skill gets +2
        ),
        const Skill(
          name: 'Perception',
          base: '2',
          karma: '2',
          skillGroupName: '',
          skillGroupTotal: 0,
        ),
        const Skill(
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
        const Attribute(
          name: 'Body',
          metatypeCategory: 'Physical',
          totalValue: 4,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 1,
        ),
        const Attribute(
          name: 'Agility',
          metatypeCategory: 'Physical',
          totalValue: 5,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 4,
          karma: 1,
        ),
        const Attribute(
          name: 'Reaction',
          metatypeCategory: 'Physical',
          totalValue: 4,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 1,
        ),
        const Attribute(
          name: 'Strength',
          metatypeCategory: 'Physical',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 2,
          karma: 1,
        ),
        const Attribute(
          name: 'Charisma',
          metatypeCategory: 'Mental',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 2,
          karma: 1,
        ),
        const Attribute(
          name: 'Intuition',
          metatypeCategory: 'Mental',
          totalValue: 4,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 3,
          karma: 1,
        ),
        const Attribute(
          name: 'Logic',
          metatypeCategory: 'Mental',
          totalValue: 5,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 4,
          karma: 1,
        ),
        const Attribute(
          name: 'Willpower',
          metatypeCategory: 'Mental',
          totalValue: 3,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 2,
          karma: 1,
        ),
        const Attribute(
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
      conditionMonitor: const ConditionMonitor(
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

  Widget _buildNavigationTile(BuildContext context, NavigationSection section, IconData icon, String title) {
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
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
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
    return Column(
      children: [
        CharacterInfoCard(character: _currentCharacter!),
        const SizedBox(height: 16),
        AttributesCard(character: _currentCharacter!),
      ],
    );
  }

  Widget _buildAttributesView(BuildContext context) {
    return AttributesCard(character: _currentCharacter!);
  }

  Widget _buildSkillsView(BuildContext context) {
    return SkillsCard(character: _currentCharacter!);
  }

  Widget _buildSpellsView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spells',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Spells section coming soon...',
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
}
