import 'package:flutter/material.dart';
import '../models/shadowrun_character.dart';
import '../widgets/character_info_card.dart';
import '../widgets/attributes_card.dart';
import '../widgets/screen_size_indicator.dart';
import '../utils/responsive_layout.dart';
import 'skills_screen.dart';

class CharacterDetailScreen extends StatelessWidget {
  final ShadowrunCharacter character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name ?? 'Character Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: ScreenSizeIndicator()),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveLayout.getContentMaxWidth(context),
          ),
          child: SingleChildScrollView(
            padding: ResponsiveLayout.getPagePadding(context),
            child: _buildResponsiveLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context) {
    final screenSize = ResponsiveLayout.getScreenSize(context);
    final cardSpacing = ResponsiveLayout.getCardSpacing(context);
    
    switch (screenSize) {
      case ScreenSize.phone:
        return _buildPhoneLayout(context, cardSpacing);
      case ScreenSize.tablet:
        return _buildTabletLayout(context, cardSpacing);
      case ScreenSize.desktop:
      case ScreenSize.fourK:
        return _buildDesktopLayout(context, cardSpacing);
    }
  }

  Widget _buildPhoneLayout(BuildContext context, double spacing) {
    return Column(
      children: [
        CharacterInfoCard(character: character),
        SizedBox(height: spacing),
        AttributesCard(character: character),
        SizedBox(height: spacing),
        _buildConditionMonitorCard(),
        SizedBox(height: spacing),
        _buildDerivedAttributesCard(),
        SizedBox(height: spacing),
        _buildNavigationCard(context),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, double spacing) {
    return Column(
      children: [
        // Top row: Character info takes full width
        CharacterInfoCard(character: character),
        SizedBox(height: spacing),
        
        // Second row: Attributes and Condition Monitor side by side
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: AttributesCard(character: character),
            ),
            SizedBox(width: spacing),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildConditionMonitorCard(),
                  SizedBox(height: spacing),
                  _buildDerivedAttributesCard(),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        _buildNavigationCard(context),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, double spacing) {
    return Column(
      children: [
        // Top row: Character info and condition monitor
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: CharacterInfoCard(character: character),
            ),
            SizedBox(width: spacing),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildConditionMonitorCard(),
                  SizedBox(height: spacing),
                  _buildDerivedAttributesCard(),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        
        // Second row: Attributes take full width for better grid display
        AttributesCard(character: character),
        SizedBox(height: spacing),
        _buildNavigationCard(context),
      ],
    );
  }

  Widget _buildConditionMonitorCard() {
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
                    character.conditionMonitor.physicalCMFilled,
                    character.conditionMonitor.physicalCMTotal,
                    character.conditionMonitor.physicalCMOverflow,
                    character.conditionMonitor.physicalStatus,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildConditionMonitor(
                    'Stun',
                    character.conditionMonitor.stunCMFilled,
                    character.conditionMonitor.stunCMTotal,
                    0, // No stun overflow
                    character.conditionMonitor.stunStatus,
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
            _buildDerivedAttributeGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildDerivedAttributeGrid() {
    final derivedAttributes = [
      ('Initiative', character.initiative.toString()),
      ('Physical Limit', character.physicalLimit.toString()),
      ('Mental Limit', character.mentalLimit.toString()),
      ('Social Limit', character.socialLimit.toString()),
      ('Composure', character.composure.toString()),
      ('Judge Intentions', character.judgeIntentions.toString()),
      ('Memory', character.memory.toString()),
      ('Lift/Carry', character.liftCarry.toString()),
      ('Movement', character.movement.toString()),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: derivedAttributes.length,
      itemBuilder: (context, index) {
        final (label, value) = derivedAttributes[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Character Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SkillsScreen(character: character),
                        ),
                      );
                    },
                    icon: const Icon(Icons.psychology),
                    label: const Text('Skills & Magic'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Future: Navigate to equipment screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Equipment screen coming soon!'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.inventory),
                    label: const Text('Equipment'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
