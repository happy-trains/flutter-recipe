class Facet {
  /// count
  final int documentCount;
  final String highlighted;
  final String value;

  Facet({
    required this.documentCount,
    required this.highlighted,
    required this.value,
  });

  factory Facet.fromJson(Map<String, dynamic> json) => Facet(
        documentCount: json['count'],
        highlighted: json['highlighted'],
        value: json['value'],
      );
}
