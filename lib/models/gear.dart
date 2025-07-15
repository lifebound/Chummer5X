class Gear {
  final String? guid;
  final dynamic name;
  final dynamic category;
  final dynamic rating;
  final bool equipped;
  final dynamic quantity;
  final String source;
  final List<Gear>? children;

  const Gear({
    this.guid,
    this.name,
    this.category,
    this.rating,
    this.equipped = false,
    this.quantity,
    this.source = '',
    this.children,
  });

  Gear copyWith({List<Gear>? children}) {
    return Gear(
      guid: guid,
      name: name,
      category: category,
      rating: rating,
      equipped: equipped,
      quantity: quantity,
      source: source,
      children: children ?? this.children,
    );
  }
}
