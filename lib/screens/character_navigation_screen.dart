import 'package:flutter/material.dart';
import '../models/shadowrun_character.dart';
import '../widgets/character_info_card.dart';
import '../widgets/attributes_card.dart';
import '../widgets/screen_size_indicator.dart';
import '../utils/responsive_layout.dart';

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

class CharacterNavigationScreen extends StatefulWidget {
  final ShadowrunCharacter character;

  const CharacterNavigationScreen({super.key, required this.character});

  @override
  State<CharacterNavigationScreen> createState() => _CharacterNavigationScreenState();
}

class _CharacterNavigationScreenState extends State<CharacterNavigationScreen> {
  NavigationSection _currentSection = NavigationSection.overview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.character.name ?? 'Character'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: ScreenSizeIndicator()),
          ),
        ],
      ),
      drawer: _buildNavigationDrawer(context),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveLayout.getContentMaxWidth(context),
          ),
          child: SingleChildScrollView(
            padding: ResponsiveLayout.getPagePadding(context),
            child: _buildCurrentView(context),
          ),
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
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: Text(
                    (widget.character.name?.isNotEmpty == true) 
                        ? widget.character.name![0].toUpperCase() 
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
                  widget.character.name ?? 'Unknown',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.character.alias?.isNotEmpty == true)
                  Text(
                    '"${widget.character.alias}"',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          _buildNavigationTile(
            context,
            NavigationSection.overview,
            Icons.dashboard,
            'Overview',
          ),
          const Divider(),
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
      ),
    );
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
    final spacing = ResponsiveLayout.getCardSpacing(context);
    
    return Column(
      children: [
        CharacterInfoCard(character: widget.character),
        SizedBox(height: spacing),
        AttributesCard(character: widget.character),
        SizedBox(height: spacing),
        _buildConditionMonitorCard(),
        SizedBox(height: spacing),
        _buildDerivedAttributesCard(),
      ],
    );
  }

  Widget _buildAttributesView(BuildContext context) {
    return AttributesCard(character: widget.character);
  }

  Widget _buildSkillsView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.character.skills.isEmpty)
              const Text('No skills found')
            else
              ...widget.character.skills.map((skill) => ListTile(
                title: Text(skill.name),
                subtitle: Text('Group: ${skill.skillGroupName}'),
                trailing: Text('Total: ${skill.skillGroupTotal}'),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildSpellsView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spells',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.character.spells.isEmpty)
              const Text('No spells found')
            else
              ...widget.character.spells.map((spell) => ListTile(
                title: Text(spell.name),
                subtitle: Text(spell.category),
              )),
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
            const Text(
              'Gear',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.character.gear.isEmpty)
              const Text('No gear found')
            else
              ...widget.character.gear.map((gear) => ListTile(
                title: Text(gear.name),
                subtitle: Text('Qty: ${gear.quantity}'),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildCombatView(BuildContext context) {
    return Column(
      children: [
        _buildConditionMonitorCard(),
        const SizedBox(height: 16),
        _buildDerivedAttributesCard(),
      ],
    );
  }

  Widget _buildContactsView(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contacts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('No contacts implemented yet'),
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
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('No notes implementation yet'),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionMonitorCard() {
    final cm = widget.character.conditionMonitor;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Condition Monitors',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
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

  Widget _buildConditionMonitor(String label, int filled, int total, int overflow, String status, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(status),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: total > 0 ? (filled / total).clamp(0.0, 1.0) : 0,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 4),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$filled / $total',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                if (overflow > 0)
                  Text(
                    'Overflow: $overflow',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
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
            const Text(
              'Derived Attributes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDerivedAttribute('Physical Limit', widget.character.physicalLimit),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDerivedAttribute('Mental Limit', widget.character.mentalLimit),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDerivedAttribute('Social Limit', widget.character.socialLimit),
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
}
