import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/filter_model.dart';
import '../entities/result.dart';

abstract class RecipesRepository {
  Future<Either<Failure, Result>> search({
    required String query,
    required List<String> queryBy,
    required int pageNumber,
    FilterModel? filter,
  });

  Future<Either<Failure, int>> getIndexSize();
}
