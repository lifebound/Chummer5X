import 'package:flutter/foundation.dart';

import 'package:chummer5x/models/attributes.dart';

/// Mapping of skill names to their associated attributes in Shadowrun 5th Edition
/// This is used to calculate total skill ratings by adding the base skill + attribute bonus
const Map<String, String> skillAttributeMap = {
  // Combat Active Skills
  "Archery": "AGI",
  "Armorer": "LOG",
  "Automatics": "AGI", 
  "Blades": "AGI",
  "Clubs": "AGI",
  "Exotic Ranged Weapon": "AGI",
  "Exotic Melee Weapon": "AGI",
  "Gunnery": "AGI",
  "Heavy Weapons": "AGI",
  "Longarms": "AGI",
  "Pistols": "AGI",
  "Throwing Weapons": "AGI",
  "Unarmed Combat": "AGI",
  
  // Physical Active Skills
  "Escape Artist": "AGI",
  "Gymnastics": "AGI",
  "Infiltration": "AGI", // Updated from your JS (was using "Sneaking")
  "Locksmith": "AGI",
  "Palming": "AGI",
  "Running": "STR",
  "Swimming": "STR",
  "Climbing": "STR",
  "Diving": "BOD",
  "Free-Fall": "BOD",
  "Parachuting": "BOD",
  "Flying": "REA",
  
  // Mental Active Skills
  "Artisan": "INT",
  "Assensing": "INT",
  "Disguise": "INT",
  "Instruction": "CHA",
  "Intimidation": "CHA",
  "Leadership": "CHA",
  "Navigation": "INT",
  "Perception": "INT",
  "Performance": "CHA",
  "Tracking": "INT",
  "Survival": "WIL",
  
  // Social Active Skills
  "Animal Handling": "CHA",
  "Con": "CHA",
  "Etiquette": "CHA",
  "Impersonation": "CHA", // Added from your JS
  "Negotiation": "CHA",
  
  // Technical Active Skills
  "Aeronautics Mechanic": "LOG",
  "Automotive Mechanic": "LOG",
  "Biotechnology": "LOG",
  "Chemistry": "LOG",
  "Computer": "LOG",
  "Cybertechnology": "LOG",
  "Data Processing": "LOG", // Added from your JS (was "Data Search")
  "Demolitions": "LOG",
  "First Aid": "LOG",
  "Forgery": "AGI", // Updated from your JS (was LOG)
  "Hardware": "LOG",
  "Industrial Mechanic": "LOG",
  "Medicine": "LOG",
  "Nautical Mechanic": "LOG",
  "Software": "LOG",
  
  // Vehicle Active Skills
  "Pilot Aerospace": "REA",
  "Pilot Aircraft": "REA",
  "Pilot Anthroform": "REA",
  "Pilot Ground Craft": "REA", // Updated from your JS
  "Pilot Groundcraft": "REA", // Keep both variants
  "Pilot Watercraft": "REA",
  "Pilot Walker": "REA",
  "Pilot Exotic Vehicle": "REA",
  
  // Magic Active Skills
  "Alchemy": "MAG",
  "Artificing": "MAG",
  "Astral Combat": "WIL",
  "Banishing": "MAG",
  "Binding": "MAG",
  "Counterspelling": "MAG",
  "Disenchanting": "MAG",
  "Ritual Spellcasting": "MAG",
  "Spellcasting": "MAG",
  "Summoning": "MAG",
  
  // Resonance Active Skills
  "Compiling": "RES",
  "Decompiling": "RES",
  "Registering": "RES",
  
  // Matrix Active Skills  
  "Cybercombat": "LOG",
  "Electronic Warfare": "LOG",
  "Hacking": "LOG",
  
  // Knowledge Skills (typically INT or LOG based)
  "Academic Knowledge": "LOG",
  "Interests Knowledge": "INT",
  "Professional Knowledge": "LOG", 
  "Street Knowledge": "INT",
  "Language": "INT",
};

/// Skills that don't allow defaulting - if you have no points in these skills, the total is 0
const Set<String> noDefaultingSkills = {
  // Pilot Skills
  "Pilot Aerospace",
  "Pilot Aircraft", 
  "Pilot Walker",
  "Pilot Exotic Vehicle",
  
  // Technical Skills
  "Aeronautics Mechanic",
  "Automotive Mechanic", 
  "Biotechnology",
  "Chemistry",
  "Cybertechnology",
  "Electronic Warfare",
  "Industrial Mechanic",
  "Hardware",
  "Medicine",
  "Nautical Mechanic",
  "Software",
  
  // Magic Skills
  "Astral Combat",
  "Banishing",
  "Binding", 
  "Counterspelling",
  "Ritual Spellcasting",
  "Spellcasting",
  "Summoning",
  "Enchanting",
  "Disenchanting",
  
  // Resonance Skills
  "Compiling",
  "Decompiling", 
  "Registering",
  
  // Additional skills that typically don't allow defaulting
  "Alchemy",
  "Artificing",
};

/// Check if a skill allows defaulting (rolling base attribute -1 when no skill points)
bool skillAllowsDefaulting(String skillName) {
  return !noDefaultingSkills.contains(skillName);
}

/// Helper function to get the attribute for a given skill
String? getSkillAttribute(String skillName) {
  return skillAttributeMap[skillName];
}

/// Helper function to calculate total skill rating (skill rating + attribute rating + bonuses)
/// Takes a ShadowrunCharacter and skill name to calculate the total
/// Handles defaulting: skills with 0 points use attribute-1 if defaulting allowed, 0 if not
/// CM penalty is applied at the end and result cannot go below 0
int calculateTotalSkillRating(String skillName, int skillRating, List<Attribute> attributes, {bool isPrioritySkill = false, int conditionMonitorPenalty = 0}) {
  final attributeName = getSkillAttribute(skillName);
  debugPrint('Calculating total skill rating for $skillName with base rating $skillRating, attribute $attributeName, priority skill: $isPrioritySkill, CM penalty: $conditionMonitorPenalty');
  final priorityBonus = isPrioritySkill ? 2 : 0;
  
  // Handle skills with 0 effective skill points (including priority bonus)
  if (skillRating + priorityBonus == 0) {
    if (!skillAllowsDefaulting(skillName)) {
      debugPrint('Skill $skillName does not allow defaulting and has no points, returning 0');
      // Skill doesn't allow defaulting - total is 0 regardless of attribute or CM penalty
      return 0;
    } else {
      debugPrint('Skill $skillName allows defaulting, calculating default rating');
      // Skill allows defaulting - use attribute - 1 (plus any priority bonus), then apply CM penalty
      if (attributeName != null) {
        debugPrint('Using attribute $attributeName for defaulting calculation');
        try {
          final attribute = attributes.firstWhere(
            (attr) => attr.name.toUpperCase() == attributeName,
          );
          debugPrint('Found attribute $attributeName with total value ${attribute.totalValue}');
          // For defaulting: attribute - 1 + priority bonus + CM penalty, but never below 0
          final baseDefault = (attribute.totalValue.round() - 1) + priorityBonus;
          debugPrint('Base default rating: $baseDefault, applying CM penalty: $conditionMonitorPenalty');
          return (baseDefault + conditionMonitorPenalty).clamp(0, double.infinity).toInt();
        } catch (e) {
          debugPrint('Attribute $attributeName not found, returning just priority bonus + CM penalty');
          // If attribute not found, return just the priority bonus + CM penalty, but never below 0
          return (priorityBonus + conditionMonitorPenalty).clamp(0, double.infinity).toInt();
        }
      } else {
        debugPrint((priorityBonus + conditionMonitorPenalty).toString());
        // No attribute mapping found, return just the priority bonus + CM penalty, but never below 0
        return (priorityBonus + conditionMonitorPenalty).clamp(0, double.infinity).toInt();
      }
    }
  }
  
  // Normal calculation for skills with effective points (skill + priority > 0)
  var totalRating = skillRating + priorityBonus;
  debugPrint('Initial total rating (skill + priority): $totalRating');
  // Add attribute bonus if available
  if (attributeName != null) {
    try {
      final attribute = attributes.firstWhere(
        (attr) => attr.name.toUpperCase() == attributeName,
      );
      totalRating += attribute.totalValue.round();
    } catch (e) {
      // If attribute not found, just continue with current total
    }
  }
  debugPrint('Total rating after adding attribute: $totalRating');
  // Apply CM penalty and ensure result is never below 0
  return (totalRating + conditionMonitorPenalty).clamp(0, double.infinity).toInt();
}

/// Helper function to calculate specialized skill rating (includes +2 for specialization)
/// Use this when showing the skill with its specialization bonus
/// Handles defaulting properly - no specialization bonus if skill doesn't allow defaulting and has 0 points
int calculateSpecializedSkillRating(String skillName, int skillRating, List<Attribute> attributes, {bool isPrioritySkill = false, bool hasSpecialization = false, int conditionMonitorPenalty = 0}) {
  var totalRating = calculateTotalSkillRating(skillName, skillRating, attributes, isPrioritySkill: isPrioritySkill, conditionMonitorPenalty: conditionMonitorPenalty);
  
  // Add specialization bonus (+2), but only if the skill has a usable rating
  // If the skill has 0 total rating (because it doesn't allow defaulting and has no points), no specialization
  if (hasSpecialization && totalRating > 0) {
    totalRating += 2;
  }
  
  return totalRating;
}
