import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../entities/result.dart';
import '../entities/filter.dart';
import '../repositories/recipes_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class SearchRecipes implements UseCase<Result, Params> {
  final RecipesRepository repository;

  SearchRecipes(this.repository);

  @override
  Future<Either<Failure, Result>> call(Params params) => repository.search(
        query: params.query,
        pageNumber: params.pageNumber,
        filter: params.filter,
      );
}

class Params extends Equatable {
  final String query;
  final int pageNumber;
  final Filter? filter;

  Params({required this.query, required this.pageNumber, this.filter});

  @override
  List<Object?> get props => [query, pageNumber, filter];
}
