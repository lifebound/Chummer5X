import 'package:chummer5x/utils/xml_element_extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/lifestyle.dart';

void main() {
  group('Lifestyle Tests', () {
    late XmlDocument document;
    late XmlElement lifestyleElement1;
    late XmlElement lifestyleElement2;

    setUp(() {
      const xmlString = '''
      <lifestyles>
        <lifestyle>
          <sourceid>559653df-a9af-44e2-9e04-3044c1d1b421</sourceid>
          <guid>1e7c3cdc-e4b1-4aea-aa94-2a4f89897f1f</guid>
          <name></name>
          <cost>0</cost>
          <dice>1</dice>
          <lp>2</lp>
          <baselifestyle>Street</baselifestyle>
          <multiplier>20</multiplier>
          <months>1</months>
          <roommates>0</roommates>
          <percentage>100.0</percentage>
          <area>0</area>
          <comforts>0</comforts>
          <security>0</security>
          <basearea>0</basearea>
          <basecomforts>0</basecomforts>
          <basesecurity>0</basesecurity>
          <maxarea>1</maxarea>
          <maxcomforts>1</maxcomforts>
          <maxsecurity>1</maxsecurity>
          <costforearea>0</costforearea>
          <costforcomforts>50</costforcomforts>
          <costforsecurity>50</costforsecurity>
          <allowbonuslp>False</allowbonuslp>
          <bonuslp>0</bonuslp>
          <source>SR5</source>
          <page>369</page>
          <trustfund>False</trustfund>
          <splitcostwithroommates>True</splitcostwithroommates>
          <type>Standard</type>
          <increment>Month</increment>
          <city></city>
          <district></district>
          <borough></borough>
          <lifestylequalities>
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
          </lifestylequalities>
          <notes></notes>
          <notesColor>Chocolate</notesColor>
          <sortorder>0</sortorder>
        </lifestyle>
        <lifestyle>
          <sourceid>451eef87-d18e-4bee-a972-1ee165b08522</sourceid>
          <guid>a1e2609c-6f9c-4cc7-a046-bcfcfb10d225</guid>
          <name>Low</name>
          <cost>2000</cost>
          <dice>3</dice>
          <lp>3</lp>
          <baselifestyle>Low</baselifestyle>
          <multiplier>60</multiplier>
          <months>3</months>
          <roommates>0</roommates>
          <percentage>100.0</percentage>
          <area>0</area>
          <comforts>0</comforts>
          <security>0</security>
          <basearea>2</basearea>
          <basecomforts>2</basecomforts>
          <basesecurity>2</basesecurity>
          <maxarea>3</maxarea>
          <maxcomforts>3</maxcomforts>
          <maxsecurity>3</maxsecurity>
          <costforearea>0</costforearea>
          <costforcomforts>0</costforcomforts>
          <costforsecurity>0</costforsecurity>
          <allowbonuslp>False</allowbonuslp>
          <bonuslp>0</bonuslp>
          <source>SR5</source>
          <page>369</page>
          <trustfund>False</trustfund>
          <splitcostwithroommates>False</splitcostwithroommates>
          <type>Standard</type>
          <increment>Month</increment>
          <city>Seattle</city>
          <district>Bellevue</district>
          <borough>Cyde Hill</borough>
          <lifestylequalities></lifestylequalities>
          <notes></notes>
          <notesColor>Chocolate</notesColor>
          <sortorder>0</sortorder>
        </lifestyle>
      </lifestyles>
      ''';

      document = XmlDocument.parse(xmlString);
      final lifestyles = document.findAllElements('lifestyle').toList();
      lifestyleElement1 = lifestyles[0];
      lifestyleElement2 = lifestyles[1];
    });

    test('should parse Street lifestyle with lifestyle quality correctly', () {
      final lifestyle = Lifestyle.fromXml(lifestyleElement1);

      expect(lifestyle.sourceId, equals('559653df-a9af-44e2-9e04-3044c1d1b421'), 
          reason: 'Street lifestyle should have correct source ID');
      expect(lifestyle.guid, equals('1e7c3cdc-e4b1-4aea-aa94-2a4f89897f1f'), 
          reason: 'Street lifestyle should have correct GUID');
      expect(lifestyle.name, equals(''), 
          reason: 'Street lifestyle should have empty name as provided in XML');
      expect(lifestyle.cost, equals(0), 
          reason: 'Street lifestyle should have zero cost');
      expect(lifestyle.dice, equals(1), 
          reason: 'Street lifestyle should have 1 dice');
      expect(lifestyle.lp, equals(2), 
          reason: 'Street lifestyle should have 2 lifestyle points');
      expect(lifestyle.baseLifestyle, equals('Street'), 
          reason: 'Street lifestyle should have Street base lifestyle');
      expect(lifestyle.multiplier, equals(20), 
          reason: 'Street lifestyle should have 20 multiplier');
      expect(lifestyle.months, equals(1), 
          reason: 'Street lifestyle should have 1 month duration');
      expect(lifestyle.roommates, equals(0), 
          reason: 'Street lifestyle should have 0 roommates');
      expect(lifestyle.percentage, equals(100.0), 
          reason: 'Street lifestyle should have 100% percentage');
    });

    test('should parse lifestyle area, comfort, and security attributes correctly', () {
      final lifestyle = Lifestyle.fromXml(lifestyleElement1);

      expect(lifestyle.area, equals(0), 
          reason: 'Street lifestyle should have 0 area');
      expect(lifestyle.comforts, equals(0), 
          reason: 'Street lifestyle should have 0 comforts');
      expect(lifestyle.security, equals(0), 
          reason: 'Street lifestyle should have 0 security');
      expect(lifestyle.baseArea, equals(0), 
          reason: 'Street lifestyle should have 0 base area');
      expect(lifestyle.baseComforts, equals(0), 
          reason: 'Street lifestyle should have 0 base comforts');
      expect(lifestyle.baseSecurity, equals(0), 
          reason: 'Street lifestyle should have 0 base security');
      expect(lifestyle.maxArea, equals(1), 
          reason: 'Street lifestyle should have max area of 1');
      expect(lifestyle.maxComforts, equals(1), 
          reason: 'Street lifestyle should have max comforts of 1');
      expect(lifestyle.maxSecurity, equals(1), 
          reason: 'Street lifestyle should have max security of 1');
    });

    test('should parse lifestyle cost modifiers correctly', () {
      final lifestyle = Lifestyle.fromXml(lifestyleElement1);

      expect(lifestyle.costForArea, equals(0), 
          reason: 'Street lifestyle should have 0 cost for area');
      expect(lifestyle.costForComforts, equals(50), 
          reason: 'Street lifestyle should have 50 cost for comforts');
      expect(lifestyle.costForSecurity, equals(50), 
          reason: 'Street lifestyle should have 50 cost for security');
      expect(lifestyle.allowBonusLp, equals(false), 
          reason: 'Street lifestyle should not allow bonus LP');
      expect(lifestyle.bonusLp, equals(0), 
          reason: 'Street lifestyle should have 0 bonus LP');
    });

    test('should parse lifestyle boolean and location attributes correctly', () {
      final lifestyle1 = Lifestyle.fromXml(lifestyleElement1);
      final lifestyle2 = Lifestyle.fromXml(lifestyleElement2);

      expect(lifestyle1.trustFund, equals(false), 
          reason: 'Street lifestyle should not have trust fund');
      expect(lifestyle1.splitCostWithRoommates, equals(true), 
          reason: 'Street lifestyle should split cost with roommates');
      expect(lifestyle1.type, equals('Standard'), 
          reason: 'Street lifestyle should have Standard type');
      expect(lifestyle1.increment, equals('Month'), 
          reason: 'Street lifestyle should have Month increment');
      expect(lifestyle1.city, equals(''), 
          reason: 'Street lifestyle should have empty city');
      expect(lifestyle1.district, equals(''), 
          reason: 'Street lifestyle should have empty district');
      expect(lifestyle1.borough, equals(''), 
          reason: 'Street lifestyle should have empty borough');

      expect(lifestyle2.city, equals('Seattle'), 
          reason: 'Low lifestyle should have Seattle as city');
      expect(lifestyle2.district, equals('Bellevue'), 
          reason: 'Low lifestyle should have Bellevue as district');
      expect(lifestyle2.borough, equals('Cyde Hill'), 
          reason: 'Low lifestyle should have Cyde Hill as borough');
    });

    test('should parse lifestyle source information correctly', () {
      final lifestyle = Lifestyle.fromXml(lifestyleElement1);

      expect(lifestyle.source, equals('SR5'), 
          reason: 'Street lifestyle should have SR5 as source');
      expect(lifestyle.page, equals('369'), 
          reason: 'Street lifestyle should have page 369');
      expect(lifestyle.notes, equals(''), 
          reason: 'Street lifestyle should have empty notes');
      expect(lifestyle.notesColor, equals('Chocolate'), 
          reason: 'Street lifestyle should have Chocolate notes color');
      expect(lifestyle.sortOrder, equals(0), 
          reason: 'Street lifestyle should have sort order 0');
    });

    test('should parse lifestyle qualities correctly', () {
      final lifestyle1 = Lifestyle.fromXml(lifestyleElement1);
      final lifestyle2 = Lifestyle.fromXml(lifestyleElement2);

      expect(lifestyle1.lifestyleQualities, hasLength(1), 
          reason: 'Street lifestyle should have one lifestyle quality');
      expect(lifestyle2.lifestyleQualities, hasLength(0), 
          reason: 'Low lifestyle should have no lifestyle qualities');

      final quality = lifestyle1.lifestyleQualities.first;
      expect(quality.name, equals('Grid Subscription'), 
          reason: 'Lifestyle quality should have correct name');
      expect(quality.category, equals('Entertainment - Asset'), 
          reason: 'Lifestyle quality should have correct category');
      expect(quality.extra, equals('Public Grid'), 
          reason: 'Lifestyle quality should have correct extra information');
      expect(quality.cost, equals(50), 
          reason: 'Lifestyle quality should have correct cost');
    });

    test('should handle Low lifestyle with different values correctly', () {
      final lifestyle = Lifestyle.fromXml(lifestyleElement2);

      expect(lifestyle.name, equals('Low'), 
          reason: 'Low lifestyle should have name "Low"');
      expect(lifestyle.cost, equals(2000), 
          reason: 'Low lifestyle should have cost 2000');
      expect(lifestyle.dice, equals(3), 
          reason: 'Low lifestyle should have 3 dice');
      expect(lifestyle.lp, equals(3), 
          reason: 'Low lifestyle should have 3 lifestyle points');
      expect(lifestyle.baseLifestyle, equals('Low'), 
          reason: 'Low lifestyle should have Low base lifestyle');
      expect(lifestyle.multiplier, equals(60), 
          reason: 'Low lifestyle should have 60 multiplier');
      expect(lifestyle.months, equals(3), 
          reason: 'Low lifestyle should have 3 months duration');
      expect(lifestyle.splitCostWithRoommates, equals(false), 
          reason: 'Low lifestyle should not split cost with roommates');
    });

    test('should handle Low lifestyle area, comfort, and security values', () {
      final lifestyle = Lifestyle.fromXml(lifestyleElement2);

      expect(lifestyle.baseArea, equals(2), 
          reason: 'Low lifestyle should have base area of 2');
      expect(lifestyle.baseComforts, equals(2), 
          reason: 'Low lifestyle should have base comforts of 2');
      expect(lifestyle.baseSecurity, equals(2), 
          reason: 'Low lifestyle should have base security of 2');
      expect(lifestyle.maxArea, equals(3), 
          reason: 'Low lifestyle should have max area of 3');
      expect(lifestyle.maxComforts, equals(3), 
          reason: 'Low lifestyle should have max comforts of 3');
      expect(lifestyle.maxSecurity, equals(3), 
          reason: 'Low lifestyle should have max security of 3');
    });

    test('should parse lifestyle collection from lifestyles element correctly', () {
      final lifestylesElement = document.findElements('lifestyles').first;
      final lifestyles = lifestylesElement.parseList<Lifestyle>(
        collectionTagName: '',
        itemTagName: 'lifestyle',
        fromXml: Lifestyle.fromXml,
      );

      expect(lifestyles, hasLength(2), 
          reason: 'Should parse both lifestyles from the collection');
      expect(lifestyles.first.baseLifestyle, equals('Street'), 
          reason: 'First lifestyle should be Street lifestyle');
      expect(lifestyles.last.baseLifestyle, equals('Low'), 
          reason: 'Second lifestyle should be Low lifestyle');
    });

    test('should calculate total monthly cost correctly for Street lifestyle', () {
      final lifestyle = Lifestyle.fromXml(lifestyleElement1);
      
      // Street lifestyle: base cost 0, multiplier 20%, no improvements, one free quality
      // Expected: (0 + 0 + 0 + 0) * 20% = 0
      expect(lifestyle.totalMonthlyCost, equals(0), 
          reason: 'Street lifestyle with zero base cost should have zero total cost');
    });

    test('should calculate total monthly cost correctly for Low lifestyle', () {
      final lifestyle = Lifestyle.fromXml(lifestyleElement2);
      
      // Low lifestyle: base cost 2000, multiplier 60%, no improvements, no qualities
      // Expected: 2000 * 60% = 1200
      expect(lifestyle.totalMonthlyCost, equals(1200), 
          reason: 'Low lifestyle should calculate total cost with multiplier applied');
    });

    test('should calculate total lifestyle points correctly', () {
      final lifestyle1 = Lifestyle.fromXml(lifestyleElement1);
      final lifestyle2 = Lifestyle.fromXml(lifestyleElement2);
      
      // Street lifestyle: 2 base LP + 0 bonus LP + 1 LP from Grid Subscription quality = 3
      expect(lifestyle1.totalLifestylePoints, equals(3), 
          reason: 'Street lifestyle should include lifestyle quality LP in total');
      
      // Low lifestyle: 3 base LP + 0 bonus LP + 0 LP from qualities = 3
      expect(lifestyle2.totalLifestylePoints, equals(3), 
          reason: 'Low lifestyle should have correct total LP');
    });

    test('should calculate effective area, comforts, and security ratings correctly', () {
      final lifestyle1 = Lifestyle.fromXml(lifestyleElement1);
      final lifestyle2 = Lifestyle.fromXml(lifestyleElement2);
      
      // Street lifestyle: base 0 + improvements 0 = 0 for all
      expect(lifestyle1.effectiveArea, equals(0), 
          reason: 'Street lifestyle should have effective area of 0');
      expect(lifestyle1.effectiveComforts, equals(0), 
          reason: 'Street lifestyle should have effective comforts of 0');
      expect(lifestyle1.effectiveSecurity, equals(0), 
          reason: 'Street lifestyle should have effective security of 0');
      
      // Low lifestyle: base 2 + improvements 0 = 2 for all
      expect(lifestyle2.effectiveArea, equals(2), 
          reason: 'Low lifestyle should have effective area of 2');
      expect(lifestyle2.effectiveComforts, equals(2), 
          reason: 'Low lifestyle should have effective comforts of 2');
      expect(lifestyle2.effectiveSecurity, equals(2), 
          reason: 'Low lifestyle should have effective security of 2');
    });

    test('should handle roommate cost splitting correctly', () {
      // Create a test lifestyle with roommates
      const lifestyleWithRoommatesXml = '''
      <lifestyle>
        <name>Test Roommate Lifestyle</name>
        <cost>1000</cost>
        <baselifestyle>Medium</baselifestyle>
        <multiplier>100</multiplier>
        <months>1</months>
        <roommates>1</roommates>
        <percentage>100.0</percentage>
        <area>0</area>
        <comforts>0</comforts>
        <security>0</security>
        <basearea>0</basearea>
        <basecomforts>0</basecomforts>
        <basesecurity>0</basesecurity>
        <maxarea>1</maxarea>
        <maxcomforts>1</maxcomforts>
        <maxsecurity>1</maxsecurity>
        <costforearea>0</costforearea>
        <costforcomforts>0</costforcomforts>
        <costforsecurity>0</costforsecurity>
        <allowbonuslp>False</allowbonuslp>
        <bonuslp>0</bonuslp>
        <source>SR5</source>
        <page>369</page>
        <trustfund>False</trustfund>
        <splitcostwithroommates>True</splitcostwithroommates>
        <type>Standard</type>
        <increment>Month</increment>
        <dice>2</dice>
        <lp>3</lp>
        <sourceid>test-id</sourceid>
        <guid>test-guid</guid>
        <city></city>
        <district></district>
        <borough></borough>
        <lifestylequalities></lifestylequalities>
        <notes></notes>
        <notesColor>Black</notesColor>
        <sortorder>0</sortorder>
      </lifestyle>
      ''';
      
      final doc = XmlDocument.parse(lifestyleWithRoommatesXml);
      final element = doc.findElements('lifestyle').first;
      final lifestyle = Lifestyle.fromXml(element);
      
      // Cost 1000, split with 1 roommate (2 people total) = 500
      expect(lifestyle.totalMonthlyCost, equals(500), 
          reason: 'Lifestyle cost should be split evenly with roommates');
    });
  });
}
