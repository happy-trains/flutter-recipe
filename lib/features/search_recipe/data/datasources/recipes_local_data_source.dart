import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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

class RecipesLocalDataSourceImpl implements RecipesLocalDataSource {
  final SharedPreferences _sharedPreferences;

  RecipesLocalDataSourceImpl(this._sharedPreferences);

  // ignore: constant_identifier_names
  static const CACHED_RESULT = 'RECIPES_CACHED_RESULT';

  // ignore: constant_identifier_names
  static const CACHED_INDEX_SIZE = 'INDEX_SIZE_CACHED_RESULT';

  @override
  Future<ResultModel> getLastResult() {
    final json = _sharedPreferences.getString(CACHED_RESULT);

    if (json == null) {
      throw CacheException();
    }

    return Future.value(ResultModel.fromJson(jsonDecode(json)));
  }

  @override
  Future<void> cacheResult(ResultModel resultModel) async {
    _sharedPreferences.setString(
      CACHED_RESULT,
      jsonEncode(
        resultModel.toJson(),
      ),
    );
  }

  @override
  Future<int> getLastIndexSize() {
    final size = _sharedPreferences.getInt(CACHED_INDEX_SIZE);

    if (size == null) {
      throw CacheException();
    }

    return Future.value(size);
  }

  @override
  Future<void> cacheIndexSize(int indexSize) async {
    _sharedPreferences.setInt(
      CACHED_INDEX_SIZE,
      indexSize,
    );
  }
}
