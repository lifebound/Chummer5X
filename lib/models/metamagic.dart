class Metamagic{
  final String name;
  final String source;
  final String page;
  final String improvementSource;
  final int grade;
  // bonuses need to be handled here, but they're complex, so that's for another time.
  final Map<String, int> bonuses;

  const Metamagic({
    required this.name,
    required this.source,
    required this.page,
    required this.improvementSource,
    required this.grade,
    this.bonuses = const {},
  });

  factory Metamagic.fromJson(Map<String, dynamic> json) {
    return Metamagic(
      name: json['name']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      page: json['page']?.toString() ?? '',
      improvementSource: json['improvementSource']?.toString() ?? '',
      grade: int.tryParse(json['grade']?.toString() ?? '0') ?? 0,
      bonuses: (json['bonuses'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, int.tryParse(value.toString()) ?? 0)) ?? {},
    );
  }
}