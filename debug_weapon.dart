import 'package:xml/xml.dart';
import 'lib/models/items/weapon.dart';

void main() {
  final xmlString = '''
    <weapon>
      <sourceid>test-source</sourceid>
      <guid>test-guid</guid>
      <name>Advanced Weapon</name>
      <category>Assault Rifles</category>
      <type>Ranged</type>
      <spec>Assault Rifle</spec>
      <spec2>Military</spec2>
      <reach>1</reach>
      <damage>10P</damage>
      <ap>-2</ap>
      <mode>SA/BF/FA</mode>
      <rc>2</rc>
      <ammo>30(c)</ammo>
      <cyberware>False</cyberware>
      <ammocategory>Standard</ammocategory>
      <ammoslots>2</ammoslots>
      <sizecategory>Medium</sizecategory>
      <firingmode>FA</firingmode>
      <minrating>1</minrating>
      <maxrating>6</maxrating>
      <rating>4</rating>
      <accuracy>6</accuracy>
      <activeammoslot>2</activeammoslot>
      <conceal>-2</conceal>
      <cost>8500</cost>
      <weight>4.5</weight>
      <useskill>Automatics</useskill>
      <useskillspec>Assault Rifles</useskillspec>
      <range>150/350/550/750</range>
      <alternaterange>75/175/350/550</alternaterange>
      <rangemultiply>2</rangemultiply>
      <singleshot>1</singleshot>
      <shortburst>3</shortburst>
      <longburst>6</longburst>
      <fullburst>10</fullburst>
      <suppressive>20</suppressive>
      <allowsingleshot>True</allowsingleshot>
      <allowshortburst>True</allowshortburst>
      <allowlongburst>True</allowlongburst>
      <allowfullburst>True</allowfullburst>
      <allowsuppressive>True</allowsuppressive>
      <parentid>parent-123</parentid>
      <allowaccessory>True</allowaccessory>
      <weaponname>My Weapon</weaponname>
      <included>True</included>
      <requireammo>True</requireammo>
      <mount>External</mount>
      <extramount>Barrel</extramount>
      <location>Holster</location>
      <weapontype>Firearm</weapontype>
      <source>Run &amp; Gun</source>
      <page>123</page>
      <avail>12F</avail>
      <equipped>True</equipped>
      <active>True</active>
      <homenode>True</homenode>
      <wirelesson>True</wirelesson>
      <stolen>True</stolen>
      <devicerating>3</devicerating>
      <notes>Test weapon</notes>
      <notesColor>blue</notesColor>
      <discountedcost>True</discountedcost>
      <sortorder>5</sortorder>
    </weapon>
  ''';
  final xmlElement = XmlDocument.parse(xmlString).rootElement;
  final weapon = Weapon.fromXml(xmlElement);
  
  print('Parsed weapon:');
  print('name: ${weapon.name}');
  print('avail: "${weapon.avail}"');
  print('source: "${weapon.source}"'); 
  print('page: "${weapon.page}"');
  print('deviceRating: "${weapon.deviceRating}"');
  print('equipped: ${weapon.equipped}');
  print('active: ${weapon.active}');
  print('homeNode: ${weapon.homeNode}');
  print('wirelessOn: ${weapon.wirelessOn}');
  print('stolen: ${weapon.stolen}');
  print('notes: "${weapon.notes}"');
  print('notesColor: "${weapon.notesColor}"');
  print('discountedCost: ${weapon.discountedCost}');
  print('sortOrder: ${weapon.sortOrder}');
}
