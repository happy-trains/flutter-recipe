import '../../data/models/result_model.dart';
import '../../../../core/error/exception.dart';

abstract class RecipesLocalDataSource {
  /// Gets the cached [ResultModel].
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<ResultModel> getLastResult();
  Future<void> cacheResult(ResultModel resultModel);

  /// Gets the cached index size.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<int> getLastIndexSize();
  Future<void> cacheIndexSize(int indexSize);
}
