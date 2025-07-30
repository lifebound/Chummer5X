class LimitModifier {
  final String? limit;
  final dynamic value;
  final dynamic bonus;
  final String? source;
  final String? condition;
  final String? name;

  const LimitModifier({
    this.limit,
    this.value,
    this.source,
    this.condition,
    this.bonus,
    this.name,
  });

  factory LimitModifier.fromJson(Map<String, dynamic> json) {
    return LimitModifier(
      limit: json['limit'],
      value: json['value'],
      bonus: json['bonus'],
      source: json['source'],
      condition: json['condition'],
      name: json['name'],
    );
  }
}

class LimitDetail {
  final int total;
  final List<LimitModifier> modifiers;
  final double? adeptMod;

  const LimitDetail({
    required this.total,
    required this.modifiers,
    this.adeptMod,
  });

  LimitDetail copyWith({int? total, List<LimitModifier>? modifiers, double? adeptMod}) {
    return LimitDetail(
      total: total ?? this.total,
      modifiers: modifiers ?? this.modifiers,
      adeptMod: adeptMod ?? this.adeptMod,
    );
  }
}