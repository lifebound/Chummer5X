import 'dart:io';
import 'package:chummer5x/models/expense_entry.dart';
import 'package:chummer5x/models/items/cyberware.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:chummer5x/models/shadowrun_character.dart';
import 'package:chummer5x/utils/skill_group_map.dart';
import 'package:chummer5x/models/attributes.dart';
import 'package:chummer5x/models/condition_monitor.dart';
import 'package:chummer5x/models/spells.dart';
import 'package:chummer5x/models/spirit.dart';
import 'package:chummer5x/models/sprite.dart';
import 'package:chummer5x/models/complex_forms.dart';
import 'package:chummer5x/models/items/gear.dart';
import 'package:chummer5x/models/items/weapon.dart';
import 'package:chummer5x/models/items/armor.dart';
import 'package:chummer5x/models/items/vehicle.dart';
import 'package:chummer5x/models/adept_powers.dart';
import 'package:chummer5x/models/initiation.dart';
import 'package:chummer5x/models/submersion.dart';
import 'package:chummer5x/models/critter_factory.dart';
import 'package:chummer5x/models/metamagic.dart';
import 'package:chummer5x/models/skills.dart';
import 'package:chummer5x/models/qualities.dart';
import 'package:chummer5x/models/calendar.dart';
import 'package:chummer5x/models/game_notes.dart';
import 'package:chummer5x/models/mugshot.dart';
import 'package:chummer5x/models/items/location.dart';


class EnhancedChummerXmlService {
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
      //name is usually name, but if its null or empty, use alias

      String name = _getElementText(characterElement, 'name') ?? _getElementText(characterElement, 'alias') ?? 'Unknown';
      if(name.isEmpty) {
        name = _getElementText(characterElement, 'alias') ?? 'Unknown';
      }


      final alias = _getElementText(characterElement, 'alias') ?? name;
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

      final qualities = _parseQualities(characterElement);
      
      // Parse skill groups
      final skillGroups = _parseSkillGroups(characterElement);
      
      // Parse priority skills (root level)
      final prioritySkills = _parsePrioritySkills(characterElement);
      
      // Parse skills
      final skills = _parseSkills(characterElement, skillGroups, prioritySkills);
      
      // Check for broken skill groups and log them
      _checkBrokenSkillGroups(skillGroups, skills);
      
      // Calculate and parse limits
      //final limits = _calculateLimits(attributes, characterElement);
      
      // Parse magic/resonance content
      final spells = parseSpells(characterElement);
      final spirits = _parseSpirits(characterElement);
      final sprites = _parseSprites(characterElement);
      final complexForms = _parseComplexForms(characterElement);
      final adeptPowers = parseAdeptPowers(characterElement);
      final initiationGrades = _parseInitiationGrades(characterElement)[0];
      final submersionGrades = _parseInitiationGrades(characterElement)[1] as List<SubmersionGrade>;
      
      // Parse gear
      final gear = _parseGear(characterElement);
      final gearLocations = _parseLocations(characterElement, "gearlocations", defaultGearLocationGuid, 'Selected Gear');

      // parse armor
      final allArmor = _parseArmor(characterElement);
      final armorLocations = _parseLocations(characterElement, "armorlocations", defaultArmorLocationGuid, 'Selected Armor');

      //parse vehicles
      final vehicles = _parseVehicles(characterElement);
      final vehicleLocations = _parseLocations(characterElement, "vehicleLocations", defaultVehicleLocationGuid, 'Selected Vehicle');

      // parse weapons
      final allWeapons = _parseWeapons(characterElement);
      final weaponLocations = _parseLocations(characterElement, "weaponLocations", defaultWeaponLocationGuid, 'Selected Weapon');

      //parse cyberware and bioware
      final allCyberware = _parseCyberware(characterElement);
      final cyberwareLocations = _parseLocations(characterElement, "cyberwareLocations", defaultCyberwareLocationGuid, 'Cyberware');
      cyberwareLocations.addAll(_parseLocations(characterElement, "biowareLocations", defaultBiowareLocationGuid, 'Bioware'));

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
      
      // Parse calendar and game notes
      final calendar = _parseCalendar(characterElement);
      final gameNotes = _parseGameNotes(characterElement);
      final allExpenseEntries = _parseExpenseEntries(characterElement);
      final karmaExpenseEntries = allExpenseEntries.where((entry) => entry.type == ExpenseType.karma).toList();
      final nuyenExpenseEntries = allExpenseEntries.where((entry) => entry.type == ExpenseType.nuyen).toList();
      
      // Parse mugshot
      final mugshot = _parseMugshot(characterElement);
      
      return ShadowrunCharacter(
        name: name,
        alias: alias, // In Chummer, alias is often the main name
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
        qualities: qualities,
        skills: skills,
        //limits: limits,
        spells: spells,
        spirits: spirits,
        sprites: sprites,
        complexForms: complexForms,
        adeptPowers: adeptPowers,
        gear: gear,
        conditionMonitor: conditionMonitor,
        nuyen: nuyen,
        calendar: calendar,
        gameNotes: gameNotes,
        magEnabled: magEnabled,
        resEnabled: resEnabled,
        depEnabled: depEnabled,
        isAdept: isAdept,
        isMagician: isMagician,
        isTechnomancer: isTechnomancer,
        initiationGrades: initiationGrades,
        submersionGrades: submersionGrades,
        karmaExpenseEntries: karmaExpenseEntries,
        nuyenExpenseEntries: nuyenExpenseEntries,
        mugshot: mugshot,
        gearLocations: gearLocations,
        vehicleLocations: vehicleLocations,
        weaponLocations: weaponLocations,
        armorLocations: armorLocations,
        armor: allArmor,
        vehicles: vehicles,
        weapons: allWeapons,
        cyberware: allCyberware,
        cyberwareLocations: cyberwareLocations

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

        if (name != null && (name != 'Essence' && name != 'ESS')) { // Skip ESS from XML, it will be hard-coded in constructor
          // Parse all the fields from the XML
          final metatypeCategory = _getElementText(attributeElement, 'metatypecategory') ?? '';
          final totalValue = double.tryParse(_getElementText(attributeElement, 'totalvalue') ?? '0') ?? 0.0;
          final metatypeMin = double.tryParse(_getElementText(attributeElement, 'metatypemin') ?? '0') ?? 0.0;
          final metatypeMax = double.tryParse(_getElementText(attributeElement, 'metatypemax') ?? '0') ?? 0.0;
          final metatypeAugMax = double.tryParse(_getElementText(attributeElement, 'metatypeaugmax') ?? '0') ?? 0.0;
          final base = double.tryParse(_getElementText(attributeElement, 'base') ?? '0') ?? 0.0;
          final karma = double.tryParse(_getElementText(attributeElement, 'karma') ?? '0') ?? 0.0;
          
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
    
    // ESS will be automatically added by the ShadowrunCharacter constructor
    
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
  
  
  static List<Spell> parseSpells(XmlElement characterElement) {
    final spells = <Spell>[];
    final spellsElement = characterElement.findElements('spells').firstOrNull;
    
    if (spellsElement != null) {
      for (final spellElement in spellsElement.findElements('spell')) {
        final name = _getElementText(spellElement, 'name');
        final category = _getElementText(spellElement, 'category');
        final range = _getElementText(spellElement, 'range');
        //final target = _getElementText(spellElement, 'target');
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
        final services = int.tryParse(_getElementText(spiritElement, 'services') ?? '0') ?? 0;
        final bound = _getElementText(spiritElement, 'bound')?.toLowerCase() == 'true';
        final fettered = _getElementText(spiritElement, 'fettered')?.toLowerCase() == 'true';
        final force = int.tryParse(_getElementText(spiritElement, 'force') ?? '') ?? 0;
        final crittername = _getElementText(spiritElement, 'crittername');

        if (name != null && type != null && type == 'Spirit') {
          final critter = CritterFactory.generateSpirit(name, force, services, bound, fettered, nameOverride: crittername);
          if(critter is Spirit){
            spirits.add(critter);
          }
        }
      }
    } 
    return spirits;
  }

  static List<Sprite> _parseSprites(XmlElement characterElement) {
    final sprites = <Sprite>[];
    final spiritsElement = characterElement.findElements('spirits').firstOrNull;
    
    if (spiritsElement != null) {
      for (final spiritElement in spiritsElement.findElements('spirit')) {
        final name = _getElementText(spiritElement, 'name');
        final type = _getElementText(spiritElement, 'type');
        final services = int.tryParse(_getElementText(spiritElement, 'services') ?? '0') ?? 0;
        final bound = _getElementText(spiritElement, 'bound')?.toLowerCase() == 'true';
        final fettered = _getElementText(spiritElement, 'fettered')?.toLowerCase() == 'true';
        final force = int.tryParse(_getElementText(spiritElement, 'force') ?? '') ?? 0;
        final crittername = _getElementText(spiritElement, 'crittername');

        if (name != null && type != null && type == 'Sprite') {
          final critter = CritterFactory.generateSprite(name, force, services, bound, fettered, nameOverride: crittername);
          if(critter is Sprite){
            sprites.add(critter);
          }
        }
      }
    }
    
    return sprites;
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
  
  static List<AdeptPower> parseAdeptPowers(XmlElement characterElement) {
    final adeptPowers = <AdeptPower>[];
    final powersElement = characterElement.findElements('powers').firstOrNull;
    
    if (powersElement != null) {
      for (final powerElement in powersElement.findElements('power')) {
        final name = _getElementText(powerElement, 'name');
        // TODO: Parse rating as int instead of String - ratings are always integers
        final rating = _getElementText(powerElement, 'rating');
        final extra = _getElementText(powerElement, 'extra');
        final source = _getElementText(powerElement, 'source') ?? '';
        final page = _getElementText(powerElement, 'page') ?? '';
        final discounted = _getElementText(powerElement, 'discounted')?.toLowerCase() == 'true';
        final pointsPerLevel = double.tryParse(_getElementText(powerElement, 'pointsperlevel') ?? '') ?? 0.0;
        final extraPointCost = double.tryParse(_getElementText(powerElement, 'extrapointcost') ?? '') ?? 0.0;
        final hasLevels = _getElementText(powerElement, 'levels')?.toLowerCase() == 'true';
        final maxLevels = int.tryParse(_getElementText(powerElement, 'maxlevels') ?? '0') ?? 0;
        final action = _getElementText(powerElement, 'action');
        final bonus = _parseBonus(powerElement);
        
        if (name != null) {
          adeptPowers.add(AdeptPower(
            name: name,
            rating: rating,
            extra: extra,
            source: source,
            page: page,
            discounted: discounted,
            pointsPerLevel: pointsPerLevel,
            extraPointCost: extraPointCost,
            hasLevels: hasLevels,
            maxLevels: maxLevels,
            action: action,
            bonus: bonus,

            
          ));
        }
      }
    }
    
    return adeptPowers;
  }

  static Map<String, String>? _parseBonus(XmlElement powerElement) {
    final bonusElement = powerElement.getElement('bonus');
    if (bonusElement == null) return null;

    final Map<String, String> bonusMap = {};

    for (final child in bonusElement.children.whereType<XmlElement>()) {
      final key = child.name.local.trim();
      final value = child.innerText.trim();
      if (key.isNotEmpty && value.isNotEmpty) {
        bonusMap[key] = value;
      }
    }

    return bonusMap.isEmpty ? null : bonusMap;
  }

  static List<Gear> _parseGear(XmlElement characterElement) {
    final allGear = <Gear>[];

    
    // Parse regular gear
    final gearsElement = characterElement.findElements('gears').firstOrNull;
    if (gearsElement != null) {
      for (final gearElement in gearsElement.findElements('gear')) {
        final gear = Gear.fromXml(gearElement);
        allGear.add(gear);
      }
    }   
    return allGear;
  }

  static List<Armor> _parseArmor(XmlElement characterElement) {
    final allArmor = <Armor>[];
    // Parse armor as gear
    final armorsElement = characterElement.findElements('armors').firstOrNull;
    if (armorsElement != null) {
      for (final armorElement in armorsElement.findElements('armor')) {
        final gear = Armor.fromXml(armorElement);
        allArmor.add(gear);
      }
    }
    return allArmor;
  }
  static List<Vehicle> _parseVehicles(XmlElement characterElement) {
    final allVehicles = <Vehicle>[];
    final vehiclesElement = characterElement.findElements('vehicles').firstOrNull;
    
    if (vehiclesElement != null) {
      for (final vehicleElement in vehiclesElement.findElements('vehicle')) {
        final vehicle = Vehicle.fromXml(vehicleElement);
        allVehicles.add(vehicle);
      }
    }
    
    return allVehicles;
  }

  static List<Weapon> _parseWeapons(XmlElement characterElement) {
    final allWeapons = <Weapon>[];
    final weaponsElement = characterElement.findElements('weapons').firstOrNull;
    
    if (weaponsElement != null) {
      for (final weaponElement in weaponsElement.findElements('weapon')) {
        final weapon = Weapon.fromXml(weaponElement);
        allWeapons.add(weapon);
      }
    }
    
    return allWeapons;
  }



  static Map<String, Location> _parseLocations(XmlElement characterElement, String locationType, String defaultLocationGuid, String defaultName) {
    final locations = <String, Location>{};
    final locationsElement = characterElement.findElements(locationType).firstOrNull;
    
    //create default location if no locations are found
    if (locationsElement == null || locationsElement.children.isEmpty) {
      locations[defaultName] = Location(
        name: defaultName,
        guid: defaultLocationGuid,
        notes: '',
        notesColor: '',
        sortOrder: 0
      );
    }
    if (locationsElement != null) {
      for (final locationElement in locationsElement.findElements('location')) {
        final guid = _getElementText(locationElement, 'guid');
        final name = _getElementText(locationElement, 'name');
        final description = _getElementText(locationElement, 'notes');
        final type = _getElementText(locationElement, 'type');
        final notesColor = _getElementText(locationElement, 'notesColor');
        final sortOrder = int.tryParse(_getElementText(locationElement, 'sortorder') ?? '0') ?? 0;

        if (name != null && description != null && type != null) {
          locations[name] = Location(
            name: name,
            guid: guid ?? defaultLocationGuid,
            notes: description,
            notesColor: notesColor ?? '',
            sortOrder: sortOrder,
          );
        }
      }
    }
    
    return locations;
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

  static List<Quality> _parseQualities(XmlElement characterElement) {
    final qualities = <Quality>[];
    final qualitiesElement = characterElement.findElements('qualities').firstOrNull;
    
    if (qualitiesElement != null) {
      for (final qualityElement in qualitiesElement.findElements('quality')) {
        final name = _getElementText(qualityElement, 'name');
        final source = _getElementText(qualityElement, 'source') ?? '';
        final page = _getElementText(qualityElement, 'page') ?? '';
        final karmaCost = int.tryParse(_getElementText(qualityElement, 'bp') ?? '0') ?? 0;
        final qualityTypeStr = _getElementText(qualityElement, 'qualitytype')?.toLowerCase() ?? '';
        final qualityType = qualityTypeStr == 'positive' ? QualityType.positive : QualityType.negative;

        if (name != null) {
          qualities.add(Quality(
            name: name,
            source: source,
            page: page,
            karmaCost: karmaCost,
            qualityType: qualityType,
          ));
        }
      }
    }
    
    return qualities;
  }

  static List<List<InitiationGrade>> _parseInitiationGrades(XmlElement characterElement){
    debugPrint('Parsing initiation grades...');
    final initiationGrades = <InitiationGrade>[];
    final submersionGrades = <SubmersionGrade>[];

    final gradesElement = characterElement.findElements('initiationgrades').firstOrNull;
    
    if (gradesElement != null) {

      for (final gradeElement in gradesElement.findElements('initiationgrade')) {
        debugPrint('Parsing grade element: $gradeElement');
        bool isResEnabled = _getElementText(gradeElement, 'res') == 'True';
        
        final grade = int.tryParse(_getElementText(gradeElement, 'grade') ?? '0') ?? 0;
        final ordeal = _getElementText(gradeElement, 'ordeal')?.toLowerCase() == 'true';
        final group = _getElementText(gradeElement,"group")?.toLowerCase() == 'true';
        final schooling = _getElementText(gradeElement, 'schooling')?.toLowerCase() == 'true';

        if(isResEnabled){
          debugPrint('Adding to submersion grades: $grade');
          submersionGrades.add(SubmersionGrade(
            grade: grade,
            ordeal: ordeal,
            group: group,
            schooling: schooling,
            metamagics: <Metamagic>[],
          ));
        }
        else{
          debugPrint('Adding to initiation grades: $grade');
          initiationGrades.add(InitiationGrade(
            grade: grade,
            ordeal: ordeal,
            group: group,
            schooling: schooling,
            metamagics: <Metamagic>[],
          ));
        }
      }
      final metamagics = _parseMetamagics(characterElement);

        //go through all the returned metamagics; if their improvementSouce is 'Echo',
        //we'll handle it with the SubmersionGrades; if not, we'll handle it with the Initiation Grades
        for (Metamagic metamagic in metamagics) {
          debugPrint('metamagic name: ${metamagic.name}');
          if (metamagic.improvementSource.toLowerCase() == 'echo') {
            //find the submersion grade that matches the current grade
            try{
              debugPrint('${metamagic.name} is an Echo, adding to the list');
              final matchingGrade = submersionGrades.where((grade) => grade.grade == metamagic.grade);
              matchingGrade.firstOrNull?.metamagics.add(metamagic);
            }
            catch(e){
              debugPrint("echo ${metamagic.name} failed to attach to submersion");
            }
            
          } else {
            try{
              debugPrint('${metamagic.name} is not an Echo');
              final matchingGrade = initiationGrades.where((grade) => grade.grade == metamagic.grade);
              matchingGrade.firstOrNull?.metamagics.add(metamagic);
            }
            catch(e) {
              debugPrint("${metamagic.name} failed to attach to initiation");
            }
            
          }
        }

    }
    debugPrint('Total initiation grades: ${initiationGrades.length}, Total submersion grades: ${submersionGrades.length}');
    return [initiationGrades, submersionGrades];
  }

  static List<Metamagic> _parseMetamagics(XmlElement characterElement) {
    final metamagics = <Metamagic>[];

    metamagics.addAll(_parseMetamagicType(characterElement, 'metamagic'));
    //run the same logic for Arts, Enchantments, Enhancements, and Rituals, and put them into the same list
    metamagics.addAll(_parseMetamagicType(characterElement, 'art'));


    final enchantmentsElement = characterElement.findElements('spells').firstOrNull;
    debugPrint('Parsing enchantments...');
    if (enchantmentsElement != null) {
      debugPrint('Found enchantments element, processing spells...');
      for (final enchantmentElement in enchantmentsElement.findElements('spell')) {
        final category = _getElementText(enchantmentElement, 'category');
        debugPrint('Processing enchantment: ${_getElementText(enchantmentElement, 'name')} with category $category');
        if (category == null && category?.toLowerCase() != 'enchantments' && category?.toLowerCase() != 'rituals') {
          debugPrint('Skipping non-enchantment spell: ${_getElementText(enchantmentElement, 'name')}');
          continue;
        }
        final name = _getElementText(enchantmentElement, 'name');
        //final descriptor = _getElementText(enchantmentElement, 'descriptors') ?? '';
        final trueName = '$category: $name';
        final source = _getElementText(enchantmentElement, 'source') ?? '';
        final page = _getElementText(enchantmentElement, 'page') ?? '';
        final improvementSource = _getElementText(enchantmentElement, 'improvementsource') ?? '';
        final grade = _getElementText(enchantmentElement, 'grade');
        debugPrint('name: $name, source: $source, page: $page, improvement source: $improvementSource, grade: $grade');
        if (name != null) {
          metamagics.add(Metamagic(
            name: trueName,
            source: source,
            page: page,
            improvementSource: improvementSource,
            grade: grade != null ? int.tryParse(grade) ?? 0 : 0,
          ));
        }
      }
    }


    final enhancementsElement = characterElement.findElements('enhancements').firstOrNull;
    if (enhancementsElement != null) {
      for (final enhancementElement in enhancementsElement.findElements('enhancement')) {
        final name = _getElementText(enhancementElement, 'name');
        final source = _getElementText(enhancementElement, 'source') ?? '';
        final page = _getElementText(enhancementElement, 'page') ?? '';
        final improvementSource = _getElementText(enhancementElement, 'improvementsource') ?? '';
        final grade = _getElementText(enhancementElement, 'grade');
        debugPrint('name: $name, source: $source, page: $page, improvement source: $improvementSource, grade: $grade');
        if (name != null) {
          metamagics.add(Metamagic(
            name: name,
            source: source,
            page: page,
            improvementSource: improvementSource,
            grade: grade != null ? int.tryParse(grade) ?? 0 : 0,
          ));
        }
      }
    }

    return metamagics;
  }
  static List<Metamagic> _parseMetamagicType(XmlElement characterElement, String type) {
    final metamagics = <Metamagic>[];
    final metamagicsElement = characterElement.findElements('${type}s').firstOrNull;
    
    if (metamagicsElement != null) {
      for (final metamagicElement in metamagicsElement.findElements(type)) {
        final name = _getElementText(metamagicElement, 'name');
        final source = _getElementText(metamagicElement, 'source') ?? '';
        final page = _getElementText(metamagicElement, 'page') ?? '';
        final improvementSource = _getElementText(metamagicElement, 'improvementsource') ?? '';
        final grade = _getElementText(metamagicElement, 'grade');
        
        if (name != null) {
          metamagics.add(Metamagic(
            name: name,
            source: source,
            page: page,
            improvementSource: improvementSource,
            grade: grade != null ? int.tryParse(grade) ?? 0 : 0,
          ));
        }
      }
    } 
    return metamagics;
  }
  
  /// Parse calendar from XML
  static Calendar? _parseCalendar(XmlElement characterElement) {
    final calendarElement = characterElement.findElements('calendar').firstOrNull;
    if (calendarElement == null) return null;
    
    final weeks = <CalendarWeek>[];
    
    for (final weekElement in calendarElement.findElements('week')) {
      final guid = _getElementText(weekElement, 'guid') ?? '';
      final year = int.tryParse(_getElementText(weekElement, 'year') ?? '0') ?? 0;
      final week = int.tryParse(_getElementText(weekElement, 'week') ?? '0') ?? 0;
      final notes = _getElementText(weekElement, 'notes');
      final notesColor = _getElementText(weekElement, 'notesColor');
      
      weeks.add(CalendarWeek(
        guid: guid,
        year: year,
        week: week,
        notes: notes?.trim().isEmpty == true ? null : notes,
        notesColor: notesColor,
      ));
    }
    
    return Calendar(weeks: weeks);
  }
  
  /// Parse game notes from XML
  static GameNotes? _parseGameNotes(XmlElement characterElement) {
    final gameNotesElement = characterElement.findElements('gamenotes').firstOrNull;
    if (gameNotesElement == null) return null;
    
    final rtfContent = gameNotesElement.innerText;
    if (rtfContent.trim().isEmpty) return null;
    
    return GameNotes.fromRtf(rtfContent);
  }
  static List<ExpenseEntry> _parseExpenseEntries(XmlElement characterElement) {
    debugPrint('Parsing expense entries...');
    final entries = <ExpenseEntry>[];
    final expenseEntriesElement = characterElement.findElements('expenses').firstOrNull;

    if (expenseEntriesElement != null) {
      for (final entryElement in expenseEntriesElement.findElements('expense')) {
          var exp = ExpenseEntry.fromXml(entryElement);
          entries.add(exp);
          debugPrint('Parsed expense entry: ${exp.toString()}');

      }
    }
    return entries;
  }

  /// Parse mugshot from XML - extracts first mugshot from \<mugshots\> element
  static Mugshot? _parseMugshot(XmlElement characterElement) {
    try {
      final mugshotsElement = characterElement.findElements('mugshots').firstOrNull;
      if (mugshotsElement == null) {
        return null;
      }

      final mugshotElements = mugshotsElement.findElements('mugshot');
      if (mugshotElements.isEmpty) {
        return null;
      }

      // Get the first mugshot element
      final firstMugshot = mugshotElements.first;
      final base64Data = firstMugshot.innerText.trim();
      
      if (base64Data.isEmpty) {
        return null;
      }

      // Create mugshot from base64 data - format detection happens automatically
      return Mugshot.fromBase64(base64Data);
    } catch (e) {
      debugPrint('Error parsing mugshot: $e');
      return null;
    }
  }

  static List<Cyberware> _parseCyberware(XmlElement characterElement) {
    final cyberwareElements = characterElement.findElements('cyberwares').firstOrNull;
    if (cyberwareElements == null ) {
      return [];
    }
    final individualCyberwareElements = cyberwareElements.findElements('cyberware');
    return individualCyberwareElements.map((e) => Cyberware.fromXml(e)).toList();
  }
}