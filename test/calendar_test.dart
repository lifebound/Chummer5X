import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/calendar.dart';

void main() {
  group('CalendarWeek', () {
    test('should create calendar week with required fields', () {
      final week = CalendarWeek(
        guid: 'test-guid-123',
        year: 2072,
        week: 15,
        notes: 'Test notes for this week',
        notesColor: 'Chocolate',
      );

      expect(week.guid, 'test-guid-123', reason: 'CalendarWeek should store the provided GUID');
      expect(week.year, 2072, reason: 'CalendarWeek should store the provided year');
      expect(week.week, 15, reason: 'CalendarWeek should store the provided week number');
      expect(week.notes, 'Test notes for this week', reason: 'CalendarWeek should store the provided notes');
      expect(week.notesColor, 'Chocolate', reason: 'CalendarWeek should store the provided notes color');
    });

    test('should create calendar week without optional fields', () {
      final week = CalendarWeek(
        guid: 'test-guid-456',
        year: 2072,
        week: 20,
      );

      expect(week.guid, 'test-guid-456', reason: 'CalendarWeek should store the provided GUID');
      expect(week.year, 2072, reason: 'CalendarWeek should store the provided year');
      expect(week.week, 20, reason: 'CalendarWeek should store the provided week number');
      expect(week.notes, isNull, reason: 'CalendarWeek notes should be null when not provided');
      expect(week.notesColor, isNull, reason: 'CalendarWeek notesColor should be null when not provided');
    });

    test('should identify if week has content', () {
      final weekWithContent = CalendarWeek(
        guid: 'guid-1',
        year: 2072,
        week: 1,
        notes: 'Some important notes',
      );

      final weekWithoutContent = CalendarWeek(
        guid: 'guid-2',
        year: 2072,
        week: 2,
      );

      final weekWithEmptyNotes = CalendarWeek(
        guid: 'guid-3',
        year: 2072,
        week: 3,
        notes: '',
      );

      expect(weekWithContent.hasContent, true, reason: 'Week with notes should have content');
      expect(weekWithoutContent.hasContent, false, reason: 'Week without notes should not have content');
      expect(weekWithEmptyNotes.hasContent, false, reason: 'Week with empty notes should not have content');
    });

    test('should generate display text correctly', () {
      final week = CalendarWeek(
        guid: 'test-guid',
        year: 2072,
        week: 25,
      );

      expect(week.displayText, '2072 Week 25', reason: 'Display text should be formatted as "Year Week Number"');
    });

    test('should convert to XML format', () {
      final week = CalendarWeek(
        guid: 'c3011d8b-6457-4306-823d-c900a3af8118',
        year: 2072,
        week: 3,
        notes: 'Test notes',
        notesColor: 'Chocolate',
      );

      final xml = week.toXml();

      expect(xml, contains('<week>'), reason: 'XML should contain opening week tag');
      expect(xml, contains('<guid>c3011d8b-6457-4306-823d-c900a3af8118</guid>'), reason: 'XML should contain the GUID');
      expect(xml, contains('<year>2072</year>'), reason: 'XML should contain the year');
      expect(xml, contains('<week>3</week>'), reason: 'XML should contain the week number');
      expect(xml, contains('<notes>Test notes</notes>'), reason: 'XML should contain the notes');
      expect(xml, contains('<notesColor>Chocolate</notesColor>'), reason: 'XML should contain the notes color');
      expect(xml, contains('</week>'), reason: 'XML should contain closing week tag');
    });

    test('should parse from XML data', () {
      final xmlData = {
        'guid': 'de235fe4-6ab8-46bf-89f6-297104087563',
        'year': '2072',
        'week': '2',
        'notes': 'Test log entry\nMultiple lines',
        'notesColor': 'Chocolate',
      };

      final week = CalendarWeek.fromXml(xmlData);

      expect(week.guid, 'de235fe4-6ab8-46bf-89f6-297104087563', reason: 'Parsed week should have correct GUID from XML');
      expect(week.year, 2072, reason: 'Parsed week should have correct year from XML');
      expect(week.week, 2, reason: 'Parsed week should have correct week number from XML');
      expect(week.notes, 'Test log entry\nMultiple lines', reason: 'Parsed week should have correct notes from XML');
      expect(week.notesColor, 'Chocolate', reason: 'Parsed week should have correct notes color from XML');
    });

    test('should handle empty notes in XML parsing', () {
      final xmlData = {
        'guid': 'test-guid',
        'year': '2072',
        'week': '1',
        'notes': '',
        'notesColor': 'Blue',
      };

      final week = CalendarWeek.fromXml(xmlData);

      expect(week.notes, isNull, reason: 'Empty notes in XML should be parsed as null');
    });
  });

  group('Calendar', () {
    test('should create calendar with weeks', () {
      final weeks = [
        CalendarWeek(
          guid: 'guid-1',
          year: 2072,
          week: 1,
          notes: 'Week 1 notes',
        ),
        CalendarWeek(
          guid: 'guid-2',
          year: 2072,
          week: 2,
        ),
      ];

      final calendar = Calendar(weeks: weeks);

      expect(calendar.weeks.length, 2, reason: 'Calendar should contain all provided weeks');
      expect(calendar.weeks[0].week, 1, reason: 'First week should be week 1');
      expect(calendar.weeks[1].week, 2, reason: 'Second week should be week 2');
    });

    test('should filter weeks with content', () {
      final weeks = [
        CalendarWeek(
          guid: 'guid-1',
          year: 2072,
          week: 1,
          notes: 'Week 1 has content',
        ),
        CalendarWeek(
          guid: 'guid-2',
          year: 2072,
          week: 2,
        ),
        CalendarWeek(
          guid: 'guid-3',
          year: 2072,
          week: 3,
          notes: 'Week 3 also has content',
        ),
      ];

      final calendar = Calendar(weeks: weeks);
      final weeksWithContent = calendar.weeksWithContent;

      expect(weeksWithContent.length, 2, reason: 'Should return only weeks that have content');
      expect(weeksWithContent[0].week, 1, reason: 'First week with content should be week 1');
      expect(weeksWithContent[1].week, 3, reason: 'Second week with content should be week 3');
    });

    test('should sort weeks by year and week number', () {
      final weeks = [
        CalendarWeek(guid: 'guid-1', year: 2073, week: 1),
        CalendarWeek(guid: 'guid-2', year: 2072, week: 10),
        CalendarWeek(guid: 'guid-3', year: 2072, week: 5),
        CalendarWeek(guid: 'guid-4', year: 2074, week: 1),
      ];

      final calendar = Calendar(weeks: weeks);
      final sorted = calendar.sortedWeeks;

      expect(sorted.length, 4, reason: 'Sorted list should contain all weeks');
      expect(sorted[0].year, 2072, reason: 'First sorted week should be from earliest year');
      expect(sorted[0].week, 5, reason: 'First sorted week should be week 5 of 2072');
      expect(sorted[1].year, 2072, reason: 'Second sorted week should be from same year');
      expect(sorted[1].week, 10, reason: 'Second sorted week should be week 10 of 2072');
      expect(sorted[2].year, 2073, reason: 'Third sorted week should be from next year');
      expect(sorted[3].year, 2074, reason: 'Last sorted week should be from latest year');
    });

    test('should find specific week by year and week number', () {
      final weeks = [
        CalendarWeek(guid: 'guid-1', year: 2072, week: 10),
        CalendarWeek(guid: 'guid-2', year: 2072, week: 20),
        CalendarWeek(guid: 'guid-3', year: 2073, week: 5),
      ];

      final calendar = Calendar(weeks: weeks);

      final foundWeek = calendar.findWeek(2072, 20);
      final notFoundWeek = calendar.findWeek(2074, 1);

      expect(foundWeek, isNotNull, reason: 'Should find existing week');
      expect(foundWeek?.guid, 'guid-2', reason: 'Found week should have correct GUID');
      expect(notFoundWeek, isNull, reason: 'Should return null for non-existent week');
    });

    test('should convert to XML format', () {
      final weeks = [
        CalendarWeek(
          guid: 'guid-1',
          year: 2072,
          week: 1,
          notes: 'First week',
          notesColor: 'Blue',
        ),
        CalendarWeek(
          guid: 'guid-2',
          year: 2072,
          week: 2,
        ),
      ];

      final calendar = Calendar(weeks: weeks);
      final xml = calendar.toXml();

      expect(xml, contains('<calendar>'), reason: 'XML should contain opening calendar tag');
      expect(xml, contains('</calendar>'), reason: 'XML should contain closing calendar tag');
      expect(xml, contains('<guid>guid-1</guid>'), reason: 'XML should contain first week GUID');
      expect(xml, contains('<guid>guid-2</guid>'), reason: 'XML should contain second week GUID');
      expect(xml, contains('<notes>First week</notes>'), reason: 'XML should contain week notes');
    });

    test('should handle empty calendar XML generation', () {
      final calendar = Calendar();
      final xml = calendar.toXml();

      expect(xml, equals('<calendar></calendar>'), reason: 'Empty calendar should generate minimal XML');
    });
  });
}
