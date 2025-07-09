/// Utility for mapping skills to their groups and handling skill group logic
/// Based on Shadowrun 5th Edition skill groups
class SkillGroupMap {
  /// Map of skill group names to their constituent skills
  static const Map<String, List<String>> _groupToSkills = {
    'Acting': ['Con', 'Impersonation', 'Performance'],
    'Athletics': ['Gymnastics', 'Running', 'Swimming'],
    'Biotech': ['Cybertechnology', 'First Aid', 'Medicine'],
    'Close Combat': ['Blades', 'Clubs', 'Unarmed Combat'],
    'Conjuring': ['Banishing', 'Binding', 'Summoning'],
    'Cracking': ['Cybercombat', 'Electronic Warfare', 'Hacking'],
    'Electronics': ['Computer', 'Data Search', 'Software'],
    'Enchanting': ['Alchemy', 'Artificing', 'Disenchanting'],
    'Engineering': ['Aeronautics Mechanic', 'Automotive Mechanic', 'Industrial Mechanic'],
    'Firearms': ['Automatics', 'Longarms', 'Pistols'],
    'Influence': ['Etiquette', 'Leadership', 'Negotiation'],
    'Outdoors': ['Navigation', 'Survival', 'Tracking'],
    'Sorcery': ['Counterspelling', 'Ritual Spellcasting', 'Spellcasting'],
    'Stealth': ['Disguise', 'Palming', 'Sneaking'],
    'Tasking': ['Compiling', 'Decompiling', 'Registering'],
  };

  /// Reverse map from skill name to group name
  static final Map<String, String> _skillToGroup = {
    for (final entry in _groupToSkills.entries)
      for (final skill in entry.value) skill: entry.key
  };

  /// Get the skill group name for a given skill
  /// Returns empty string if skill is not part of any group
  static String getSkillGroup(String skillName) {
    return _skillToGroup[skillName] ?? '';
  }

  /// Get all skills in a given group
  static List<String> getSkillsInGroup(String groupName) {
    return _groupToSkills[groupName] ?? [];
  }

  /// Check if a skill belongs to a group
  static bool isSkillInGroup(String skillName, String groupName) {
    final skillsInGroup = _groupToSkills[groupName];
    return skillsInGroup?.contains(skillName) ?? false;
  }

  /// Calculate the total value for a skill group based on base and karma
  /// Returns the sum of base + karma for the group
  static int calculateGroupTotal(String? base, String? karma) {
    final baseValue = int.tryParse(base ?? '0') ?? 0;
    final karmaValue = int.tryParse(karma ?? '0') ?? 0;
    return baseValue + karmaValue;
  }

  /// Check if a skill group is "broken"
  /// A group is broken if not all skills in the group have the same base+group value
  /// This requires checking all skills in the character that belong to this group
  static bool isGroupBroken(
    String groupName,
    List<dynamic> allSkills, // List of Skill objects
    int groupTotal,
  ) {
    final skillsInGroup = getSkillsInGroup(groupName);
    if (skillsInGroup.isEmpty) return false;

    // Find all character skills that belong to this group
    final groupSkills = allSkills.where((skill) {
      final skillName = skill.name as String?;
      return skillName != null && skillsInGroup.contains(skillName);
    }).toList();

    // If we don't have all skills in the group with points, it's not broken
    if (groupSkills.isEmpty) return false;

    // Check if all skills have the same total (base + karma + group)
    int? expectedTotal;
    for (final skill in groupSkills) {
      final skillBase = int.tryParse(skill.base ?? '0') ?? 0;
      final skillKarma = int.tryParse(skill.karma ?? '0') ?? 0;
      final skillTotal = skillBase + skillKarma + groupTotal;

      if (expectedTotal == null) {
        expectedTotal = skillTotal;
      } else if (expectedTotal != skillTotal) {
        return true; // Group is broken - different totals
      }
    }

    return false; // All skills have the same total
  }

  /// Get all skill group names
  static List<String> getAllGroupNames() {
    return _groupToSkills.keys.toList();
  }

  /// Check if a group name exists
  static bool isValidGroupName(String groupName) {
    return _groupToSkills.containsKey(groupName);
  }
}
