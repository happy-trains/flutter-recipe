import 'package:typesense/typesense.dart';

import '../../../../core/error/exception.dart';
import '../../data/models/result_model.dart';
import '../models/filter_model.dart';

abstract class RecipesRemoteDataSource {
  /// Uses Typsense to get data.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ResultModel> search({
    required String query,
    required List<String> queryBy,
    required int pageNumber,
    FilterModel? filter,
    List<String>? facetBy,
    int? maxFacetValues,
    int? perPage,
  });

  /// Uses Typsense to get data.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<int> getIndexSize();
}

class RecipesRemoteDataSourceImpl implements RecipesRemoteDataSource {
  final Client typesenseClient;

  RecipesRemoteDataSourceImpl(this.typesenseClient);

  @override
  Future<int> getIndexSize() async {
    try {
      final result =
          await typesenseClient.collection('r').documents.search({'q': '*'});

      return ResultModel.fromJson(result).found;
    } on TypesenseException catch (_) {
      throw ServerException();
    }
  }

  Map<String, dynamic> generateSearchParameters({
    required String query,
    required List<String> queryBy,
    required int pageNumber,
    FilterModel? filter,
    List<String>? facetBy,
    int? maxFacetValues,
    int? perPage,
  }) {
    final searchParameters = <String, dynamic>{};

    searchParameters.addAll({
      'q': query,
      'query_by': queryBy.join(','),
      'page': pageNumber,
    });

    if (filter != null) {
      searchParameters.addAll(filter.toApiSearchParameters());
    }

    if (facetBy != null) {
      searchParameters.addAll({'facet_by': facetBy.join(',')});
    }

    if (maxFacetValues != null) {
      searchParameters.addAll({'max_facet_values': maxFacetValues});
    }

    if (perPage != null) {
      searchParameters.addAll({'per_page': perPage});
    }

    return searchParameters;
  }

  @override
  Future<ResultModel> search({
    required String query,
    required List<String> queryBy,
    required int pageNumber,
    FilterModel? filter,
    List<String>? facetBy,
    int? maxFacetValues,
    int? perPage,
  }) async {
    try {
      final result = await typesenseClient
          .collection('r')
          .documents
          .search(generateSearchParameters(
            query: query,
            queryBy: queryBy,
            pageNumber: pageNumber,
            filter: filter,
            facetBy: facetBy,
            maxFacetValues: maxFacetValues,
            perPage: perPage,
          ));

      return ResultModel.fromJson(result);
    } on TypesenseException catch (_) {
      throw ServerException();
    }
  }
}
