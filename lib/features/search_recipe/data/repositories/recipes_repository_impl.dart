import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/recipes_local_data_source.dart';
import '../../data/datasources/recipes_remote_data_source.dart';
import '../../domain/entities/result.dart';
import '../../domain/repositories/recipes_repository.dart';
import '../models/filter_model.dart';

class RecipesRepositoryImpl implements RecipesRepository {
  final RecipesRemoteDataSource remoteDataSource;
  final RecipesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RecipesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Result>> search({
    required String query,
    required List<String> queryBy,
    required int pageNumber,
    FilterModel? filter,
    List<String>? facetBy,
    int? maxFacetValues,
    int? perPage,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.search(
          query: query,
          queryBy: queryBy,
          pageNumber: pageNumber,
          filter: filter,
          facetBy: facetBy,
          maxFacetValues: maxFacetValues,
          perPage: perPage,
        );

        localDataSource.cacheResult(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastResult());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, int>> getIndexSize() async {
    if (await networkInfo.isConnected) {
      try {
        final indexSize = await remoteDataSource.getIndexSize();

        localDataSource.cacheIndexSize(indexSize);
        return Right(indexSize);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastIndexSize());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
