import 'package:equatable/equatable.dart';

import 'facet_count.dart';
import 'hit.dart';
import 'request_params.dart';

class Result extends Equatable {
  final List<FacetCount> facetCounts;
  final int found;
  final List<Hit> hits;
  final int outOf;
  final int page;
  final RequestParams requestParams;
  final Duration searchTime;

  const Result({
    required this.facetCounts,
    required this.found,
    required this.hits,
    required this.outOf,
    required this.page,
    required this.requestParams,
    required this.searchTime,
  });

  @override
  List<Object?> get props =>
      [facetCounts, found, hits, outOf, page, requestParams, searchTime];
}
