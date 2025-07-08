import 'dart:io';
import 'package:xml/xml.dart';
import '../models/shadowrun_character.dart';

class ChumerXmlService {
  /// Parse a Chummer XML file and return a ShadowrunCharacter
  static Future<ShadowrunCharacter?> parseCharacterFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }
      
      final xmlContent = await file.readAsString();
      return parseCharacterXml(xmlContent);
    } catch (e) {
      print('Error parsing character file: $e');
      return null;
    }
  }
  
  /// Parse XML content and return a ShadowrunCharacter
  static ShadowrunCharacter? parseCharacterXml(String xmlContent) {
    try {
      final document = XmlDocument.parse(xmlContent);
      final characterElement = document.findAllElements('character').first;
      
      final characterData = <String, dynamic>{};
      
      // Extract basic character information
      _extractElement(characterElement, 'name', characterData);
      _extractElement(characterElement, 'alias', characterData);
      _extractElement(characterElement, 'metatype', characterData);
      _extractElement(characterElement, 'ethnicity', characterData);
      _extractElement(characterElement, 'age', characterData);
      _extractElement(characterElement, 'sex', characterData);
      _extractElement(characterElement, 'height', characterData);
      _extractElement(characterElement, 'weight', characterData);
      _extractElement(characterElement, 'streetcred', characterData);
      _extractElement(characterElement, 'notoriety', characterData);
      _extractElement(characterElement, 'publicawareness', characterData);
      _extractElement(characterElement, 'karma', characterData);
      _extractElement(characterElement, 'totalkarma', characterData);
      
      // Extract attributes
      final attributesElement = characterElement.findElements('attributes').firstOrNull;
      if (attributesElement != null) {
        for (final attribute in attributesElement.findElements('attribute')) {
          final name = attribute.getAttribute('name')?.toLowerCase();
          final value = attribute.findElements('base').firstOrNull?.innerText ??
                       attribute.findElements('total').firstOrNull?.innerText ??
                       attribute.innerText;
          
          if (name != null) {
            characterData[name] = value;
          }
        }
      }
      
      // Extract derived attributes
      _extractElement(characterElement, 'physicallimit', characterData);
      _extractElement(characterElement, 'mentallimit', characterData);
      _extractElement(characterElement, 'sociallimit', characterData);
      _extractElement(characterElement, 'initiative', characterData);
      _extractElement(characterElement, 'composure', characterData);
      _extractElement(characterElement, 'judgeintentions', characterData);
      _extractElement(characterElement, 'memory', characterData);
      _extractElement(characterElement, 'liftcarry', characterData);
      _extractElement(characterElement, 'movement', characterData);
      
      // Extract condition monitor data
      _extractElement(characterElement, 'physicaldamage', characterData);
      _extractElement(characterElement, 'stundamage', characterData);
      _extractElement(characterElement, 'physicalboxes', characterData);
      _extractElement(characterElement, 'stunboxes', characterData);
      
      return ShadowrunCharacter.fromXml(characterData);
    } catch (e) {
      print('Error parsing XML: $e');
      return null;
    }
  }
  
  /// Helper method to extract element text content
  static void _extractElement(XmlElement parent, String elementName, Map<String, dynamic> data) {
    final element = parent.findElements(elementName).firstOrNull;
    if (element != null) {
      data[elementName] = element.innerText;
    }
  }
  
  /// Validate if a file is a valid Chummer XML file
  static Future<bool> isValidChumerFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return false;
      
      final xmlContent = await file.readAsString();
      final document = XmlDocument.parse(xmlContent);
      
      // Check if it has the expected Chummer structure
      return document.findAllElements('character').isNotEmpty ||
             document.findAllElements('chummer').isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
