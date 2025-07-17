import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/game_notes.dart';

void main() {
  group('RtfToMarkdownConverter', () {
    test('should convert simple RTF to markdown', () {
      const rtfContent = r'''{\rtf1\ansi\ansicpg1252\uc1\deff0\deflang1033\deflangfe1033{\fonttbl{\f0\fcharset0 Tahoma;}}
{\colortbl;}
{\*\generator Wine Riched20 2.0;}
\pard\sl-240\slmult1 \lang1033\fs16\f0 [TRACKER.LOG 2077-04-22.TXT]\par
\par
Attempted to open diplomatic relations with sentient AI.\par
\par
Team voted no.\par
}''';

      final markdown = RtfToMarkdownConverter.convertRtfToMarkdown(rtfContent);

      expect(markdown, contains('## TRACKER.LOG 2077-04-22.TXT'), reason: 'Should convert bracketed headers to markdown headers');
      expect(markdown, contains('Attempted to open diplomatic relations'), reason: 'Should preserve content text');
      expect(markdown, contains('Team voted no'), reason: 'Should preserve all content lines');
      expect(markdown, isNot(contains(r'\par')), reason: 'Should remove RTF control sequences');
      expect(markdown, isNot(contains(r'\rtf1')), reason: 'Should remove RTF header');
    });

    test('should extract plain text from RTF', () {
      const rtfContent = r'''{\rtf1\ansi\ansicpg1252\uc1\deff0\deflang1033\deflangfe1033{\fonttbl{\f0\fcharset0 Tahoma;}}
{\colortbl;}
\pard\sl-240\slmult1 \lang1033\fs16\f0 Nova has gone dark\par
\par
did a job for Alex. made a guy blind.\par
}''';

      final plainText = RtfToMarkdownConverter.extractPlainText(rtfContent);

      expect(plainText, contains('Nova has gone dark'), reason: 'Should extract content text');
      expect(plainText, contains('did a job for Alex'), reason: 'Should extract all content lines');
      expect(plainText, isNot(contains(r'\par')), reason: 'Should remove RTF formatting');
      expect(plainText, isNot(contains('fonttbl')), reason: 'Should remove RTF control structures');
    });

    test('should handle empty RTF content', () {
      final markdown = RtfToMarkdownConverter.convertRtfToMarkdown('');
      final plainText = RtfToMarkdownConverter.extractPlainText('');

      expect(markdown, isEmpty, reason: 'Empty input should return empty markdown');
      expect(plainText, isEmpty, reason: 'Empty input should return empty plain text');
    });

    test('should convert RTF paragraph breaks to newlines', () {
      const rtfContent = r'''\pard First line\par
Second line\par
Third line''';

      final result = RtfToMarkdownConverter.convertRtfToMarkdown(rtfContent);

      expect(result, contains('First line\n'), reason: 'Should convert \\par to newlines');
      expect(result, contains('Second line\n'), reason: 'Should convert multiple \\par sequences');
      expect(result, contains('Third line'), reason: 'Should preserve content without trailing \\par');
    });

    test('should convert tabs to spaces', () {
      const rtfContent = r'First\tab Second\tab Third';

      final result = RtfToMarkdownConverter.convertRtfToMarkdown(rtfContent);

      expect(result, contains('First    Second    Third'), reason: 'Should convert \\tab to 4 spaces');
    });
  });

  group('GameNotes', () {
    test('should create game notes from RTF content', () {
      const rtfContent = r'''{\rtf1\ansi\ansicpg1252\uc1\deff0\deflang1033\deflangfe1033{\fonttbl{\f0\fcharset0 Tahoma;}}
{\colortbl;}
\pard [LOG ENTRY]\par
Some game notes here\par
}''';

      final gameNotes = GameNotes.fromRtf(rtfContent);

      expect(gameNotes.rawContent, rtfContent, reason: 'Should store original RTF content');
      expect(gameNotes.plainText, isNotNull, reason: 'Should generate plain text from RTF');
      expect(gameNotes.markdownContent, isNotNull, reason: 'Should generate markdown from RTF');
      expect(gameNotes.plainText, contains('Some game notes here'), reason: 'Plain text should contain content');
    });

    test('should create game notes from XML content', () {
      const xmlContent = r'''{\rtf1\ansi\ansicpg1252\uc1\deff0\deflang1033\deflangfe1033{\fonttbl{\f0\fcharset0 Tahoma;}}
Game session notes\par
Player did something cool\par
}''';

      final gameNotes = GameNotes.fromXml(xmlContent);

      expect(gameNotes.rawContent, xmlContent, reason: 'Should store original RTF content from XML');
      expect(gameNotes.hasContent, true, reason: 'Should recognize that content exists');
    });

    test('should identify if content exists', () {
      final gameNotesWithContent = GameNotes.fromRtf(r'Some content\par');
      final gameNotesEmpty = GameNotes.fromRtf('');
      final gameNotesWhitespace = GameNotes.fromRtf(r'{\rtf1\par}');

      expect(gameNotesWithContent.hasContent, true, reason: 'Should detect content when present');
      expect(gameNotesEmpty.hasContent, false, reason: 'Should detect when no content');
      expect(gameNotesWhitespace.hasContent, false, reason: 'Should detect when only RTF structure exists');
    });

    test('should prefer markdown for display content', () {
      const rtfContent = r'''[LOG ENTRY]\par
Some content here\par''';

      final gameNotes = GameNotes.fromRtf(rtfContent);

      expect(gameNotes.displayContent, gameNotes.markdownContent, reason: 'Display content should prefer markdown when available');
    });

    test('should fall back to plain text when no markdown', () {
      const gameNotes = GameNotes(
        rawContent: 'raw',
        plainText: 'plain text content',
        markdownContent: null,
      );

      expect(gameNotes.displayContent, 'plain text content', reason: 'Should fall back to plain text when no markdown');
    });

    test('should fall back to raw content when nothing else available', () {
      const gameNotes = GameNotes(
        rawContent: 'raw content only',
        plainText: null,
        markdownContent: null,
      );

      expect(gameNotes.displayContent, 'raw content only', reason: 'Should fall back to raw content as last resort');
    });

    test('should get content for specific display type', () {
      const gameNotes = GameNotes(
        rawContent: 'raw',
        plainText: 'plain',
        markdownContent: 'markdown',
      );

      expect(gameNotes.getContentForDisplay(preferMarkdown: true), 'markdown', reason: 'Should return markdown when preferred and available');
      expect(gameNotes.getContentForDisplay(preferMarkdown: false), 'plain', reason: 'Should return plain text when not preferring markdown');
    });

    test('should extract log entries from content', () {
      final gameNotes = GameNotes.fromRtf(r'''[TRACKER.LOG 2077-04-22.TXT]\par
First log entry content\par
More content for first entry\par
\par
[TRACKER.LOG 2077-06-15.TXT]\par
Second log entry content\par
\par
Some untagged content\par
''');

      final logEntries = gameNotes.logEntries;

      expect(logEntries.length, greaterThanOrEqualTo(1), reason: 'Should extract log entries from content');
      expect(logEntries.any((entry) => entry.contains('TRACKER.LOG 2077-04-22.TXT')), true, reason: 'Should find first log entry');
      expect(logEntries.any((entry) => entry.contains('First log entry content')), true, reason: 'Should include log entry content');
    });

    test('should convert to XML format', () {
      const rtfContent = r'{\rtf1 Some RTF content\par}';
      final gameNotes = GameNotes.fromRtf(rtfContent);

      final xml = gameNotes.toXml();

      expect(xml, equals('<gamenotes>$rtfContent</gamenotes>'), reason: 'XML should wrap RTF content in gamenotes tags');
    });

    test('should convert to JSON format', () {
      const gameNotes = GameNotes(
        rawContent: 'raw',
        plainText: 'plain',
        markdownContent: 'markdown',
      );

      final json = gameNotes.toJson();

      expect(json['rawContent'], 'raw', reason: 'JSON should contain raw content');
      expect(json['plainText'], 'plain', reason: 'JSON should contain plain text');
      expect(json['markdownContent'], 'markdown', reason: 'JSON should contain markdown content');
    });

    test('should create from JSON format', () {
      final json = {
        'rawContent': 'test raw',
        'plainText': 'test plain',
        'markdownContent': 'test markdown',
      };

      final gameNotes = GameNotes.fromJson(json);

      expect(gameNotes.rawContent, 'test raw', reason: 'Should restore raw content from JSON');
      expect(gameNotes.plainText, 'test plain', reason: 'Should restore plain text from JSON');
      expect(gameNotes.markdownContent, 'test markdown', reason: 'Should restore markdown content from JSON');
    });

    test('should handle complex RTF with multiple formatting', () {
      const complexRtf = r'''{\rtf1\ansi\ansicpg1252\uc1\deff0\deflang1033\deflangfe1033{\fonttbl{\f0\fcharset0 Tahoma;}}
{\colortbl;}
{\*\generator Wine Riched20 2.0;}
\pard\sl-240\slmult1 \lang1033\fs16\f0 [TRACKER.LOG 2077-04-22.TXT]\par
\par
    Attempted to open diplomatic relations with sentient AI.\par
\par
    Team voted no.\par
\par
    Am now banned from standing near box.\par
\par
    Spirit of scientific inquiry apparently a team liability.\par
\par
[TRACKER.LOG 2077-06-15.TXT]\par
    Nova has gone dark\par
\tab \par
    did a job for Alex. made a guy blind. that was fun.\par
\tab \par
    Still trying to convince them to let me talk to the AI.\par
\par
    Pursuing avenues of research to vet its safetey without connection.\par
\par
\par
\par
\line
\par
}''';

      final gameNotes = GameNotes.fromRtf(complexRtf);

      expect(gameNotes.hasContent, true, reason: 'Should recognize complex RTF as having content');
      expect(gameNotes.plainText, contains('Attempted to open diplomatic relations'), reason: 'Should extract content from complex RTF');
      expect(gameNotes.plainText, contains('Nova has gone dark'), reason: 'Should extract all content sections');
      expect(gameNotes.markdownContent, contains('## TRACKER.LOG 2077-04-22.TXT'), reason: 'Should convert log headers to markdown');
      expect(gameNotes.markdownContent, contains('## TRACKER.LOG 2077-06-15.TXT'), reason: 'Should convert multiple log headers');
      
      final logEntries = gameNotes.logEntries;
      expect(logEntries.length, greaterThanOrEqualTo(2), reason: 'Should extract multiple log entries');
    });
  });
}
