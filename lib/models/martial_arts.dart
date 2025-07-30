class MartialArtTechnique {
  final String sourceId;
  final String guid;
  final String name;
  final String notes;
  final String notesColor;
  final String source;
  final String page;

  const MartialArtTechnique({
    required this.sourceId,
    required this.guid,
    required this.name,
    this.notes = '',
    this.notesColor = '',
    this.source = '',
    this.page = '',
  });

  factory MartialArtTechnique.fromXml(Map<String, dynamic> xml) {
    return MartialArtTechnique(
      sourceId: xml['sourceid'] ?? '',
      guid: xml['guid'] ?? '',
      name: xml['name'] ?? '',
      notes: xml['notes'] ?? '',
      notesColor: xml['notesColor'] ?? '',
      source: xml['source'] ?? '',
      page: xml['page'] ?? '',
    );
  }

  @override
  String toString() {
    return 'MartialArtTechnique{name: $name, source: $source, page: $page}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MartialArtTechnique &&
          runtimeType == other.runtimeType &&
          sourceId == other.sourceId &&
          guid == other.guid &&
          name == other.name;

  @override
  int get hashCode => sourceId.hashCode ^ guid.hashCode ^ name.hashCode;
}

class MartialArt {
  final String name;
  final String sourceId;
  final String guid;
  final String source;
  final String page;
  final int cost;
  final bool isQuality;
  final List<MartialArtTechnique> techniques;
  final String notes;
  final String notesColor;

  const MartialArt({
    required this.name,
    required this.sourceId,
    required this.guid,
    this.source = '',
    this.page = '',
    this.cost = 0,
    this.isQuality = false,
    this.techniques = const [],
    this.notes = '',
    this.notesColor = '',
  });

  factory MartialArt.fromXml(Map<String, dynamic> xml) {
    // Parse techniques from martialarttechniques section
    List<MartialArtTechnique> techniquesList = [];
    
    final techniqueNode = xml['martialarttechniques'];
    if (techniqueNode != null) {
      final techniqueData = techniqueNode['martialarttechnique'];
      if (techniqueData != null) {
        if (techniqueData is List) {
          // Multiple techniques
          for (final tech in techniqueData) {
            if (tech is Map<String, dynamic>) {
              techniquesList.add(MartialArtTechnique.fromXml(tech));
            }
          }
        } else if (techniqueData is Map<String, dynamic>) {
          // Single technique
          techniquesList.add(MartialArtTechnique.fromXml(techniqueData));
        }
      }
    }

    return MartialArt(
      name: xml['name'] ?? '',
      sourceId: xml['sourceid'] ?? '',
      guid: xml['guid'] ?? '',
      source: xml['source'] ?? '',
      page: xml['page'] ?? '',
      cost: int.tryParse(xml['cost']?.toString() ?? '0') ?? 0,
      isQuality: xml['isquality']?.toString().toLowerCase() == 'true',
      techniques: techniquesList,
      notes: xml['notes'] ?? '',
      notesColor: xml['notesColor'] ?? '',
    );
  }

  @override
  String toString() {
    return 'MartialArt{name: $name, cost: $cost, techniques: ${techniques.length}, source: $source, page: $page}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MartialArt &&
          runtimeType == other.runtimeType &&
          sourceId == other.sourceId &&
          guid == other.guid &&
          name == other.name;

  @override
  int get hashCode => sourceId.hashCode ^ guid.hashCode ^ name.hashCode;
}
