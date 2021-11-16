import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/filter_model.dart';
import '../entities/result.dart';
import '../repositories/recipes_repository.dart';

class SearchRecipes implements UseCase<Result, Params> {
  final RecipesRepository repository;

  SearchRecipes(this.repository);

  @override
  Future<Either<Failure, Result>> call(Params params) => repository.search(
        query: params.query,
        queryBy: params.queryBy,
        pageNumber: params.pageNumber,
        filter: params.filter,
        facetBy: params.facetBy,
        maxFacetValues: params.maxFacetValues,
        perPage: params.perPage,
      );
}

class Params extends Equatable {
  final String query;
  final List<String> queryBy;
  final int pageNumber;
  final FilterModel? filter;
  final List<String>? facetBy;
  final int? maxFacetValues;
  final int? perPage;

  Params({
    required this.query,
    required this.queryBy,
    required this.pageNumber,
    this.filter,
    this.facetBy,
    this.maxFacetValues,
    this.perPage,
  });

  @override
  List<Object?> get props => [
        query,
        queryBy,
        pageNumber,
        filter,
        facetBy,
        maxFacetValues,
        perPage,
      ];
}
