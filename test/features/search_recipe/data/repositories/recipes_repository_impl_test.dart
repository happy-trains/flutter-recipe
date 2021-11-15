import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:recipe/core/error/exception.dart';
import 'package:recipe/core/error/failures.dart';
import 'package:recipe/core/network/network_info.dart';
import 'package:recipe/features/search_recipe/data/datasources/recipes_local_data_source.dart';
import 'package:recipe/features/search_recipe/data/datasources/recipes_remote_data_source.dart';
import 'package:recipe/features/search_recipe/data/models/filter_model.dart';
import 'package:recipe/features/search_recipe/data/models/result_model.dart';
import 'package:recipe/features/search_recipe/data/repositories/recipes_repository_impl.dart';
import 'package:recipe/features/search_recipe/domain/entities/result.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'recipes_repository_impl_test.mocks.dart';

@GenerateMocks([RecipesRemoteDataSource, RecipesLocalDataSource, NetworkInfo])
void main() {
  late RecipesRepositoryImpl repository;
  late MockRecipesRemoteDataSource mockRemoteDataSource;
  late MockRecipesLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRecipesRemoteDataSource();
    mockLocalDataSource = MockRecipesLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RecipesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() => when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) => Future.value(true)));

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() => when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) => Future.value(false)));

      body();
    });
  }

  group('search', () {
    final searchQuery = 'Pizza';
    final pageNumber = 1;
    final filter = FilterModel(
      fieldName: 'ingredient_names',
      filterValues: ['salt'],
    );
    final tResultModel =
        ResultModel.fromJson(jsonDecode(fixture('result.json')));
    final Result tResult = tResultModel;

    setUp(() {
      when(mockRemoteDataSource.search(
        query: searchQuery,
        pageNumber: pageNumber,
        filter: filter,
      )).thenAnswer((_) => Future.value(tResultModel));
    });

    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) => Future.value(true));
        // act
        repository.search(
          query: searchQuery,
          pageNumber: pageNumber,
          filter: filter,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // act
          final result = await repository.search(
            query: searchQuery,
            pageNumber: pageNumber,
            filter: filter,
          );
          // assert
          verify(mockRemoteDataSource.search(
            query: searchQuery,
            pageNumber: pageNumber,
            filter: filter,
          ));
          expect(result, equals(Right(tResult)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // act
          await repository.search(
            query: searchQuery,
            pageNumber: pageNumber,
            filter: filter,
          );
          // assert
          verify(mockRemoteDataSource.search(
            query: searchQuery,
            pageNumber: pageNumber,
            filter: filter,
          ));
          verify(mockLocalDataSource.cacheResult(tResultModel));
        },
      );

      test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.search(
            query: searchQuery,
            pageNumber: pageNumber,
            filter: filter,
          )).thenThrow(ServerException());
          // act
          final result = await repository.search(
            query: searchQuery,
            pageNumber: pageNumber,
            filter: filter,
          );
          // assert
          verify(mockRemoteDataSource.search(
            query: searchQuery,
            pageNumber: pageNumber,
            filter: filter,
          ));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastResult())
              .thenAnswer((_) => Future.value(tResultModel));
          // act
          final result = await repository.search(
            query: searchQuery,
            pageNumber: pageNumber,
            filter: filter,
          );
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastResult());
          expect(result, equals(Right(tResult)));
        },
      );
      test(
        'should return CacheFailure when no cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastResult()).thenThrow(CacheException());
          // act
          final result = await repository.search(
            query: searchQuery,
            pageNumber: pageNumber,
            filter: filter,
          );
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastResult());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getIndexSize', () {
    final tResult = 2231142;

    setUp(() {
      when(mockRemoteDataSource.getIndexSize())
          .thenAnswer((_) => Future.value(tResult));
    });

    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) => Future.value(true));
        // act
        repository.getIndexSize();
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // act
          final result = await repository.getIndexSize();
          // assert
          verify(mockRemoteDataSource.getIndexSize());
          expect(result, equals(Right(tResult)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // act
          await repository.getIndexSize();
          // assert
          verify(mockRemoteDataSource.getIndexSize());
          verify(mockLocalDataSource.cacheIndexSize(tResult));
        },
      );

      test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getIndexSize())
              .thenThrow(ServerException());
          // act
          final result = await repository.getIndexSize();
          // assert
          verify(mockRemoteDataSource.getIndexSize());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastIndexSize())
              .thenAnswer((_) => Future.value(tResult));
          // act
          final result = await repository.getIndexSize();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastIndexSize());
          expect(result, equals(Right(tResult)));
        },
      );

      test(
        'should return CacheFailure when no cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastIndexSize())
              .thenThrow(CacheException());
          // act
          final result = await repository.getIndexSize();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastIndexSize());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
