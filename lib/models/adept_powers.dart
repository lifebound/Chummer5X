class AdeptPower {
  final String name;
  // TODO: This should be int? instead of String? - rating is always an integer
  final String? rating;
  final String? extra;
  final double? pointsPerLevel; // Optional field for points per level
  final double? extraPointCost; // Optional field for extra point cost
  final bool? hasLevels; // Indicates if the power has levels
  final int? maxLevels; // Maximum levels for the power, if applicable
  final String? action; // Optional action type for the power
  final bool? discounted; // Indicates if the power is discounted
  final String source; // source for the power
  final String page; // page for the power
  final String? description; // Optional description for the power
  final Map<String, String>? bonus;


  const AdeptPower({
    required this.name,
    this.rating,
    this.extra,
    this.pointsPerLevel,
    this.extraPointCost,
    this.hasLevels,
    this.maxLevels,
    this.action,
    this.discounted,
    required this.source,
    required this.page,
    this.description,
    this.bonus,
    
  });

  factory AdeptPower.fromJson(Map<String, dynamic> json) {
    //debugPrint('Parsing AdeptPower from JSON: $json');
    return AdeptPower(
      name: json['name'] ?? '',
      rating: json['rating']?.toString(),
      extra: json['extra'],
      source: json['source'] ?? '',
      page: json['page'] ?? '',
      bonus: (json['bonus'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      pointsPerLevel: json['pointsperlevel'] != null
          ? double.tryParse(json['pointsperlevel'].toString())
          : null,
      extraPointCost: json['extrapointcost'] != null
          ? double.tryParse(json['extrapointcost'].toString())
          : null,
      hasLevels: json['haslevels'] == true,
      maxLevels: json['maxlevels'] != null
          ? int.tryParse(json['maxlevels'].toString())
          : null,
      action: json['action'],
      discounted: json['discounted'] == true,
      description: json['description'],
    );
  }

  String get displayName => name;
  bool get hasCompleteInfo => 
    name.isNotEmpty && 
    rating != null &&
    source.isNotEmpty&&
    page.isNotEmpty;
}
