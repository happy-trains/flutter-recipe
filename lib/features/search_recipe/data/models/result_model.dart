import 'request_params_model.dart';
import 'facet_count_model.dart';
import 'hit_model.dart';
import '../../domain/entities/result.dart';
import '../../domain/entities/request_params.dart';
import '../../domain/entities/facet_count.dart';
import '../../domain/entities/hit.dart';

class ResultModel extends Result {
  ResultModel({
    required List<FacetCount> facetCounts,
    required int found,
    required List<Hit> hits,
    required int outOf,
    required int page,
    required RequestParams requestParams,
    required Duration searchTime,
  }) : super(
            facetCounts: facetCounts,
            found: found,
            hits: hits,
            outOf: outOf,
            page: page,
            requestParams: requestParams,
            searchTime: searchTime);

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    final facetCounts = (json['facet_counts'] as List)
        .map((f) => FacetCountModel.fromJson(f))
        .toList();
    final hits =
        (json['hits'] as List).map((h) => HitModel.fromJson(h)).toList();
    final requestParams = RequestParamsModel.fromJson(json['request_params']);
    final searchTime = Duration(milliseconds: json['search_time_ms']);

    return ResultModel(
      facetCounts: facetCounts,
      found: json['found'],
      hits: hits,
      outOf: json['out_of'],
      page: json['page'],
      requestParams: requestParams,
      searchTime: searchTime,
    );
  }

  Map<String, dynamic> toJson() {
    final _facetCounts =
        facetCounts.cast<FacetCountModel>().map((f) => f.toJson()).toList();
    final _hits = hits.cast<HitModel>().map((h) => h.toJson()).toList();
    final _requestParams = (requestParams as RequestParamsModel).toJson();
    final _searchTime = searchTime.inMilliseconds;

    return {
      'facet_counts': _facetCounts,
      'found': found,
      'hits': _hits,
      'out_of': outOf,
      'page': page,
      'request_params': _requestParams,
      'search_time_ms': _searchTime,
    };
  }
}
