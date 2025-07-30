class Attribute {
  final String name;
  final String metatypeCategory;
  final double totalValue;
  final double metatypeMin;
  final double metatypeMax;
  final double metatypeAugMax;
  final double base;
  final double karma;
  final double? adeptMod;

  const Attribute({
    required this.name,
    required this.metatypeCategory,
    required this.totalValue,
    required this.metatypeMin,
    required this.metatypeMax,
    required this.metatypeAugMax,
    required this.base,
    required this.karma,
    this.adeptMod,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      name: json['name'] ?? '',
      metatypeCategory: json['metatypecategory'] ?? '',
      totalValue: double.tryParse(json['totalvalue']?.toString() ?? '0') ?? 0.0,
      metatypeMin: double.tryParse(json['metatypemin']?.toString() ?? '0') ?? 0.0,
      metatypeMax: double.tryParse(json['metatypemax']?.toString() ?? '0') ?? 0.0,
      metatypeAugMax: double.tryParse(json['metatypeaugmax']?.toString() ?? '0') ?? 0.0,
      base: double.tryParse(json['base']?.toString() ?? '0') ?? 0.0,
      karma: double.tryParse(json['karma']?.toString() ?? '0') ?? 0.0,
    );
  }

  Attribute copyWith({double? adeptMod}) {
    return Attribute(
      name: name,
      metatypeCategory: metatypeCategory,
      totalValue: totalValue,
      metatypeMin: metatypeMin,
      metatypeMax: metatypeMax,
      metatypeAugMax: metatypeAugMax,
      base: base,
      karma: karma,
      adeptMod: adeptMod ?? this.adeptMod,
    );
  }
}