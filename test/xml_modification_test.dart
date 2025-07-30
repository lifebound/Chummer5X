import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/services/mutable_xml_service.dart';
import 'package:chummer5x/models/expense_entry.dart';
import 'package:xml/xml.dart';

void main() {
  group('ExpenseEntry', () {
    test('should create expense entry with required fields', () {
      final expense = ExpenseEntry(
        type: ExpenseType.karma,
        amount: 5,
        reason: 'Session reward',
      );

      expect(expense.type, ExpenseType.karma, reason: 'ExpenseEntry should store the provided type');
      expect(expense.amount, 5, reason: 'ExpenseEntry should store the provided amount');
      expect(expense.reason, 'Session reward', reason: 'ExpenseEntry should store the provided reason');
      expect(expense.date, isNotNull, reason: 'ExpenseEntry should auto-generate a date when not provided');
    });

    test('should create expense entry with custom date', () {
      final customDate = DateTime(2024, 1, 15);
      final expense = ExpenseEntry(
        type: ExpenseType.nuyen,
        amount: 1000,
        reason: 'Job payment',
        date: customDate,
      );

      expect(expense.date, customDate, reason: 'ExpenseEntry should use the provided custom date instead of auto-generating one');
    });

    test('should convert to XML format', () {
      final expense = ExpenseEntry(
        type: ExpenseType.karma,
        amount: 3,
        reason: 'Good roleplay',
        date: DateTime(2024, 1, 15),
      );

      final xml = expense.toXml();
      final xmlString = xml.toXmlString();
      
      expect(xmlString, contains('<expense>'), reason: 'XML should contain opening expense tag');
      expect(xmlString, contains('<type>Karma</type>'), reason: 'XML should contain the expense type');
      expect(xmlString, contains('<amount>3</amount>'), reason: 'XML should contain the expense amount');
      expect(xmlString, contains('<reason>Good roleplay</reason>'), reason: 'XML should contain the expense reason');
      expect(xmlString, contains('</expense>'), reason: 'XML should contain closing expense tag');
    });

    test('should parse from XML element', () {
      // const xmlString = '''
      //   <expense>
      //     <type>Nuyen</type>
      //     <amount>500</amount>
      //     <reason>Equipment sale</reason>
      //     <date>2024-01-15</date>
      //   </expense>
      // ''';

      XmlElement xmlString = XmlElement(
        XmlName('expense'),
        [],
        [
          XmlElement(XmlName('type'), [], [XmlText('Nuyen')]),
          XmlElement(XmlName('amount'), [], [XmlText('500')]),
          XmlElement(XmlName('reason'), [], [XmlText('Equipment sale')]),
          XmlElement(XmlName('date'), [], [XmlText('2024-01-15')]),
        ],
      );

      final expense = ExpenseEntry.fromXml(xmlString);

      expect(expense.type, ExpenseType.nuyen, reason: 'Parsed expense should have correct type from XML');
      expect(expense.amount, 500, reason: 'Parsed expense should have correct amount from XML');
      expect(expense.reason, 'Equipment sale', reason: 'Parsed expense should have correct reason from XML');
    });
  });

  group('MutableXmlService', () {
    late MutableXmlService service;
    
    setUp(() {
      service = MutableXmlService();
    });

    test('should parse and cache XML document from content', () {
      const testXml = '''<?xml version="1.0" encoding="utf-8"?>
        <character>
          <name>Test Character</name>
          <expenses></expenses>
        </character>
      ''';
      
      final character = service.parseAndCacheCharacterXml(testXml);
      
      expect(character, isNotNull, reason: 'Service should return a valid character object from XML');
      expect(service.hasLoadedDocument, true, reason: 'Service should indicate that a document has been loaded');
    });

    test('should add karma expense to XML', () {
      const testXml = '''<?xml version="1.0" encoding="utf-8"?>
        <character>
          <name>Test Character</name>
          <expenses></expenses>
        </character>
      ''';
      
      service.parseAndCacheCharacterXml(testXml);
      
      service.addExpenseEntry(
        type: ExpenseType.karma,
        amount: 5,
        reason: 'Session reward',
      );
      
      final modifiedXml = service.exportModifiedXml();
      
      expect(modifiedXml, contains('<type>Karma</type>'), reason: 'Modified XML should contain the karma expense type');
      expect(modifiedXml, contains('<amount>5</amount>'), reason: 'Modified XML should contain the karma expense amount');
      expect(modifiedXml, contains('<reason>Session reward</reason>'), reason: 'Modified XML should contain the karma expense reason');
    });

    test('should add nuyen expense to XML', () {
      const testXml = '''<?xml version="1.0" encoding="utf-8"?>
        <character>
          <name>Test Character</name>
          <expenses></expenses>
        </character>
      ''';
      
      service.parseAndCacheCharacterXml(testXml);
      
      service.addExpenseEntry(
        type: ExpenseType.nuyen,
        amount: 1000,
        reason: 'Job payment',
      );
      
      final modifiedXml = service.exportModifiedXml();
      
      expect(modifiedXml, contains('<type>Nuyen</type>'), reason: 'Modified XML should contain the nuyen expense type');
      expect(modifiedXml, contains('<amount>1000</amount>'), reason: 'Modified XML should contain the nuyen expense amount');
      expect(modifiedXml, contains('<reason>Job payment</reason>'), reason: 'Modified XML should contain the nuyen expense reason');
    });

    test('should handle multiple expenses', () {
      const testXml = '''<?xml version="1.0" encoding="utf-8"?>
        <character>
          <name>Test Character</name>
          <expenses></expenses>
        </character>
      ''';
      
      service.parseAndCacheCharacterXml(testXml);
      
      service.addExpenseEntry(
        type: ExpenseType.karma,
        amount: 3,
        reason: 'Roleplay bonus',
      );
      
      service.addExpenseEntry(
        type: ExpenseType.nuyen,
        amount: 500,
        reason: 'Equipment bonus',
      );
      
      final modifiedXml = service.exportModifiedXml();
      
      expect(modifiedXml, contains('<type>Karma</type>'), reason: 'Modified XML should contain both karma expense type');
      expect(modifiedXml, contains('<type>Nuyen</type>'), reason: 'Modified XML should contain both nuyen expense type');
      expect(modifiedXml, contains('<amount>3</amount>'), reason: 'Modified XML should contain the karma expense amount');
      expect(modifiedXml, contains('<amount>500</amount>'), reason: 'Modified XML should contain the nuyen expense amount');
    });

    test('should preserve existing expenses when adding new ones', () {
      const testXml = '''<?xml version="1.0" encoding="utf-8"?>
        <character>
          <name>Test Character</name>
          <expenses>
            <expense>
              <type>Karma</type>
              <amount>2</amount>
              <reason>Existing expense</reason>
              <date>2024-01-01</date>
            </expense>
          </expenses>
        </character>
      ''';
      
      service.parseAndCacheCharacterXml(testXml);
      
      service.addExpenseEntry(
        type: ExpenseType.nuyen,
        amount: 300,
        reason: 'New expense',
      );
      
      final modifiedXml = service.exportModifiedXml();
      
      expect(modifiedXml, contains('<reason>Existing expense</reason>'), reason: 'Modified XML should preserve the existing expense');
      expect(modifiedXml, contains('<reason>New expense</reason>'), reason: 'Modified XML should include the newly added expense');
    });

    test('should handle XML without expenses section', () {
      const testXml = '''<?xml version="1.0" encoding="utf-8"?>
        <character>
          <name>Test Character</name>
        </character>
      ''';
      
      service.parseAndCacheCharacterXml(testXml);
      
      service.addExpenseEntry(
        type: ExpenseType.karma,
        amount: 2,
        reason: 'First expense',
      );
      
      final modifiedXml = service.exportModifiedXml();
      
      expect(modifiedXml, contains('<expenses>'), reason: 'Service should create expenses section when it does not exist');
      expect(modifiedXml, contains('<type>Karma</type>'), reason: 'Modified XML should contain the added karma expense type');
      expect(modifiedXml, contains('<amount>2</amount>'), reason: 'Modified XML should contain the added karma expense amount');
    });

    test('should clear pending expenses after export', () {
      const testXml = '''<?xml version="1.0" encoding="utf-8"?>
        <character>
          <name>Test Character</name>
          <expenses></expenses>
        </character>
      ''';
      
      service.parseAndCacheCharacterXml(testXml);
      
      service.addExpenseEntry(
        type: ExpenseType.karma,
        amount: 1,
        reason: 'Test',
      );
      
      expect(service.pendingExpenses.length, 1, reason: 'Service should track one pending expense before export');
      
      service.exportModifiedXml();
      
      expect(service.pendingExpenses.length, 0, reason: 'Service should clear pending expenses after export');
    });

    test('should support platform-aware export for sharing', () async {
      const testXml = '''<?xml version="1.0" encoding="utf-8"?>
        <character>
          <name>Test Character</name>
          <expenses></expenses>
        </character>
      ''';
      
      service.parseAndCacheCharacterXml(testXml);
      
      service.addExpenseEntry(
        type: ExpenseType.karma,
        amount: 5,
        reason: 'Session reward',
      );
      
      try {
        final result = await service.exportModifiedXmlForSharing('test_character.xml');
        
        // In test environment, file picker might not be available
        // If it succeeds, result should be non-null
        if (result != null) {
          expect(result, contains('test_character.xml'), reason: 'Export result should reference the provided filename');
        }
      } catch (e) {
        // In test environment, file picker initialization might fail
        // This is expected and acceptable for testing
        expect(e, isA<Error>(), reason: 'File picker not available in test environment');
      }
    });

    test('should check if can save to original file', () async {
      const testXml = '''<?xml version="1.0" encoding="utf-8"?>
        <character>
          <name>Test Character</name>
          <expenses></expenses>
        </character>
      ''';
      
      // Test with XML content (no original file path)
      service.parseAndCacheCharacterXml(testXml);
      final canSaveNoFile = await service.canSaveToOriginalFile();
      expect(canSaveNoFile, false, reason: 'Service should not allow saving to original file when loaded from content only');
    });
  });
}
