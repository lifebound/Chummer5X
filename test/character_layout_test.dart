import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/widgets/character_info_card.dart';
import 'package:chummer5x/models/shadowrun_character.dart';
import 'package:chummer5x/models/mugshot.dart';
import 'package:chummer5x/models/condition_monitor.dart';

void main() {
  group('CharacterInfoCard Layout Tests', () {
    testWidgets('should position avatar in upper right corner', (WidgetTester tester) async {
      final character = ShadowrunCharacter(
        name: 'Test Runner',
        alias: 'Shadow',
        metatype: 'Human',
        attributes: [],
        qualities: [],
        skills: [],
        spells: [],
        spirits: [],
        sprites: [],
        complexForms: [],
        adeptPowers: [],
        gear: [],
        conditionMonitor: const ConditionMonitor(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterInfoCard(character: character),
          ),
        ),
      );

      // Should find Stack widgets (there may be multiple in the layout)
      expect(find.byType(Stack), findsWidgets);
      
      // Should find a Positioned widget for the avatar
      expect(find.byType(Positioned), findsOneWidget);
      
      // Should find the character name
      expect(find.text('Test Runner'), findsOneWidget);
      expect(find.text('"Shadow"'), findsOneWidget);
      expect(find.text('Human'), findsOneWidget);
      
      // Should find a CircleAvatar
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should show mugshot in positioned avatar when available', (WidgetTester tester) async {
      // Simple 1x1 pixel PNG in base64
      const base64Png = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChAFAtlUinwAAAABJRU5ErkJggg==';
      final mugshot = Mugshot.fromBase64(base64Png);

      final character = ShadowrunCharacter(
        name: 'Mugshot Runner',
        alias: 'Photo',
        attributes: [],
        qualities: [],
        skills: [],
        spells: [],
        spirits: [],
        sprites: [],
        complexForms: [],
        adeptPowers: [],
        gear: [],
        conditionMonitor: const ConditionMonitor(),
        mugshot: mugshot,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterInfoCard(character: character),
          ),
        ),
      );

      // Should find positioned avatar with mugshot
      expect(find.byType(Positioned), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      
      // Verify the CircleAvatar has a MemoryImage background
      final CircleAvatar avatar = tester.widget(find.byType(CircleAvatar));
      expect(avatar.backgroundImage, isA<MemoryImage>());
    });
  });
}
