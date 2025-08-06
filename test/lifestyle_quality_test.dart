import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/lifestyle_quality.dart';

void main() {
  group('LifestyleQuality Tests', () {
    late XmlElement lifestyleQualityElement;

    setUp(() {
      const xmlString = '''
      <lifestylequality>
        <sourceid>adaf6b3d-874a-42e5-b08b-37adf1222f23</sourceid>
        <guid>e92de2a9-e734-459e-ab19-c823df660a37</guid>
        <name>Grid Subscription</name>
        <category>Entertainment - Asset</category>
        <extra>Public Grid</extra>
        <cost>50</cost>
        <multiplier>0</multiplier>
        <basemultiplier>0</basemultiplier>
        <lp>1</lp>
        <areamaximum>0</areamaximum>
        <comfortsmaximum>0</comfortsmaximum>
        <securitymaximum>0</securitymaximum>
        <area>0</area>
        <comforts>0</comforts>
        <security>0</security>
        <uselpcost>True</uselpcost>
        <print>True</print>
        <lifestylequalitytype>Entertainment</lifestylequalitytype>
        <lifestylequalitysource>BuiltIn</lifestylequalitysource>
        <free>True</free>
        <isfreegrid>True</isfreegrid>
        <source>RF</source>
        <page>222</page>
        <allowed>Medium,High,Luxury</allowed>
        <bonus></bonus>
        <notes></notes>
        <notesColor>Chocolate</notesColor>
      </lifestylequality>
      ''';

      final document = XmlDocument.parse(xmlString);
      lifestyleQualityElement = document.findElements('lifestylequality').first;
    });

    test('should parse lifestyle quality basic information correctly', () {
      final quality = LifestyleQuality.fromXml(lifestyleQualityElement);

      expect(quality.sourceId, equals('adaf6b3d-874a-42e5-b08b-37adf1222f23'), 
          reason: 'Lifestyle quality should have correct source ID');
      expect(quality.guid, equals('e92de2a9-e734-459e-ab19-c823df660a37'), 
          reason: 'Lifestyle quality should have correct GUID');
      expect(quality.name, equals('Grid Subscription'), 
          reason: 'Lifestyle quality should have correct name');
      expect(quality.category, equals('Entertainment - Asset'), 
          reason: 'Lifestyle quality should have correct category');
      expect(quality.extra, equals('Public Grid'), 
          reason: 'Lifestyle quality should have correct extra information');
    });

    test('should parse lifestyle quality cost and multiplier information correctly', () {
      final quality = LifestyleQuality.fromXml(lifestyleQualityElement);

      expect(quality.cost, equals(50), 
          reason: 'Lifestyle quality should have correct cost');
      expect(quality.multiplier, equals(0), 
          reason: 'Lifestyle quality should have correct multiplier');
      expect(quality.baseMultiplier, equals(0), 
          reason: 'Lifestyle quality should have correct base multiplier');
      expect(quality.lp, equals(1), 
          reason: 'Lifestyle quality should have correct lifestyle points');
    });

    test('should parse lifestyle quality area, comfort, and security maximums correctly', () {
      final quality = LifestyleQuality.fromXml(lifestyleQualityElement);

      expect(quality.areaMaximum, equals(0), 
          reason: 'Lifestyle quality should have correct area maximum');
      expect(quality.comfortsMaximum, equals(0), 
          reason: 'Lifestyle quality should have correct comforts maximum');
      expect(quality.securityMaximum, equals(0), 
          reason: 'Lifestyle quality should have correct security maximum');
      expect(quality.area, equals(0), 
          reason: 'Lifestyle quality should have correct area value');
      expect(quality.comforts, equals(0), 
          reason: 'Lifestyle quality should have correct comforts value');
      expect(quality.security, equals(0), 
          reason: 'Lifestyle quality should have correct security value');
    });

    test('should parse lifestyle quality boolean flags correctly', () {
      final quality = LifestyleQuality.fromXml(lifestyleQualityElement);

      expect(quality.useLpCost, equals(true), 
          reason: 'Lifestyle quality should have correct use LP cost flag');
      expect(quality.print, equals(true), 
          reason: 'Lifestyle quality should have correct print flag');
      expect(quality.free, equals(true), 
          reason: 'Lifestyle quality should have correct free flag');
      expect(quality.isFreeGrid, equals(true), 
          reason: 'Lifestyle quality should have correct free grid flag');
    });

    test('should parse lifestyle quality type and source information correctly', () {
      final quality = LifestyleQuality.fromXml(lifestyleQualityElement);

      expect(quality.lifestyleQualityType, equals('Entertainment'), 
          reason: 'Lifestyle quality should have correct type');
      expect(quality.lifestyleQualitySource, equals('BuiltIn'), 
          reason: 'Lifestyle quality should have correct source type');
      expect(quality.source, equals('RF'), 
          reason: 'Lifestyle quality should have correct source book');
      expect(quality.page, equals('222'), 
          reason: 'Lifestyle quality should have correct page number');
    });

    test('should parse lifestyle quality allowed and notes information correctly', () {
      final quality = LifestyleQuality.fromXml(lifestyleQualityElement);

      expect(quality.allowed, equals('Medium,High,Luxury'), 
          reason: 'Lifestyle quality should have correct allowed lifestyle types');
      expect(quality.notes, equals(''), 
          reason: 'Lifestyle quality should have empty notes');
      expect(quality.notesColor, equals('Chocolate'), 
          reason: 'Lifestyle quality should have correct notes color');
    });

    test('should handle XML element with missing optional fields gracefully', () {
      const minimalXmlString = '''
      <lifestylequality>
        <name>Basic Quality</name>
        <category>Basic</category>
        <cost>0</cost>
        <source>SR5</source>
        <page>100</page>
      </lifestylequality>
      ''';

      final document = XmlDocument.parse(minimalXmlString);
      final element = document.findElements('lifestylequality').first;
      final quality = LifestyleQuality.fromXml(element);

      expect(quality.name, equals('Basic Quality'), 
          reason: 'Minimal lifestyle quality should have correct name');
      expect(quality.category, equals('Basic'), 
          reason: 'Minimal lifestyle quality should have correct category');
      expect(quality.cost, equals(0), 
          reason: 'Minimal lifestyle quality should have correct cost');
      expect(quality.extra, equals(''), 
          reason: 'Minimal lifestyle quality should have empty extra when not provided');
      expect(quality.multiplier, equals(0), 
          reason: 'Minimal lifestyle quality should have default multiplier of 0');
      expect(quality.lp, equals(0), 
          reason: 'Minimal lifestyle quality should have default LP of 0');
      expect(quality.free, equals(false), 
          reason: 'Minimal lifestyle quality should have default free flag of false');
    });
  });
}
