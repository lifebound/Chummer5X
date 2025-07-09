import 'dart:io';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import '../models/shadowrun_character.dart';

class EnhancedChumerXmlService {
  /// Parse a Chummer XML file and return a comprehensive ShadowrunCharacter
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
  
  /// Parse XML content and return a comprehensive ShadowrunCharacter
  static ShadowrunCharacter? parseCharacterXml(String xmlContent) {
    try {
      final document = XmlDocument.parse(xmlContent);
      final characterElement = document.findAllElements('character').first;
      
      // Basic character information
      final name = _getElementText(characterElement, 'alias') ?? _getElementText(characterElement, 'name');
      final metatype = _getElementText(characterElement, 'metatype');
      final ethnicity = _getElementText(characterElement, 'ethnicity');
      final age = _getElementText(characterElement, 'age');
      final sex = _getElementText(characterElement, 'sex');
      final height = _getElementText(characterElement, 'height');
      final weight = _getElementText(characterElement, 'weight');
      final streetCred = _getElementText(characterElement, 'streetcred');
      final notoriety = _getElementText(characterElement, 'notoriety');
      final publicAwareness = _getElementText(characterElement, 'publicawareness');
      final karma = _getElementText(characterElement, 'karma');
      final totalKarma = _getElementText(characterElement, 'totalkarma');
      final nuyen = int.tryParse(_getElementText(characterElement, 'nuyen') ?? '0') ?? 0;
      
      // Parse calculated values
      final calculatedValues = _parseCalculatedValues(characterElement);
      
      // Parse attributes
      final attributes = _parseAttributes(characterElement);
      
      // Parse skill groups
      final skillGroups = _parseSkillGroups(characterElement);
      
      // Parse skills
      final skills = _parseSkills(characterElement, skillGroups);
      
      // Calculate and parse limits
      final limits = _calculateLimits(attributes, characterElement);
      
      // Parse magic/resonance content
      final spells = _parseSpells(characterElement);
      final spirits = _parseSpirits(characterElement);
      final complexForms = _parseComplexForms(characterElement);
      final adeptPowers = _parseAdeptPowers(characterElement);
      
      // Parse gear
      final gear = _parseGear(characterElement);
      
      // Parse condition monitor
      final conditionMonitor = _parseConditionMonitor(characterElement, calculatedValues);
      
      // Parse enabled flags
      final magEnabled = _getElementText(characterElement, 'magenabled')?.toLowerCase() == 'true';
      final resEnabled = _getElementText(characterElement, 'resenabled')?.toLowerCase() == 'true';  
      final depEnabled = _getElementText(characterElement, 'depenabled')?.toLowerCase() == 'true';
      
      return ShadowrunCharacter(
        name: name,
        alias: name, // In Chummer, alias is often the main name
        metatype: metatype,
        ethnicity: ethnicity,
        age: age,
        sex: sex,
        height: height,
        weight: weight,
        streetCred: streetCred,
        notoriety: notoriety,
        publicAwareness: publicAwareness,
        karma: karma,
        totalKarma: totalKarma,
        attributes: attributes,
        skills: skills,
        limits: limits,
        spells: spells,
        spirits: spirits,
        complexForms: complexForms,
        adeptPowers: adeptPowers,
        gear: gear,
        conditionMonitor: conditionMonitor,
        nuyen: nuyen,
        magEnabled: magEnabled,
        resEnabled: resEnabled,
        depEnabled: depEnabled,
      );
    } catch (e) {
      print('Error parsing XML: $e');
      return null;
    }
  }
  
  static String? _getElementText(XmlElement parent, String elementName) {
    final element = parent.findElements(elementName).firstOrNull;
    return element?.innerText;
  }
  
  static List<Attribute> _parseAttributes(XmlElement characterElement) {
    final attributes = <Attribute>[];
    final attributesElement = characterElement.findElements('attributes').firstOrNull;
    
    if (attributesElement != null) {
      final attributeElements = attributesElement.findElements('attribute');
      
      for (final attributeElement in attributeElements) {
        // Try to get name from attribute first, then from child element
        final nameFromAttribute = attributeElement.getAttribute('name');
        final nameFromElement = _getElementText(attributeElement, 'name');
        final name = nameFromAttribute ?? nameFromElement;
        
        if (name != null) {
          // Parse all the fields from the XML
          final metatypeCategory = _getElementText(attributeElement, 'metatypecategory') ?? '';
          final totalValue = int.tryParse(_getElementText(attributeElement, 'totalvalue') ?? '0') ?? 0;
          final metatypeMin = int.tryParse(_getElementText(attributeElement, 'metatypemin') ?? '0') ?? 0;
          final metatypeMax = int.tryParse(_getElementText(attributeElement, 'metatypemax') ?? '0') ?? 0;
          final metatypeAugMax = int.tryParse(_getElementText(attributeElement, 'metatypeaugmax') ?? '0') ?? 0;
          final base = int.tryParse(_getElementText(attributeElement, 'base') ?? '0') ?? 0;
          final karma = int.tryParse(_getElementText(attributeElement, 'karma') ?? '0') ?? 0;
          
          attributes.add(Attribute(
            name: name,
            metatypeCategory: metatypeCategory,
            totalValue: totalValue,
            metatypeMin: metatypeMin,
            metatypeMax: metatypeMax,
            metatypeAugMax: metatypeAugMax,
            base: base,
            karma: karma,
          ));
        }
      }
    }
    
    return attributes;
  }
  
  static List<SkillGroup> _parseSkillGroups(XmlElement characterElement) {
    final skillGroups = <SkillGroup>[];
    final skillsElement = characterElement.findElements('newskills').firstOrNull;
    
    if (skillsElement != null) {
      final groupsElement = skillsElement.findElements('groups').firstOrNull;
      if (groupsElement != null) {
        for (final groupElement in groupsElement.findElements('group')) {
          final name = _getElementText(groupElement, 'name');
          final base = _getElementText(groupElement, 'base');
          final karma = _getElementText(groupElement, 'karma');
          
          if (name != null) {
            skillGroups.add(SkillGroup(
              name: name,
              base: base,
              karma: karma,
            ));
          }
        }
      }
    }
    
    return skillGroups;
  }
  
  static List<Skill> _parseSkills(XmlElement characterElement, List<SkillGroup> skillGroups) {
    final skills = <Skill>[];
    final skillsElement = characterElement.findElements('newskills').firstOrNull;
    
    if (skillsElement != null) {
      final skillsListElement = skillsElement.findElements('skills').firstOrNull;
      if (skillsListElement != null) {
        for (final skillElement in skillsListElement.findElements('skill')) {
          final name = _getElementText(skillElement, 'name');
          final karma = _getElementText(skillElement, 'karma');
          final base = _getElementText(skillElement, 'base');
          
          if (name != null) {
            // Find matching skill group
            final skillGroupName = ''; // Would need skill group mapping
            final skillGroupTotal = 0;
            
            skills.add(Skill(
              name: name,
              karma: karma,
              base: base,
              skillGroupName: skillGroupName,
              skillGroupTotal: skillGroupTotal,
            ));
          }
        }
      }
    }
    
    return skills;
  }
  
  static Map<String, LimitDetail> _calculateLimits(List<Attribute> attributes, XmlElement characterElement) {
    final limits = <String, LimitDetail>{};
    
    // Calculate basic limits from attributes
    int getAttributeValue(String name) {
      return attributes.firstWhere(
        (attr) => attr.name.toLowerCase() == name.toLowerCase(),
        orElse: () => const Attribute(
          name: '', 
          metatypeCategory: '', 
          totalValue: 1,
          metatypeMin: 1,
          metatypeMax: 6,
          metatypeAugMax: 9,
          base: 1,
          karma: 0,
        ),
      ).totalValue;
    }
    
    final physicalLimit = ((getAttributeValue('Strength') * 2) + getAttributeValue('Body') + getAttributeValue('Reaction')) ~/ 3;
    final mentalLimit = ((getAttributeValue('Logic') * 2) + getAttributeValue('Intuition') + getAttributeValue('Willpower')) ~/ 3;
    final socialLimit = ((getAttributeValue('Charisma') * 2) + getAttributeValue('Willpower') + getAttributeValue('Essence')) ~/ 3;
    
    limits['Physical'] = LimitDetail(total: physicalLimit, modifiers: []);
    limits['Mental'] = LimitDetail(total: mentalLimit, modifiers: []);
    limits['Social'] = LimitDetail(total: socialLimit, modifiers: []);
    limits['Astral'] = LimitDetail(
      total: mentalLimit > socialLimit ? mentalLimit : socialLimit,
      modifiers: [],
    );
    
    return limits;
  }
  
  static List<Spell> _parseSpells(XmlElement characterElement) {
    final spells = <Spell>[];
    final spellsElement = characterElement.findElements('spells').firstOrNull;
    
    if (spellsElement != null) {
      for (final spellElement in spellsElement.findElements('spell')) {
        final name = _getElementText(spellElement, 'name');
        final category = _getElementText(spellElement, 'category');
        final improvementSource = _getElementText(spellElement, 'improvementsource');
        final grade = _getElementText(spellElement, 'grade');
        
        if (name != null && category != null) {
          spells.add(Spell(
            name: name,
            category: category,
            improvementSource: improvementSource,
            grade: grade,
          ));
        }
      }
    }
    
    return spells;
  }
  
  static List<Spirit> _parseSpirits(XmlElement characterElement) {
    final spirits = <Spirit>[];
    final spiritsElement = characterElement.findElements('spirits').firstOrNull;
    
    if (spiritsElement != null) {
      for (final spiritElement in spiritsElement.findElements('spirit')) {
        final name = _getElementText(spiritElement, 'name');
        final type = _getElementText(spiritElement, 'type');
        
        if (name != null && type != null && type != 'Sprite') {
          spirits.add(Spirit(name: name, type: type));
        }
      }
    }
    
    return spirits;
  }
  
  static List<ComplexForm> _parseComplexForms(XmlElement characterElement) {
    final complexForms = <ComplexForm>[];
    final complexFormsElement = characterElement.findElements('complexforms').firstOrNull;
    
    if (complexFormsElement != null) {
      for (final formElement in complexFormsElement.findElements('complexform')) {
        final name = _getElementText(formElement, 'name');
        
        if (name != null) {
          complexForms.add(ComplexForm(name: name));
        }
      }
    }
    
    return complexForms;
  }
  
  static List<AdeptPower> _parseAdeptPowers(XmlElement characterElement) {
    final adeptPowers = <AdeptPower>[];
    final powersElement = characterElement.findElements('powers').firstOrNull;
    
    if (powersElement != null) {
      for (final powerElement in powersElement.findElements('power')) {
        final name = _getElementText(powerElement, 'name');
        final rating = _getElementText(powerElement, 'rating');
        final extra = _getElementText(powerElement, 'extra');
        
        if (name != null) {
          adeptPowers.add(AdeptPower(
            name: name,
            rating: rating,
            extra: extra,
          ));
        }
      }
    }
    
    return adeptPowers;
  }
  
  static List<Gear> _parseGear(XmlElement characterElement) {
    final allGear = <Gear>[];
    
    // Parse regular gear
    final gearsElement = characterElement.findElements('gears').firstOrNull;
    if (gearsElement != null) {
      for (final gearElement in gearsElement.findElements('gear')) {
        final gear = _parseGearItem(gearElement);
        if (gear != null) allGear.add(gear);
      }
    }
    
    // Parse weapons as gear
    final weaponsElement = characterElement.findElements('weapons').firstOrNull;
    if (weaponsElement != null) {
      for (final weaponElement in weaponsElement.findElements('weapon')) {
        final gear = _parseGearItem(weaponElement);
        if (gear != null) allGear.add(gear);
      }
    }
    
    // Parse armor as gear
    final armorsElement = characterElement.findElements('armors').firstOrNull;
    if (armorsElement != null) {
      for (final armorElement in armorsElement.findElements('armor')) {
        final gear = _parseGearItem(armorElement);
        if (gear != null) allGear.add(gear);
      }
    }
    
    return allGear;
  }
  
  static Gear? _parseGearItem(XmlElement gearElement) {
    final name = _getElementText(gearElement, 'name');
    final category = _getElementText(gearElement, 'category');
    final rating = _getElementText(gearElement, 'rating');
    final equipped = _getElementText(gearElement, 'equipped') == 'True';
    final quantity = _getElementText(gearElement, 'quantity');
    final source = _getElementText(gearElement, 'source') ?? '';
    final guid = _getElementText(gearElement, 'guid');
    
    if (name != null) {
      return Gear(
        guid: guid,
        name: name,
        category: category,
        rating: rating,
        equipped: equipped,
        quantity: quantity,
        source: source,
      );
    }
    
    return null;
  }
  
  static ConditionMonitor _parseConditionMonitor(XmlElement characterElement, Map<String, dynamic> calculatedValues) {
    // Create a map with all the root-level character data
    final rootData = <String, dynamic>{};
    for (final element in characterElement.children.whereType<XmlElement>()) {
      rootData[element.name.local] = element.innerText;
    }
    
    return ConditionMonitor.fromXml(rootData, calculatedValues);
  }

  static Map<String, dynamic> _parseCalculatedValues(XmlElement characterElement) {
    final calculatedValuesElement = characterElement.findElements('calculatedvalues').firstOrNull;
    if (calculatedValuesElement == null) return {};
    
    final calculatedValues = <String, dynamic>{};
    for (final element in calculatedValuesElement.children.whereType<XmlElement>()) {
      calculatedValues[element.name.local] = element.innerText;
    }
    return calculatedValues;
  }
}
