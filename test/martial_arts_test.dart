import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/martial_arts.dart';

void main() {
  group('MartialArt Tests', () {
    test('should create MartialArt from XML data', () {
      final xmlData = {
        'name': 'Drunken Boxing',
        'sourceid': '2327a330-3b9c-49a9-a392-8f34579e5bce',
        'guid': 'dc6bff83-7631-413a-80dc-0fe336923c49',
        'source': 'RG',
        'page': '130',
        'cost': '7',
        'isquality': 'False',
        'notes': '',
        'notesColor': 'Chocolate',
      };

      final martialArt = MartialArt.fromXml(xmlData);

      expect(martialArt.name, equals('Drunken Boxing'));
      expect(martialArt.sourceId, equals('2327a330-3b9c-49a9-a392-8f34579e5bce'));
      expect(martialArt.guid, equals('dc6bff83-7631-413a-80dc-0fe336923c49'));
      expect(martialArt.source, equals('RG'));
      expect(martialArt.page, equals('130'));
      expect(martialArt.cost, equals(7));
      expect(martialArt.isQuality, equals(false));
      expect(martialArt.notesColor, equals('Chocolate'));
      expect(martialArt.techniques, isEmpty);
    });

    test('should create MartialArt with techniques from XML data', () {
      final xmlData = {
        'name': 'Drunken Boxing',
        'sourceid': '2327a330-3b9c-49a9-a392-8f34579e5bce',
        'guid': 'dc6bff83-7631-413a-80dc-0fe336923c49',
        'source': 'RG',
        'page': '130',
        'cost': '7',
        'isquality': 'False',
        'martialarttechniques': {
          'martialarttechnique': [
            {
              'sourceid': '256bab6a-236d-4f76-93b1-d1dfe3b6df13',
              'guid': 'accf0df1-357e-4364-9229-d1c4ebe22740',
              'name': 'Karmic Response',
              'notes': '',
              'notesColor': 'Chocolate',
              'source': 'RG',
              'page': '138',
            },
            {
              'sourceid': 'ea44f12a-0280-4d2b-8f1f-dc5006167872',
              'guid': 'b3b1dd7d-6dd2-4810-8983-63b2cc2e23ee',
              'name': 'Two-Headed Snake',
              'notes': '',
              'notesColor': 'Chocolate',
              'source': 'RG',
              'page': '141',
            }
          ]
        }
      };

      final martialArt = MartialArt.fromXml(xmlData);

      expect(martialArt.name, equals('Drunken Boxing'));
      expect(martialArt.techniques, hasLength(2));
      expect(martialArt.techniques[0].name, equals('Karmic Response'));
      expect(martialArt.techniques[0].page, equals('138'));
      expect(martialArt.techniques[1].name, equals('Two-Headed Snake'));
      expect(martialArt.techniques[1].page, equals('141'));
    });

    test('should create MartialArt with single technique from XML data', () {
      final xmlData = {
        'name': 'Test Art',
        'sourceid': 'test-id',
        'guid': 'test-guid',
        'martialarttechniques': {
          'martialarttechnique': {
            'sourceid': 'tech-id',
            'guid': 'tech-guid',
            'name': 'Test Technique',
            'source': 'TEST',
            'page': '100',
          }
        }
      };

      final martialArt = MartialArt.fromXml(xmlData);

      expect(martialArt.techniques, hasLength(1));
      expect(martialArt.techniques[0].name, equals('Test Technique'));
    });
  });

  group('MartialArtTechnique Tests', () {
    test('should create MartialArtTechnique from XML data', () {
      final xmlData = {
        'sourceid': '256bab6a-236d-4f76-93b1-d1dfe3b6df13',
        'guid': 'accf0df1-357e-4364-9229-d1c4ebe22740',
        'name': 'Karmic Response',
        'notes': '',
        'notesColor': 'Chocolate',
        'source': 'RG',
        'page': '138',
      };

      final technique = MartialArtTechnique.fromXml(xmlData);

      expect(technique.sourceId, equals('256bab6a-236d-4f76-93b1-d1dfe3b6df13'));
      expect(technique.guid, equals('accf0df1-357e-4364-9229-d1c4ebe22740'));
      expect(technique.name, equals('Karmic Response'));
      expect(technique.source, equals('RG'));
      expect(technique.page, equals('138'));
      expect(technique.notesColor, equals('Chocolate'));
    });

    test('should handle missing fields gracefully', () {
      final xmlData = {
        'name': 'Basic Technique',
        'sourceid': 'test-id',
        'guid': 'test-guid',
      };

      final technique = MartialArtTechnique.fromXml(xmlData);

      expect(technique.name, equals('Basic Technique'));
      expect(technique.sourceId, equals('test-id'));
      expect(technique.guid, equals('test-guid'));
      expect(technique.notes, equals(''));
      expect(technique.source, equals(''));
      expect(technique.page, equals(''));
      expect(technique.notesColor, equals(''));
    });
  });
}
