import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:recipe/core/error/exception.dart';
import 'package:recipe/features/search_recipe/data/models/facet_count_model.dart';
import 'package:recipe/features/search_recipe/data/models/facet_model.dart';
import 'package:recipe/features/search_recipe/data/models/highlight_model.dart';
import 'package:recipe/features/search_recipe/data/models/hit_model.dart';
import 'package:recipe/features/search_recipe/data/models/recipe_model.dart';
import 'package:recipe/features/search_recipe/data/models/request_params_model.dart';
import 'package:recipe/features/search_recipe/data/models/result_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe/features/search_recipe/data/datasources/recipes_local_data_source.dart';

import 'recipes_local_data_source_test.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late RecipesLocalDataSourceImpl localDataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = RecipesLocalDataSourceImpl(mockSharedPreferences);
  });

  group('RecipesLocalDataSourceImpl', () {
    test(
      'has a CACHED_RESULT key',
      () async {
        // assert
        expect(RecipesLocalDataSourceImpl.CACHED_RESULT,
            equals('RECIPES_CACHED_RESULT'));
      },
    );

    group('getLastResult', () {
      final tResultModel =
          ResultModel.fromJson(jsonDecode(fixture('result.json')));
      test(
        'should return Result from SharedPreferences when present',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any))
              .thenReturn(fixture('result.json'));
          // act
          final result = await localDataSource.getLastResult();
          // assert
          verify(mockSharedPreferences
              .getString(RecipesLocalDataSourceImpl.CACHED_RESULT));
          expect(result, tResultModel);
        },
      );

      test(
        'should throw a CacheException when no cache value is present',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(null);
          // act
          final call = localDataSource.getLastResult;
          // assert
          expect(() => call(), throwsA(TypeMatcher<CacheException>()));
        },
      );
    });

    group('cacheResult', () {
      final tResultModel = ResultModel(
        facetCounts: [
          FacetCountModel(
            facets: [
              FacetModel(
                documentCount: 8277,
                highlighted: 'salt',
                value: 'salt',
              ),
            ],
            fieldName: 'ingredient_names',
          ),
        ],
        found: 7514,
        hits: [
          HitModel(
            document: RecipeModel(
              directions: [
                'Follow directions on hot roll mix, using 1 cup warm water and no egg; do not let rise.',
                'On a greased baking sheet, roll dough out to 2 12-inch circles.',
                'Pinch edge so that it stands up.',
                'Brush dough with thin coating of oil.',
                'In a skillet, break up sausage into small pieces and brown slowly, stirring often.',
                'Drain fat.',
                'Drain and slice tomatoes, reserving 1/2 cup liquid.',
                'Place tomatoes on dough; sprinkle with salt and pepper, cover with mozzarella cheese, and drizzle each pizza with 1 Tblsp.',
                'olive oil.',
                'Sprinkle with sausage.',
                'Combine tomato paste, reserved tomato juice, garlic, and herbs; spread over sausage.',
                'Sprinkle with salt and pepper and parmesan cheese.',
                'Drizzle with 1 Tblsp.',
                'olive oil for each pizza.',
                'Bake at 450* for 20 minutes or until crust is done.',
              ],
              id: '2230607',
              ingredientNames: [
                'Italian sausage',
                'tomato',
                'salt',
                'ground black pepper',
                'mozzarella cheese',
                'olive oil',
                'tomato paste',
                'garlic',
                'oregano',
                'basil',
                'parmesan cheese',
              ],
              ingredientsWithMeasurements: [
                '1 (16 ounce) package hot roll mix',
                '1 lb Italian sausage',
                '1 lb canned tomato (2 cups)',
                'salt, to taste',
                'fresh coarse ground black pepper, to taste',
                '6 ounces mozzarella cheese, grated',
                '6 tablespoons olive oil',
                '1 (6 ounce) can tomato paste (2/3 cup)',
                '2 garlic cloves, minced',
                '1 tablespoon oregano, crushed',
                '1 tablespoon basil, crushed',
                '14 cup grated parmesan cheese',
              ],
              link: 'http://www.food.com/recipe/pizza-355227',
              recipeId: 2230607,
              title: 'Pizza',
            ),
            highlights: [
              HighlightModel(
                field: 'title',
                matchedTokens: ['Pizza'],
                snippet: '<mark>Pizza</mark>',
              ),
            ],
            textMatch: 33514500,
          ),
        ],
        outOf: 2231142,
        page: 1,
        requestParams: RequestParamsModel(
          collectionName: 'recipes_1630513346',
          perPage: 1,
          query: 'Pizza',
        ),
        searchTime: Duration(milliseconds: 117),
      );

      test(
        'should call SharedPreferences to cache the data',
        () async {
          // arrange
          final expectedJson = jsonEncode(tResultModel.toJson());
          when(mockSharedPreferences.setString(any, any))
              .thenAnswer((_) => Future.value(true));
          // act
          localDataSource.cacheResult(tResultModel);
          // assert
          verify(mockSharedPreferences.setString(
              RecipesLocalDataSourceImpl.CACHED_RESULT, expectedJson));
        },
      );
    });

    group('getLastIndexSize', () {
      test(
        'should return indexSize from SharedPreferences when present',
        () async {
          final size = 2231142;
          // arrange
          when(mockSharedPreferences.getInt(any)).thenReturn(size);
          // act
          final result = await localDataSource.getLastIndexSize();
          // assert
          verify(mockSharedPreferences
              .getInt(RecipesLocalDataSourceImpl.CACHED_INDEX_SIZE));
          expect(result, size);
        },
      );

      test(
        'should throw a CacheException when no cache value is present',
        () async {
          // arrange
          when(mockSharedPreferences.getInt(any)).thenReturn(null);
          // act
          final call = localDataSource.getLastIndexSize;
          // assert
          expect(() => call(), throwsA(TypeMatcher<CacheException>()));
        },
      );
    });

    group('cacheIndexSize', () {
      test(
        'should call SharedPreferences to cache the data',
        () async {
          // arrange
          final size = 2231142;
          when(mockSharedPreferences.setInt(any, any))
              .thenAnswer((_) => Future.value(true));
          // act
          localDataSource.cacheIndexSize(size);
          // assert
          verify(mockSharedPreferences.setInt(
              RecipesLocalDataSourceImpl.CACHED_INDEX_SIZE, size));
        },
      );
    });
  });
}
