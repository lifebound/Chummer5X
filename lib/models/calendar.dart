class CalendarWeek {
  final String guid;
  final int year;
  final int week;
  final String? notes;
  final String? notesColor;

  const CalendarWeek({
    required this.guid,
    required this.year,
    required this.week,
    this.notes,
    this.notesColor,
  });

  factory CalendarWeek.fromXml(Map<String, dynamic> xmlData) {
    return CalendarWeek(
      guid: xmlData['guid'] ?? '',
      year: int.tryParse(xmlData['year']?.toString() ?? '0') ?? 0,
      week: int.tryParse(xmlData['week']?.toString() ?? '0') ?? 0,
      notes: xmlData['notes']?.toString().trim().isEmpty == true 
          ? null 
          : xmlData['notes']?.toString(),
      notesColor: xmlData['notesColor']?.toString(),
    );
  }

  factory CalendarWeek.fromJson(Map<String, dynamic> json) {
    return CalendarWeek(
      guid: json['guid'] ?? '',
      year: json['year'] ?? 0,
      week: json['week'] ?? 0,
      notes: json['notes'],
      notesColor: json['notesColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guid': guid,
      'year': year,
      'week': week,
      'notes': notes,
      'notesColor': notesColor,
    };
  }

  String toXml() {
    return '''
    <week>
      <guid>$guid</guid>
      <year>$year</year>
      <week>$week</week>
      <notes>${notes ?? ''}</notes>
      <notesColor>${notesColor ?? ''}</notesColor>
    </week>''';
  }

  /// Check if this week has any content (notes)
  bool get hasContent => notes?.isNotEmpty == true;

  /// Get a formatted string for display (e.g., "2072 Week 3")
  String get displayText => '$year Week $week';

  CalendarWeek copyWith({
    String? guid,
    int? year,
    int? week,
    String? notes,
    String? notesColor,
  }) {
    return CalendarWeek(
      guid: guid ?? this.guid,
      year: year ?? this.year,
      week: week ?? this.week,
      notes: notes ?? this.notes,
      notesColor: notesColor ?? this.notesColor,
    );
  }
}

class Calendar {
  final List<CalendarWeek> weeks;

  const Calendar({
    this.weeks = const [],
  });

  factory Calendar.fromXml(List<Map<String, dynamic>> xmlWeeks) {
    return Calendar(
      weeks: xmlWeeks.map((weekData) => CalendarWeek.fromXml(weekData)).toList(),
    );
  }

  factory Calendar.fromJson(Map<String, dynamic> json) {
    final weeksList = json['weeks'] as List<dynamic>? ?? [];
    return Calendar(
      weeks: weeksList
          .map((weekJson) => CalendarWeek.fromJson(weekJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weeks': weeks.map((week) => week.toJson()).toList(),
    };
  }

  String toXml() {
    if (weeks.isEmpty) {
      return '<calendar></calendar>';
    }

    final weekXml = weeks.map((week) => week.toXml()).join('\n');
    return '''
  <calendar>
$weekXml
  </calendar>''';
  }

  /// Get weeks that have content (notes)
  List<CalendarWeek> get weeksWithContent => 
      weeks.where((week) => week.hasContent).toList();

  /// Get weeks sorted by year and week number
  List<CalendarWeek> get sortedWeeks {
    final sorted = List<CalendarWeek>.from(weeks);
    sorted.sort((a, b) {
      final yearComparison = a.year.compareTo(b.year);
      if (yearComparison != 0) return yearComparison;
      return a.week.compareTo(b.week);
    });
    return sorted;
  }

  /// Find a specific week by year and week number
  CalendarWeek? findWeek(int year, int week) {
    return weeks.where((w) => w.year == year && w.week == week).firstOrNull;
  }

  Calendar copyWith({
    List<CalendarWeek>? weeks,
  }) {
    return Calendar(
      weeks: weeks ?? this.weeks,
    );
  }
}
