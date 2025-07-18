import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/widgets/character_info_card.dart';
import 'package:chummer5x/models/shadowrun_character.dart';
import 'package:chummer5x/models/mugshot.dart';
import 'package:chummer5x/models/condition_monitor.dart';

void main() {
  group('CharacterInfoCard Avatar Tests', () {
    testWidgets('should display letter avatar when no mugshot', (WidgetTester tester) async {
      final character = ShadowrunCharacter(
        name: 'Test Character',
        alias: 'Test Character',
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
        mugshot: null, // No mugshot
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterInfoCard(character: character),
          ),
        ),
      );

      // Should find a CircleAvatar with text 'T' (first letter of name)
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('T'), findsOneWidget);
    });

    testWidgets('should display mugshot avatar when mugshot available', (WidgetTester tester) async {
      // Simple 1x1 pixel PNG in base64
      const base64Png = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChAFAtlUinwAAAABJRU5ErkJggg==';
      final mugshot = Mugshot.fromBase64(base64Png);

      final character = ShadowrunCharacter(
        name: 'Test Character',
        alias: 'Test Character', 
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

      // Should find a CircleAvatar but no text (image replaces text)
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('T'), findsNothing);

      // Verify the CircleAvatar has a MemoryImage background
      final CircleAvatar avatar = tester.widget(find.byType(CircleAvatar));
      expect(avatar.backgroundImage, isA<MemoryImage>());
    });

    testWidgets('should display character name and info', (WidgetTester tester) async {
      final character = ShadowrunCharacter(
        name: 'John Doe',
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

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('"Shadow"'), findsOneWidget);
      expect(find.text('Human'), findsOneWidget);
    });
  });
}
