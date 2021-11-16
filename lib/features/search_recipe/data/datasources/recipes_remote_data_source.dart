import '../../../../core/error/exception.dart';
import '../../data/models/result_model.dart';
import '../models/filter_model.dart';

abstract class RecipesRemoteDataSource {
  /// Uses Typsense to get data.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ResultModel> search(
      {required String query,
      required List<String> queryBy,
      required int pageNumber,
      FilterModel? filter});

  /// Uses Typsense to get data.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<int> getIndexSize();
}
