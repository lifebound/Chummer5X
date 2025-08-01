import 'package:flutter/material.dart';
import 'package:chummer5x/models/shadowrun_character.dart';
import 'package:chummer5x/utils/skill_attribute_map.dart';
import 'package:chummer5x/models/skills.dart';
import 'package:chummer5x/utils/skill_group_map.dart';
import 'package:chummer5x/utils/responsive_layout.dart';

enum SkillOrganization {
  none('No Grouping'),
  alphabetical('Group Alphabetical'),
  byAttribute('Group By Attribute'),
  byCategory('Group By Category'),
  bySkillGroup('Group By Skill Group');

  const SkillOrganization(this.displayName);
  final String displayName;
}

enum SkillFilter {
  showAll('Show All'),
  showWithSkillRating('Has Skill Points'),
  showWithTotalRating('Has Total Rating');

  const SkillFilter(this.displayName);
  final String displayName;
}

enum SkillSort {
  name('Sort by Name'),
  attribute('Sort by Attribute'),
  baseSkill('Sort by Base Skill'),
  totalSkill('Sort by Total Rating');

  const SkillSort(this.displayName);
  final String displayName;
}

class SkillsCard extends StatefulWidget {
  final ShadowrunCharacter character;

  const SkillsCard({super.key, required this.character});

  @override
  State<SkillsCard> createState() => _SkillsCardState();
}

class _SkillsCardState extends State<SkillsCard> {
  SkillOrganization _organization = SkillOrganization.none;
  SkillFilter _filter = SkillFilter.showAll;
  SkillSort _sort = SkillSort.name;
  bool _sortReversed = false;

  @override
  Widget build(BuildContext context) {
    final skills = widget.character.skills;
    
    if (skills.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Skills',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'No skills found',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Apply filters, sorting, and organization
    final filteredSkills = _filterSkills(skills);
    final sortedSkills = _sortSkills(filteredSkills);
    final skillGroups = _organizeSkills(sortedSkills);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildFilterControls(context),
            const SizedBox(height: 16),
            ...skillGroups.entries.map((entry) => 
              _buildSkillGroup(context, entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  List<Skill> _filterSkills(List<Skill> skills) {
    switch (_filter) {
      case SkillFilter.showWithSkillRating:
        return skills.where((skill) {
          final baseRating = int.tryParse(skill.base ?? '0') ?? 0;
          final karmaRating = int.tryParse(skill.karma ?? '0') ?? 0;
          final priorityBonus = skill.isPrioritySkill ? 2 : 0;
          final skillRating = baseRating + karmaRating + skill.skillGroupTotal + priorityBonus;
          return skillRating > 0;
        }).toList();
      
      case SkillFilter.showWithTotalRating:
        return skills.where((skill) {
          final totalRating = calculateTotalSkillRating(
            skill.name, 
            skill.skillGroupTotal, 
            widget.character.attributes, 
            isPrioritySkill: skill.isPrioritySkill,
            conditionMonitorPenalty: widget.character.conditionMonitorPenalty,
          );
          return totalRating > 0;
        }).toList();
      
      case SkillFilter.showAll:
        return skills;
    }
  }

  List<Skill> _sortSkills(List<Skill> skills) {
    final sortedList = List<Skill>.from(skills);
    
    switch (_sort) {
      case SkillSort.name:
        sortedList.sort((a, b) => a.name.compareTo(b.name));
        break;
      
      case SkillSort.attribute:
        sortedList.sort((a, b) {
          final attrA = getSkillAttribute(a.name) ?? '';
          final attrB = getSkillAttribute(b.name) ?? '';
          final result = attrA.compareTo(attrB);
          // Secondary sort by name if attributes are the same
          return result != 0 ? result : a.name.compareTo(b.name);
        });
        break;
      
      case SkillSort.baseSkill:
        sortedList.sort((a, b) {
          final baseA = int.tryParse(a.base ?? '0') ?? 0;
          final baseB = int.tryParse(b.base ?? '0') ?? 0;
          final karmaA = int.tryParse(a.karma ?? '0') ?? 0;
          final karmaB = int.tryParse(b.karma ?? '0') ?? 0;
          final skillRatingA = baseA + karmaA + a.skillGroupTotal;
          final skillRatingB = baseB + karmaB + b.skillGroupTotal;
          final result = skillRatingA.compareTo(skillRatingB);
          // Secondary sort by name if ratings are the same
          return result != 0 ? result : a.name.compareTo(b.name);
        });
        break;
      
      case SkillSort.totalSkill:
        sortedList.sort((a, b) {
          final baseA = int.tryParse(a.base ?? '0') ?? 0;
          final baseB = int.tryParse(b.base ?? '0') ?? 0;
          final karmaA = int.tryParse(a.karma ?? '0') ?? 0;
          final karmaB = int.tryParse(b.karma ?? '0') ?? 0;
          final skillRatingA = baseA + karmaA + a.skillGroupTotal;
          final skillRatingB = baseB + karmaB + b.skillGroupTotal;
          
          final totalA = calculateTotalSkillRating(
            a.name, 
            skillRatingA, 
            widget.character.attributes, 
            isPrioritySkill: a.isPrioritySkill,
            conditionMonitorPenalty: widget.character.conditionMonitorPenalty,
          );
          final totalB = calculateTotalSkillRating(
            b.name, 
            skillRatingB, 
            widget.character.attributes, 
            isPrioritySkill: b.isPrioritySkill,
            conditionMonitorPenalty: widget.character.conditionMonitorPenalty,
          );
          
          final result = totalA.compareTo(totalB);
          // Secondary sort by name if totals are the same
          return result != 0 ? result : a.name.compareTo(b.name);
        });
        break;
    }
    
    if (_sortReversed) {
      return sortedList.reversed.toList();
    }
    
    return sortedList;
  }

  Map<String, List<Skill>> _organizeSkills(List<Skill> skills) {
    final groups = <String, List<Skill>>{};
    
    for (final skill in skills) {
      String key;
      switch (_organization) {
        case SkillOrganization.none:
          key = 'Skills'; // Single group for all skills
          break;
          
        case SkillOrganization.byAttribute:
          final attributeName = getSkillAttribute(skill.name);
          key = attributeName ?? 'Unknown Attribute';
          break;
        
        case SkillOrganization.byCategory:
          key = skill.category?.isNotEmpty == true ? skill.category! : 'Uncategorized';
          break;
        
        case SkillOrganization.bySkillGroup:
          key = skill.skillGroupName.isNotEmpty ? skill.skillGroupName : 'No Skill Group';
          break;
          
        case SkillOrganization.alphabetical:
          // Group by first letter of skill name
          key = skill.name.isNotEmpty ? skill.name[0].toUpperCase() : 'Other';
          break;
      }
      
      groups.putIfAbsent(key, () => []).add(skill);
    }
    
    // Don't re-sort each group since we already sorted the entire list
    // The organization maintains the overall sort order
    
    return groups;
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Skills',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildFilterControls(BuildContext context) {
    final screenSize = ResponsiveLayout.getScreenSize(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Use vertical layout for phones or narrow screens
    if (screenSize == ScreenSize.phone || screenWidth < 600) {
      // Vertical layout for phone and narrow screens
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<SkillOrganization>(
                  value: _organization,
                  isExpanded: true, // Ensures dropdown fills available width
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _organization = value;
                      });
                    }
                  },
                  items: SkillOrganization.values.map((org) {
                    return DropdownMenuItem<SkillOrganization>(
                      value: org,
                      child: Text(
                        org.displayName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<SkillFilter>(
                  value: _filter,
                  isExpanded: true, // Ensures dropdown fills available width
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _filter = value;
                      });
                    }
                  },
                  items: SkillFilter.values.map((filter) {
                    return DropdownMenuItem<SkillFilter>(
                      value: filter,
                      child: Text(
                        filter.displayName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButton<SkillSort>(
                  value: _sort,
                  isExpanded: true, // Ensures dropdown fills available width
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sort = value;
                      });
                    }
                  },
                  items: SkillSort.values.map((sort) {
                    return DropdownMenuItem<SkillSort>(
                      value: sort,
                      child: Text(
                        sort.displayName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  setState(() {
                    _sortReversed = !_sortReversed;
                  });
                },
                icon: Icon(
                  _sortReversed ? Icons.arrow_upward : Icons.arrow_downward,
                  color: _sortReversed 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                tooltip: _sortReversed ? 'Sort Descending' : 'Sort Ascending',
              ),
            ],
          ),
        ],
      );
    }
    
    // Horizontal layout for larger screens
    return Row(
      children: [
        Expanded(
          flex: 2, // Give more space to organization dropdown
          child: DropdownButton<SkillOrganization>(
            value: _organization,
            isExpanded: true, // Ensures dropdown fills available width
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _organization = value;
                });
              }
            },
            items: SkillOrganization.values.map((org) {
              return DropdownMenuItem<SkillOrganization>(
                value: org,
                child: Text(
                  org.displayName,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 8), // Reduced spacing
        Expanded(
          flex: 2, // Give more space to filter dropdown
          child: DropdownButton<SkillFilter>(
            value: _filter,
            isExpanded: true, // Ensures dropdown fills available width
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _filter = value;
                });
              }
            },
            items: SkillFilter.values.map((filter) {
              return DropdownMenuItem<SkillFilter>(
                value: filter,
                child: Text(
                  filter.displayName,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 8), // Reduced spacing
        Expanded(
          flex: 1, // Less space for sort dropdown
          child: DropdownButton<SkillSort>(
            value: _sort,
            isExpanded: true, // Ensures dropdown fills available width
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _sort = value;
                });
              }
            },
            items: SkillSort.values.map((sort) {
              return DropdownMenuItem<SkillSort>(
                value: sort,
                child: Text(
                  sort.displayName,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 4), // Minimal spacing before icon
        IconButton(
          onPressed: () {
            setState(() {
              _sortReversed = !_sortReversed;
            });
          },
          icon: Icon(
            _sortReversed ? Icons.arrow_upward : Icons.arrow_downward,
            color: _sortReversed 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          tooltip: _sortReversed ? 'Sort Descending' : 'Sort Ascending',
        ),
      ],
    );
  }

  Widget _buildSkillGroup(BuildContext context, String category, List<Skill> skills) {
    if (skills.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            category,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildSkillGrid(context, skills),
      ],
    );
  }

  Widget _buildSkillGrid(BuildContext context, List<Skill> skills) {
    final screenSize = ResponsiveLayout.getScreenSize(context);
    final crossAxisCount = switch (screenSize) {
      ScreenSize.phone => 1,
      ScreenSize.tablet => 2,
      ScreenSize.desktop => 3,
      ScreenSize.fourK => 4,
    };

    // Use a flexible layout that can handle variable heights
    if (crossAxisCount == 1) {
      // On phone, use a simple column for better control
      return Column(
        children: skills.map((skill) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _buildSkillItem(context, skill),
        )).toList(),
      );
    } else {
      // For larger screens, use a staggered grid-like layout
      return LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - (8.0 * (crossAxisCount - 1))) / crossAxisCount;
          
          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: skills.map((skill) => SizedBox(
              width: itemWidth,
              child: _buildSkillItem(context, skill),
            )).toList(),
          );
        },
      );
    }
  }

  Widget _buildSkillItem(BuildContext context, Skill skill) {
    final skillName = skill.name;
    
    // Parse skill rating from the skill data
    // In Chummer, skills have base and karma, total = base + karma + skill group total
    final baseRating = int.tryParse(skill.base ?? '0') ?? 0;
    final karmaRating = int.tryParse(skill.karma ?? '0') ?? 0;
    final skillRating = baseRating + karmaRating + skill.skillGroupTotal;
    
    final attributeName = getSkillAttribute(skillName);
    final totalRating = calculateTotalSkillRating(
      skillName, 
      skillRating, 
      widget.character.attributes, 
      isPrioritySkill: skill.isPrioritySkill,
      conditionMonitorPenalty: widget.character.conditionMonitorPenalty,
    );
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: skill.isPrioritySkill 
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
            : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: skill.isPrioritySkill ? 2 : 1,
        ),
      ),
      child: IntrinsicHeight( // Allow card to expand to fit content
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              skillName,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: skill.isPrioritySkill ? FontWeight.bold : FontWeight.w500,
                                color: skill.isPrioritySkill 
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 2, // Allow skill name to wrap to 2 lines if needed
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (skill.isPrioritySkill)
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          if (_isSkillGroupBroken(skill))
                            Tooltip(
                              message: 'Skill group "${skill.skillGroupName}" is broken',
                              child: Icon(
                                Icons.warning,
                                size: 16,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          if (_isSkillDefaulting(skill))
                            Tooltip(
                              message: 'Using defaulting (${attributeName ?? "Attribute"} - 1)',
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          if (_isSkillUnusable(skill))
                            Tooltip(
                              message: 'Cannot default - skill unusable',
                              child: Icon(
                                Icons.block,
                                size: 16,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                        ],
                      ),
                      if (attributeName != null)
                        Text(
                          '($attributeName)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$totalRating',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getSkillRatingColor(context, skill),
                        ),
                      ),
                      _buildRatingBreakdown(context, skill, skillRating, totalRating),
                    ],
                  ),
                ),
              ],
            ),
            // Show specializations if any
            if (skill.specializations.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildSpecializations(context, skill),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBreakdown(BuildContext context, Skill skill, int skillRating, int totalRating) {
    final attributeName = getSkillAttribute(skill.name);
    if (attributeName == null) return const SizedBox.shrink();
    
    // Handle different calculation scenarios
    if (totalRating == 0) {
      // Skill is unusable (doesn't allow defaulting and has 0 points)
      return Text(
        '(unusable)',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.error,
          fontStyle: FontStyle.italic,
        ),
      );
    }
    
    if (skillRating == 0 && skillAllowsDefaulting(skill.name)) {
      // Skill is using defaulting
      final parts = <String>[];
      final attributeValue = widget.character.attributes
          .where((attr) => attr.name.toUpperCase() == attributeName)
          .firstOrNull?.totalValue ?? 0;
      
      parts.add('${attributeValue.round() - 1}'); // Attribute - 1
      if (skill.isPrioritySkill) {
        parts.add('2'); // Priority bonus
      }
      
      return Text(
        '(${parts.join(' + ')})',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      );
    }
    
    // Normal skill calculation (skill + attribute + priority)
    final parts = <String>[];
    parts.add('$skillRating'); // Skill points
    
    // Add attribute bonus
    final attributeValue = widget.character.attributes
        .where((attr) => attr.name.toUpperCase() == attributeName)
        .firstOrNull?.totalValue ?? 0;
    if (attributeValue > 0) {
      parts.add('${attributeValue.round()}');
    }
    
    // Add priority bonus if applicable
    if (skill.isPrioritySkill) {
      parts.add('2');
    }
    
    return Text(
      '(${parts.join(' + ')})',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildSpecializations(BuildContext context, Skill skill) {
    final screenSize = ResponsiveLayout.getScreenSize(context);
    
    // On phone screens, show specializations in a more compact format
    if (screenSize == ScreenSize.phone) {
      return _buildCompactSpecializations(context, skill);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Specializations:',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        ...skill.specializations.map((spec) => 
          _buildSpecializationItem(context, skill, spec)),
      ],
    );
  }

  Widget _buildCompactSpecializations(BuildContext context, Skill skill) {
    if (skill.specializations.isEmpty) return const SizedBox.shrink();
    
    final baseRating = int.tryParse(skill.base ?? '0') ?? 0;
    final karmaRating = int.tryParse(skill.karma ?? '0') ?? 0;
    final skillRating = baseRating + karmaRating + skill.skillGroupTotal;
    
    final specializedRating = calculateSpecializedSkillRating(
      skill.name,
      skillRating,
      widget.character.attributes,
      isPrioritySkill: skill.isPrioritySkill,
      hasSpecialization: true,
      conditionMonitorPenalty: widget.character.conditionMonitorPenalty,
    );
    
    // Show just the first specialization with count if multiple
    final firstSpec = skill.specializations.first;
    final specText = skill.specializations.length > 1 
        ? '${firstSpec.name} (+${skill.specializations.length - 1})'
        : firstSpec.name;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              specText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$specializedRating',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationItem(BuildContext context, Skill skill, SkillSpecialization spec) {
    final baseRating = int.tryParse(skill.base ?? '0') ?? 0;
    final karmaRating = int.tryParse(skill.karma ?? '0') ?? 0;
    final skillRating = baseRating + karmaRating + skill.skillGroupTotal;
    
    final specializedRating = calculateSpecializedSkillRating(
      skill.name,
      skillRating,
      widget.character.attributes,
      isPrioritySkill: skill.isPrioritySkill,
      hasSpecialization: true,
      conditionMonitorPenalty: widget.character.conditionMonitorPenalty,
    );
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
      margin: const EdgeInsets.only(bottom: 1.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '• ${spec.name}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$specializedRating',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// Check if a skill belongs to a broken skill group
  bool _isSkillGroupBroken(Skill skill) {
    if (skill.skillGroupName.isEmpty || skill.skillGroupTotal == 0) {
      return false; // Not part of a group or group has no points
    }
    
    return SkillGroupMap.isGroupBroken(
      skill.skillGroupName,
      widget.character.skills,
      skill.skillGroupTotal,
    );
  }

  /// Check if a skill is using defaulting (0 skill points but allows defaulting)
  bool _isSkillDefaulting(Skill skill) {
    final baseRating = int.tryParse(skill.base ?? '0') ?? 0;
    final karmaRating = int.tryParse(skill.karma ?? '0') ?? 0;
    final skillRating = baseRating + karmaRating + skill.skillGroupTotal;
    final priorityBonus = skill.isPrioritySkill ? 2 : 0;
    
    // Check if skill has no actual skill points (before attribute)
    final skillPointsTotal = skillRating + priorityBonus;
    
    // Only defaulting if no skill points, allows defaulting
    return skillPointsTotal == 0 && skillAllowsDefaulting(skill.name);
  }

  /// Check if a skill has no usable rating (0 total rating after all calculations)
  bool _isSkillUnusable(Skill skill) {
    final baseRating = int.tryParse(skill.base ?? '0') ?? 0;
    final karmaRating = int.tryParse(skill.karma ?? '0') ?? 0;
    final skillRating = baseRating + karmaRating + skill.skillGroupTotal;
    final priorityBonus = skill.isPrioritySkill ? 2 : 0;
    
    // Check if skill has no actual skill points (before attribute)
    final skillPointsTotal = skillRating + priorityBonus;
    
    // Only unusable if no skill points and can't default
    return skillPointsTotal == 0 && !skillAllowsDefaulting(skill.name);
  }

  /// Get the appropriate color for skill rating display
  Color _getSkillRatingColor(BuildContext context, Skill skill) {
    if (_isSkillUnusable(skill)) {
      return Theme.of(context).colorScheme.error;
    } else if (_isSkillDefaulting(skill)) {
      return Theme.of(context).colorScheme.tertiary;
    } else if (skill.isPrioritySkill) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.onSurface;
    }
  }
}
