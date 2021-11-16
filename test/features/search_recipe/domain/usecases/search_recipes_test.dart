import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:recipe/features/search_recipe/data/models/filter_model.dart';

import 'package:recipe/features/search_recipe/domain/usecases/search_recipes.dart';
import 'package:recipe/features/search_recipe/data/models/result_model.dart';
import 'package:recipe/features/search_recipe/domain/repositories/recipes_repository.dart';

import 'search_recipes_test.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

@GenerateMocks([RecipesRepository])
void main() {
  late SearchRecipes usecase;
  late MockRecipesRepository mockRecipesRepository;

  setUp(() {
    mockRecipesRepository = MockRecipesRepository();
    usecase = SearchRecipes(mockRecipesRepository);
  });

  final searchQuery = 'Pizza';
  final queryBy = ['title'];
  final pageNumber = 1;
  final filter = FilterModel(
    fieldName: 'ingredient_names',
    filterValues: ['salt'],
  );

  final facetBy = ['ingredient_names'];
  final maxFacetValues = 1;
  final mockResult = ResultModel.fromJson(jsonDecode(fixture('result.json')));

  test(
    'should get search result from the repository',
    () async {
      // arrange
      when(mockRecipesRepository.search(
        query: searchQuery,
        queryBy: queryBy,
        pageNumber: pageNumber,
        filter: filter,
        facetBy: facetBy,
        maxFacetValues: maxFacetValues,
      )).thenAnswer((_) async => Right(mockResult));
      // act
      final result = await usecase(Params(
        query: searchQuery,
        queryBy: queryBy,
        pageNumber: pageNumber,
        filter: filter,
        facetBy: facetBy,
        maxFacetValues: maxFacetValues,
      ));
      // assert
      expect(result, Right(mockResult));
      verify(mockRecipesRepository.search(
        query: searchQuery,
        queryBy: queryBy,
        pageNumber: pageNumber,
        filter: filter,
        facetBy: facetBy,
        maxFacetValues: maxFacetValues,
      ));
      verifyNoMoreInteractions(mockRecipesRepository);
    },
  );
}
