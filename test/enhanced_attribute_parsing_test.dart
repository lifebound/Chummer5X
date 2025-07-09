import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/services/enhanced_chumer_xml_service.dart';

void main() {
  group('Enhanced Attribute Parsing Tests', () {
    test('should parse all attribute fields from XML', () {
      const xmlContent = '''<?xml version="1.0" encoding="UTF-8"?>
<character>
  <name>Test Character</name>
  <attributes>
    <attribute name="Body">
      <name>Body</name>
      <metatypemin>1</metatypemin>
      <metatypemax>6</metatypemax>
      <metatypeaugmax>9</metatypeaugmax>
      <base>3</base>
      <karma>2</karma>
      <metatypecategory>Physical</metatypecategory>
      <totalvalue>5</totalvalue>
    </attribute>
    <attribute name="Agility">
      <name>Agility</name>
      <metatypemin>1</metatypemin>
      <metatypemax>6</metatypemax>
      <metatypeaugmax>9</metatypeaugmax>
      <base>4</base>
      <karma>1</karma>
      <metatypecategory>Physical</metatypecategory>
      <totalvalue>5</totalvalue>
    </attribute>
  </attributes>
</character>''';

      final character = EnhancedChumerXmlService.parseCharacterXml(xmlContent);
      
      expect(character?.name, equals('Test Character'));
      expect(character?.attributes.length, equals(2));
      
      // Test Body attribute
      final bodyAttribute = character!.attributes.firstWhere((attr) => attr.name == 'Body');
      expect(bodyAttribute.name, equals('Body'));
      expect(bodyAttribute.metatypeCategory, equals('Physical'));
      expect(bodyAttribute.totalValue, equals(5));
      expect(bodyAttribute.metatypeMin, equals(1));
      expect(bodyAttribute.metatypeMax, equals(6));
      expect(bodyAttribute.metatypeAugMax, equals(9));
      expect(bodyAttribute.base, equals(3));
      expect(bodyAttribute.karma, equals(2));
      
      // Test Agility attribute
      final agilityAttribute = character.attributes.firstWhere((attr) => attr.name == 'Agility');
      expect(agilityAttribute.name, equals('Agility'));
      expect(agilityAttribute.metatypeCategory, equals('Physical'));
      expect(agilityAttribute.totalValue, equals(5));
      expect(agilityAttribute.metatypeMin, equals(1));
      expect(agilityAttribute.metatypeMax, equals(6));
      expect(agilityAttribute.metatypeAugMax, equals(9));
      expect(agilityAttribute.base, equals(4));
      expect(agilityAttribute.karma, equals(1));
    });

    test('should handle missing attribute fields gracefully', () {
      const xmlContent = '''<?xml version="1.0" encoding="UTF-8"?>
<character>
  <name>Minimal Character</name>
  <attributes>
    <attribute name="Body">
      <name>Body</name>
      <totalvalue>3</totalvalue>
    </attribute>
  </attributes>
</character>''';

      final character = EnhancedChumerXmlService.parseCharacterXml(xmlContent);
      
      expect(character?.name, equals('Minimal Character'));
      expect(character?.attributes.length, equals(1));
      
      final bodyAttribute = character!.attributes.first;
      expect(bodyAttribute.name, equals('Body'));
      expect(bodyAttribute.totalValue, equals(3));
      expect(bodyAttribute.metatypeMin, equals(0)); // Default values
      expect(bodyAttribute.metatypeMax, equals(0));
      expect(bodyAttribute.metatypeAugMax, equals(0));
      expect(bodyAttribute.base, equals(0));
      expect(bodyAttribute.karma, equals(0));
    });
  });
}
