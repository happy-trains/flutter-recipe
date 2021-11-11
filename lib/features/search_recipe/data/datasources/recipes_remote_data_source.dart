import '../../data/models/result_model.dart';
import '../../domain/entities/filter.dart';
import '../../../../core/error/exception.dart';

abstract class RecipesRemoteDataSource {
  /// Uses Typsense to get data.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ResultModel> search(
      {required String query, required int pageNumber, Filter? filter});

  /// Uses Typsense to get data.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<int> getIndexSize();
}
