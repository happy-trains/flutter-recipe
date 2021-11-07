import 'package:dartz/dartz.dart';

import '../entities/result.dart';
import '../entities/filter.dart';
import '../repositories/recipes_repository.dart';
import '../../../../core/error/failures.dart';

class SearchRecipes {
  final RecipesRepository repository;

  SearchRecipes(this.repository);

  Future<Either<Failure, Result>> execute({
    required String query,
    required int pageNumber,
    Filter? filter,
  }) =>
      repository.search(query: query, pageNumber: pageNumber, filter: filter);
}
