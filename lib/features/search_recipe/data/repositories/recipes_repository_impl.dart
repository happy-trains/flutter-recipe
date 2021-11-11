import 'package:dartz/dartz.dart';

import '../../domain/entities/result.dart';
import '../../domain/entities/filter.dart';
import '../../domain/repositories/recipes_repository.dart';
import '../../data/datasources/recipes_local_data_source.dart';
import '../../data/datasources/recipes_remote_data_source.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/network/network_info.dart';

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
  Future<Either<Failure, Result>> search(
      {required String query, required int pageNumber, Filter? filter}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.search(
            query: query, pageNumber: pageNumber, filter: filter);

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
