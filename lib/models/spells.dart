class Spell {
  final String name;
  final String category;
  final String range;
  final String duration;
  final String drain;
  final String source;
  final String page;
  final String description;
  final String? improvementSource; // Keep for backwards compatibility
  final String? grade; // Keep for backwards compatibility

  const Spell({
    required this.name,
    required this.category,
    this.range = '',
    this.duration = '',
    this.drain = '',
    this.source = '',
    this.page = '',
    this.description = '',
    this.improvementSource,
    this.grade,
  });

  factory Spell.fromJson(Map<String, dynamic> json) => Spell(
    name: json['name'] ?? '',
    category: json['category'] ?? '',
    range: json['range'] ?? '',
    duration: json['duration'] ?? '',
    drain: json['drain'] ?? '',
    source: json['source'] ?? '',
    page: json['page'] ?? '',
    description: json['description'] ?? '',
    improvementSource: json['improvementsource'],
    grade: json['grade'],
  );

  // Utility getters
  String get displayName => name;
  bool get hasCompleteInfo => 
    name.isNotEmpty && 
    range.isNotEmpty && 
    duration.isNotEmpty && 
    drain.isNotEmpty && 
    source.isNotEmpty;
}