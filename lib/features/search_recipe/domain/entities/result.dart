import 'facet_counts.dart';
import 'hit.dart';
import 'request_params.dart';

class Result {
  final List<FacetCounts> facetCounts;
  final int found;
  final List<Hit> hits;
  final int outOf;
  final int page;
  final RequestParams requestParams;
  final Duration searchTime;

  Result({
    required this.facetCounts,
    required this.found,
    required this.hits,
    required this.outOf,
    required this.page,
    required this.requestParams,
    required this.searchTime,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    final facetCounts = (json['facet_counts'] as List)
        .map((f) => FacetCounts.fromJson(f))
        .toList();
    final hits = (json['hits'] as List).map((h) => Hit.fromJson(h)).toList();
    final requestParams = RequestParams.fromJson(json['request_params']);
    final searchTime = Duration(milliseconds: json['search_time_ms']);

    return Result(
      facetCounts: facetCounts,
      found: json['found'],
      hits: hits,
      outOf: json['out_of'],
      page: json['page'],
      requestParams: requestParams,
      searchTime: searchTime,
    );
  }
}
