enum QualityType {
  positive,
  negative
} 
class Quality{
  final String name;
  final String source;
  final String page;
  final int karmaCost;
  final QualityType qualityType;

  const Quality({
    required this.name,
    required this.source,
    required this.page,
    required this.karmaCost,
    required this.qualityType,
  });
}