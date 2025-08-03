import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/utils/xml_element_extensions.dart';
import 'package:chummer5x/models/items/gear.dart';

void main() {
  group('XmlElementExtensions.parseList', () {
    test('parses a list of Gear from XML', () {
      // Example XML with a <gears> collection and multiple <gear> items
      final xmlString = '''
        <character>
        <gears>
          <gear>
            <name>Medkit</name>
            <category>Tools</category>
            <source>Core</source>
            <page>123</page>
            <rating>2</rating>
            <avail>4</avail>
            <cost>100</cost>
          </gear>
          <gear>
            <name>Commlink</name>
            <category>Commlinks</category>
            <source>Core</source>
            <page>124</page>
            <rating>1</rating>
            <avail>2</avail>
            <cost>500</cost>
          </gear>
        </gears>
        </character>
      ''';
      final document = XmlDocument.parse(xmlString);
      final gearsElement = document.rootElement;
      final gears = gearsElement.parseList<Gear>(
        collectionTagName: 'gears',
        itemTagName: 'gear',
        fromXml: Gear.fromXml,
      );
      expect(gears.length, 2, reason: 'Should parse two gear items from XML');
      expect(gears[0].name, 'Medkit',
          reason: 'First gear name should be Medkit');
      expect(gears[1].category, 'Commlinks',
          reason: 'Second gear category should be Commlinks');
    });

    test('returns empty list if collection is missing', () {
      final xmlString = '<root></root>';
      final document = XmlDocument.parse(xmlString);
      final root = document.rootElement;
      final gears = root.parseList<Gear>(
        collectionTagName: 'gears',
        itemTagName: 'gear',
        fromXml: Gear.fromXml,
      );
      expect(gears, isEmpty,
          reason: 'Should return empty list if collection tag is missing');
    });
  });
}
