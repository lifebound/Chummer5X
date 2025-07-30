import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/services/enhanced_chumer_xml_service.dart';

void main() {
  group('Contact XML Parsing Tests', () {
    test('should parse contact with full XML structure correctly', () {
      // Given: Sample XML character data with complete contact information
      const xmlData = '''
        <character>
          <name>Test Character</name>
          <metatype>Human</metatype>
          <attributes>
            <attribute name="BOD" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="AGI" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="REA" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="STR" totalvalue="2" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="CHA" totalvalue="5" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="INT" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="LOG" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="WIL" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="EDG" totalvalue="2" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
          </attributes>
          <skills>
            <skill>
              <name>Pistols</name>
              <total>4</total>
            </skill>
          </skills>
          <contacts>
            <contact>
              <name>Marcus Johnson</name>
              <connection>4</connection>
              <loyalty>3</loyalty>
              <type>Street Contact</type>
              <preferredpayment>Credstick</preferredpayment>
              <hobbiesvice>Classic Cars</hobbiesvice>
              <personallife>Single Father</personallife>
              <location>Downtown Seattle</location>
              <archetype>Fixer</archetype>
              <sex>Male</sex>
              <age>Mid-30s</age>
              <contacttype>Contact</contacttype>
              <notes>Reliable fixer with connections to the automotive underworld. Prefers jobs involving vehicle theft or smuggling.</notes>
            </contact>
            <contact>
              <name>Dr. Sarah Chen</name>
              <connection>2</connection>
              <loyalty>5</loyalty>
              <type>Professional Contact</type>
              <preferredpayment>Nuyen</preferredpayment>
              <hobbiesvice>Medical Research</hobbiesvice>
              <personallife>Workaholic</personallife>
              <location>University District</location>
              <archetype>Street Doc</archetype>
              <sex>Female</sex>
              <age>Late 20s</age>
              <contacttype>Contact</contacttype>
              <notes>Brilliant young doctor who patches up shadowrunners. Very loyal but has limited connections.</notes>
            </contact>
          </contacts>
        </character>
      ''';

      // When: Parse the XML character data
      final character = EnhancedChummerXmlService.parseCharacterXml(xmlData);

      // Then: Character should be parsed successfully with contacts
      expect(character, isNotNull, reason: 'Character should be parsed successfully from XML');
      expect(character!.contacts, isNotEmpty, reason: 'Character should have contacts parsed from XML');
      expect(character.contacts.length, equals(2), reason: 'Character should have exactly 2 contacts from XML');

      // Verify first contact details
      final firstContact = character.contacts[0];
      expect(firstContact.name, equals('Marcus Johnson'), reason: 'First contact name should match XML data');
      expect(firstContact.connection, equals(4), reason: 'First contact connection should be 4');
      expect(firstContact.loyalty, equals(3), reason: 'First contact loyalty should be 3');
      expect(firstContact.type, equals('Street Contact'), reason: 'First contact type should match XML data');
      expect(firstContact.preferredpayment, equals('Credstick'), reason: 'First contact preferred payment should match XML data');
      expect(firstContact.hobbiesvice, equals('Classic Cars'), reason: 'First contact hobbies/vice should match XML data');
      expect(firstContact.personallife, equals('Single Father'), reason: 'First contact personal life should match XML data');
      expect(firstContact.location, equals('Downtown Seattle'), reason: 'First contact location should match XML data');
      expect(firstContact.role, equals('Fixer'), reason: 'First contact archetype should match XML data');
      expect(firstContact.gender, equals('Male'), reason: 'First contact sex should match XML data');
      expect(firstContact.age, equals('Mid-30s'), reason: 'First contact age should match XML data');
      expect(firstContact.contacttype, equals('Contact'), reason: 'First contact type should match XML data');
      expect(firstContact.notes, contains('Reliable fixer'), reason: 'First contact notes should match XML data');

      // Verify second contact details
      final secondContact = character.contacts[1];
      expect(secondContact.name, equals('Dr. Sarah Chen'), reason: 'Second contact name should match XML data');
      expect(secondContact.connection, equals(2), reason: 'Second contact connection should be 2');
      expect(secondContact.loyalty, equals(5), reason: 'Second contact loyalty should be 5');
      expect(secondContact.type, equals('Professional Contact'), reason: 'Second contact type should match XML data');
      expect(secondContact.role, equals('Street Doc'), reason: 'Second contact archetype should match XML data');
      expect(secondContact.gender, equals('Female'), reason: 'Second contact sex should match XML data');
      expect(secondContact.notes, contains('Brilliant young doctor'), reason: 'Second contact notes should match XML data');
    });

    test('should handle character with no contacts gracefully', () {
      // Given: Sample XML character data without contacts section
      const xmlData = '''
        <character>
          <name>Test Character</name>
          <metatype>Human</metatype>
          <attributes>
            <attribute name="BOD" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="AGI" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="REA" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="STR" totalvalue="2" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="CHA" totalvalue="5" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="INT" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="LOG" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="WIL" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="EDG" totalvalue="2" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
          </attributes>
          <skills>
            <skill>
              <name>Pistols</name>
              <total>4</total>
            </skill>
          </skills>
        </character>
      ''';

      // When: Parse the XML character data
      final character = EnhancedChummerXmlService.parseCharacterXml(xmlData);

      // Then: Character should be parsed successfully with empty contacts list
      expect(character, isNotNull, reason: 'Character should be parsed successfully even without contacts');
      expect(character!.contacts, isEmpty, reason: 'Character should have empty contacts list when no contacts in XML');
    });

    test('should handle character with empty contacts section gracefully', () {
      // Given: Sample XML character data with empty contacts section
      const xmlData = '''
        <character>
          <name>Test Character</name>
          <metatype>Human</metatype>
          <attributes>
            <attribute name="BOD" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="AGI" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="REA" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="STR" totalvalue="2" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="CHA" totalvalue="5" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="INT" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="LOG" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="WIL" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="EDG" totalvalue="2" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
          </attributes>
          <skills>
            <skill>
              <name>Pistols</name>
              <total>4</total>
            </skill>
          </skills>
          <contacts>
          </contacts>
        </character>
      ''';

      // When: Parse the XML character data
      final character = EnhancedChummerXmlService.parseCharacterXml(xmlData);

      // Then: Character should be parsed successfully with empty contacts list
      expect(character, isNotNull, reason: 'Character should be parsed successfully with empty contacts section');
      expect(character!.contacts, isEmpty, reason: 'Character should have empty contacts list when contacts section is empty');
    });

    test('should parse contact with minimal required XML fields', () {
      // Given: Sample XML character data with minimal contact information
      const xmlData = '''
        <character>
          <name>Test Character</name>
          <metatype>Human</metatype>
          <attributes>
            <attribute name="BOD" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="AGI" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="REA" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="STR" totalvalue="2" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="CHA" totalvalue="5" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="INT" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="LOG" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="WIL" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="EDG" totalvalue="2" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
          </attributes>
          <skills>
            <skill>
              <name>Pistols</name>
              <total>4</total>
            </skill>
          </skills>
          <contacts>
            <contact>
              <name>Basic Contact</name>
              <connection>2</connection>
              <loyalty>1</loyalty>
            </contact>
          </contacts>
        </character>
      ''';

      // When: Parse the XML character data
      final character = EnhancedChummerXmlService.parseCharacterXml(xmlData);

      // Then: Character should be parsed successfully with minimal contact
      expect(character, isNotNull, reason: 'Character should be parsed successfully with minimal contact data');
      expect(character!.contacts, hasLength(1), reason: 'Character should have one contact from minimal XML data');

      // Verify contact with minimal data
      final contact = character.contacts[0];
      expect(contact.name, equals('Basic Contact'), reason: 'Contact name should match XML data');
      expect(contact.connection, equals(2), reason: 'Contact connection should be 2');
      expect(contact.loyalty, equals(1), reason: 'Contact loyalty should be 1');
      
      // Optional fields should have default values
      expect(contact.type, isEmpty, reason: 'Contact type should be empty when not provided in XML');
      expect(contact.preferredpayment, isEmpty, reason: 'Contact preferred payment should be empty when not provided');
      expect(contact.hobbiesvice, isEmpty, reason: 'Contact hobbies/vice should be empty when not provided');
      expect(contact.personallife, isEmpty, reason: 'Contact personal life should be empty when not provided');
      expect(contact.location, isEmpty, reason: 'Contact location should be empty when not provided');
      expect(contact.role, isEmpty, reason: 'Contact role should be empty when not provided');
      expect(contact.gender, isEmpty, reason: 'Contact gender should be empty when not provided');
      expect(contact.age, isEmpty, reason: 'Contact age should be empty when not provided');
      expect(contact.contacttype, isEmpty, reason: 'Contact type should be empty when not provided');
      expect(contact.notes, isEmpty, reason: 'Contact notes should be empty when not provided');
    });

    test('should validate contact display properties', () {
      // Given: Sample XML character data with contact for display testing
      const xmlData = '''
        <character>
          <name>Test Character</name>
          <metatype>Human</metatype>
          <attributes>
            <attribute name="BOD" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="AGI" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="REA" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="STR" totalvalue="2" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="CHA" totalvalue="5" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="INT" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="LOG" totalvalue="4" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="WIL" totalvalue="3" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
            <attribute name="EDG" totalvalue="2" metatypemin="1" metatypemax="6" metatypeaugmax="9" />
          </attributes>
          <skills>
            <skill>
              <name>Pistols</name>
              <total>4</total>
            </skill>
          </skills>
          <contacts>
            <contact>
              <name>Test Contact</name>
              <connection>3</connection>
              <loyalty>4</loyalty>
              <archetype>Street Samurai</archetype>
              <location>Redmond Barrens</location>
            </contact>
          </contacts>
        </character>
      ''';

      // When: Parse the XML character data
      final character = EnhancedChummerXmlService.parseCharacterXml(xmlData);

      // Then: Contact should have correct display properties
      expect(character, isNotNull, reason: 'Character should be parsed successfully');
      final contact = character!.contacts[0];
      
      expect(contact.name, equals('Test Contact'), reason: 'Contact name should match the name field');
      expect(contact.description, equals('Street Samurai - Redmond Barrens'), reason: 'Contact description should format role and location correctly');
      expect(contact.totalRating, equals(7), reason: 'Contact total rating should be connection + loyalty (3 + 4)');
      expect(contact.hasData, isTrue, reason: 'Contact should indicate it has meaningful data');
    });
  });
}
