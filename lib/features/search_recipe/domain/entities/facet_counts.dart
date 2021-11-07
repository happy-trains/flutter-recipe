import 'facet.dart';

class FacetCounts {
  /// counts
  final List<Facet> facets;
  final String fieldName;
// final	Stats stats;

  FacetCounts({
    required this.facets,
    required this.fieldName,
    // required  this.stats,
  });

  factory FacetCounts.fromJson(Map<String, dynamic> json) {
    final facets =
        (json['counts'] as List).map((c) => Facet.fromJson(c)).toList();

    // final	stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;

    return FacetCounts(
      facets: facets,
      fieldName: json['field_name'],
// stats: stats,
    );
  }
}
