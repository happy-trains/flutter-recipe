import 'facet_model.dart';

import '../../domain/entities/facet_count.dart';
import '../../domain/entities/facet.dart';

class FacetCountModel extends FacetCount {
  FacetCountModel({
    required List<Facet> facets,
    required String fieldName,
    // required  this.stats,
  }) : super(facets: facets, fieldName: fieldName);

  factory FacetCountModel.fromJson(Map<String, dynamic> json) {
    final facets =
        (json['counts'] as List).map((c) => FacetModel.fromJson(c)).toList();

    // final	stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;

    return FacetCountModel(
      facets: facets,
      fieldName: json['field_name'],
// stats: stats,
    );
  }
}
