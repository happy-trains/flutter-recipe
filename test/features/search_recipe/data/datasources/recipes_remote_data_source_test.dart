import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/features/search_recipe/data/models/filter_model.dart';
import 'package:typesense/typesense.dart';
import 'package:mockito/annotations.dart';
import 'package:recipe/features/search_recipe/data/datasources/recipes_remote_data_source.dart';

import 'recipes_remote_data_source_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late MockClient mockClient;
  late RecipesRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockClient = MockClient();
    remoteDataSource = RecipesRemoteDataSourceImpl(mockClient);
  });

  group('generateSearchParameters', () {
    test(
      'should return search parameters as map',
      () async {
        // arrange
        final searchParameters = {
          'q': 'Pizza',
          'query_by': 'title',
          'facet_by': 'ingredient_names',
          'max_facet_values': '1',
          'filter_by': 'ingredient_names:=[`salt`]',
          'page': '1',
          'per_page': '1'
        };
        // act
        final map = remoteDataSource.generateSearchParameters(
          query: 'Pizza',
          queryBy: ['title'],
          pageNumber: 1,
          filter: FilterModel(
              fieldName: 'ingredient_names', filterValues: ['salt']),
          facetBy: ['ingredient_names'],
          maxFacetValues: 1,
          perPage: 1,
        );
        // assert
        expect(map, equals(searchParameters));
      },
    );

    test(
      'should return all values as String',
      () async {
        // act
        final map = remoteDataSource.generateSearchParameters(
          query: 'Pizza',
          queryBy: ['title'],
          pageNumber: 1,
          filter: FilterModel(
              fieldName: 'ingredient_names', filterValues: ['salt']),
          facetBy: ['ingredient_names'],
          maxFacetValues: 1,
          perPage: 1,
        );
        // assert
        map.forEach((key, value) => expect(value, isA<String>()));
      },
    );

    test(
      'should require query, queryBy and pageNumber parameters',
      () async {
        // arrange
        final searchParameters = {
          'q': 'Pizza',
          'query_by': 'title',
          'page': 1,
        };
        // act
        final map = remoteDataSource.generateSearchParameters(
          query: 'Pizza',
          queryBy: ['title'],
          pageNumber: 1,
        );
        // assert
        expect(map, equals(searchParameters));
      },
    );
  });
}
