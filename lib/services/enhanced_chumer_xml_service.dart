import 'dart:io';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import '../models/shadowrun_character.dart';
import '../utils/skill_group_map.dart';

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
      debugPrint('Error parsing character file: $e');
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
      
      // Parse priority skills (root level)
      final prioritySkills = _parsePrioritySkills(characterElement);
      
      // Parse skills
      final skills = _parseSkills(characterElement, skillGroups, prioritySkills);
      
      // Check for broken skill groups and log them
      _checkBrokenSkillGroups(skillGroups, skills);
      
      // Calculate and parse limits
      final limits = _calculateLimits(attributes, characterElement);
      
      // Parse magic/resonance content
      final spells = parseSpells(characterElement);
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
      
      // Parse character type flags (for Shadowrun 5e: adept, magician, technomancer)
      final isAdept = _getElementText(characterElement, 'adept')?.toLowerCase() == 'true';
      final isMagician = _getElementText(characterElement, 'magician')?.toLowerCase() == 'true';
      final isTechnomancer = _getElementText(characterElement, 'technomancer')?.toLowerCase() == 'true';
      
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
        isAdept: isAdept,
        isMagician: isMagician,
        isTechnomancer: isTechnomancer,
      );
    } catch (e) {
      debugPrint('Error parsing XML: $e');
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
            debugPrint('Parsed skill group: $name, Base: $base, Karma: $karma');
          }
        }
      }
    }
    
    return skillGroups;
  }
  
  static List<Skill> _parseSkills(XmlElement characterElement, List<SkillGroup> skillGroups, Set<String> prioritySkills) {
    final skills = <Skill>[];
    
    final skillsElement = characterElement.findElements('newskills').firstOrNull;
    
    if (skillsElement != null) {
      final skillsListElement = skillsElement.findElements('skills').firstOrNull;
      if (skillsListElement != null) {
        for (final skillElement in skillsListElement.findElements('skill')) {
          final name = _getElementText(skillElement, 'name');
          final karma = _getElementText(skillElement, 'karma');
          final base = _getElementText(skillElement, 'base');
          final category = _getElementText(skillElement, 'category');
          
          if (name != null) {
            // Find matching skill group using the skill group mapping
            final skillGroupName = SkillGroupMap.getSkillGroup(name);
            
            // Find the skill group data to get the group total
            int skillGroupTotal = 0;
            if (skillGroupName.isNotEmpty) {
              final matchingGroup = skillGroups.firstWhere(
                (group) => group.name == skillGroupName,
                orElse: () => const SkillGroup(name: '', base: null, karma: null),
              );
              if (matchingGroup.name.isNotEmpty) {
                skillGroupTotal = SkillGroupMap.calculateGroupTotal(
                  matchingGroup.base, 
                  matchingGroup.karma
                );
              }
            }
            
            debugPrint('Parsing skill: $name, Karma: $karma, Base: $base, Group: $skillGroupName, GroupTotal: $skillGroupTotal');
            // Check if this is a priority skill
            final isPrioritySkill = prioritySkills.contains(name);
            debugPrint('Is priority skill: $isPrioritySkill');
            // Convert skill element to JSON-like map for parsing
            final skillJson = <String, dynamic>{
              'name': name,
              'karma': karma,
              'base': base,
              'category': category,
            };
            
            // Parse specializations
            final specsElement = skillElement.findElements('specs').firstOrNull;
            if (specsElement != null) {
              final specElements = specsElement.findElements('spec');
              if (specElements.isNotEmpty) {
                final specs = <Map<String, dynamic>>[];
                for (final specElement in specElements) {
                  final specName = _getElementText(specElement, 'name');
                  final free = _getElementText(specElement, 'free') ?? 'False';
                  final expertise = _getElementText(specElement, 'expertise') ?? 'False';
                  
                  if (specName != null) {
                    specs.add({
                      'name': specName,
                      'free': free,
                      'expertise': expertise,
                    });
                  }
                }
                
                if (specs.length == 1) {
                  skillJson['specs'] = {'spec': specs.first};
                } else if (specs.length > 1) {
                  skillJson['specs'] = {'spec': specs};
                }
              }
            }
            
            skills.add(Skill.fromJson(
              skillJson,
              skillGroupName,
              skillGroupTotal,
              isPrioritySkill: isPrioritySkill,
            ));
          }
        }
      }
    }
    
    return skills;
  }
  
  static Set<String> _parsePrioritySkills(XmlElement characterElement) {
  debugPrint('Parsing priority skills...');
  final prioritySkills = <String>{};
  final prioritySkillsElements = characterElement.findElements('priorityskills');
  debugPrint('Found ${prioritySkillsElements.length} priority skills elements');
  
  // Process each priorityskills element
  for (final prioritySkillsElement in prioritySkillsElements) {
    debugPrint('Processing priority skills element...');
    for (final prioritySkillElement in prioritySkillsElement.findElements('priorityskill')) {
      debugPrint('Parsing priority skill element: $prioritySkillElement');
      final prioritySkillName = prioritySkillElement.innerText.trim();
      if (prioritySkillName.isNotEmpty) {
        debugPrint('Found priority skill: $prioritySkillName');
        prioritySkills.add(prioritySkillName);
      }
    }
  }
  
  debugPrint('Total priority skills found: ${prioritySkills.length}');
  return prioritySkills;
}

  /// Check for broken skill groups and log warnings
  static void _checkBrokenSkillGroups(List<SkillGroup> skillGroups, List<Skill> skills) {
    for (final group in skillGroups) {
      final groupTotal = SkillGroupMap.calculateGroupTotal(group.base, group.karma);
      if (groupTotal > 0) {
        final isBroken = SkillGroupMap.isGroupBroken(group.name, skills, groupTotal);
        if (isBroken) {
          debugPrint('WARNING: Skill group "${group.name}" is broken!');
        } else {
          debugPrint('Skill group "${group.name}" is intact (total: $groupTotal)');
        }
      }
    }
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
  
  static List<Spell> parseSpells(XmlElement characterElement) {
    final spells = <Spell>[];
    final spellsElement = characterElement.findElements('spells').firstOrNull;
    
    if (spellsElement != null) {
      for (final spellElement in spellsElement.findElements('spell')) {
        final name = _getElementText(spellElement, 'name');
        final category = _getElementText(spellElement, 'category');
        final range = _getElementText(spellElement, 'range');
        final target = _getElementText(spellElement, 'target');
        final duration = _getElementText(spellElement, 'duration');
        final drain = _getElementText(spellElement, 'dv');
        final source = _getElementText(spellElement, 'source');
        final improvementSource = _getElementText(spellElement, 'improvementsource');
        final grade = _getElementText(spellElement, 'grade');
        final page = _getElementText(spellElement, 'page');
        if (name != null && category != null) {
          spells.add(Spell(
            name: name,
            category: category,
            range: range ?? '',
            duration: duration ?? '',
            drain: drain ?? '',
            source: source ?? '',
            improvementSource: improvementSource,
            grade: grade,
            page: page ?? '',
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
        final target = _getElementText(formElement, 'target');
        final duration = _getElementText(formElement, 'duration');
        final fading = _getElementText(formElement, 'fv');
        final source = _getElementText(formElement, 'source');
        final page = _getElementText(formElement, 'page');
        debugPrint('Parsing complex form: $name, Target: $target, Duration: $duration, Fading: $fading, Source: $source, Page: $page');
        if (name != null) {
          complexForms.add(ComplexForm(
            name: name,
            target: target ?? '',
            duration: duration ?? '',
            fading: fading ?? '',
            source: source ?? '',
            page: page ?? '',
          ));
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
