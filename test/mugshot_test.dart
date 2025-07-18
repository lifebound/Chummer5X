import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/mugshot.dart';
import 'package:chummer5x/services/enhanced_chumer_xml_service.dart';

void main() {
  group('Mugshot Feature Tests', () {
    test('should parse mugshot from base64 data', () {
      // Simple 1x1 pixel PNG in base64
      const base64Png = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChAFAtlUinwAAAABJRU5ErkJggg==';
      
      final mugshot = Mugshot.fromBase64(base64Png);
      
      expect(mugshot, isNotNull);
      expect(mugshot.imageData.isNotEmpty, true);
      expect(mugshot.mimeType, 'image/png');
      expect(mugshot.isAnimated, false);
    });

    test('should handle invalid base64 data gracefully', () {
      const invalidBase64 = 'invalid_base64_data!!!';
      
      expect(() => Mugshot.fromBase64(invalidBase64), throwsA(isA<ArgumentError>()));
    });

    test('should parse XML with mugshots element', () {
      const xmlWithMugshot = '''
        <character>
          <name>Test Character</name>
          <mugshots>
            <mugshot>iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChAFAtlUinwAAAABJRU5ErkJggg==</mugshot>
          </mugshots>
        </character>
      ''';
      
      final character = EnhancedChummerXmlService.parseCharacterXml(xmlWithMugshot);
      
      expect(character, isNotNull);
      expect(character!.mugshot, isNotNull);
      expect(character.mugshot!.mimeType, 'image/png');
    });

    test('should handle XML without mugshots element', () {
      const xmlWithoutMugshot = '''
        <character>
          <name>Test Character</name>
        </character>
      ''';
      
      final character = EnhancedChummerXmlService.parseCharacterXml(xmlWithoutMugshot);
      
      expect(character, isNotNull);
      expect(character!.mugshot, isNull);
    });

    test('should handle empty mugshots element', () {
      const xmlWithEmptyMugshots = '''
        <character>
          <name>Test Character</name>
          <mugshots>
          </mugshots>
        </character>
      ''';
      
      final character = EnhancedChummerXmlService.parseCharacterXml(xmlWithEmptyMugshots);
      
      expect(character, isNotNull);
      expect(character!.mugshot, isNull);
    });
  });
}
