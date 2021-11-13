import 'facet_model.dart';

import '../../domain/entities/facet_count.dart';

class FacetCountModel extends FacetCount {
  FacetCountModel({
    required List<FacetModel> facets,
    required String fieldName,
  }) :
        // _facets = facets,
        super(facets: facets, fieldName: fieldName);

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

  Map<String, dynamic> toJson() {
    final list = facets.cast<FacetModel>().map((f) => f.toJson()).toList();

    return {
      'counts': list,
      'field_name': fieldName,
    };
  }
}
