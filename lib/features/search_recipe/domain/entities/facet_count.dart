import 'package:equatable/equatable.dart';

import 'facet.dart';

class FacetCount extends Equatable {
  /// counts
  final List<Facet> facets;
  final String fieldName;
// final	Stats stats;

  FacetCount({
    required this.facets,
    required this.fieldName,
    // required  this.stats,
  });

  @override
  List<Object?> get props => [facets, fieldName];
}
