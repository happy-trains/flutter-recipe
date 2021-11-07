import 'package:dartz/dartz.dart';

import '../entities/result.dart';
import '../entities/filter.dart';
import '../../../../core/error/failures.dart';

abstract class RecipesRepository {
  Future<Either<Failure, Result>> search({
    required String query,
    required int pageNumber,
    Filter? filter,
  });

  Future<Either<Failure, int>> getIndexSize();
}
