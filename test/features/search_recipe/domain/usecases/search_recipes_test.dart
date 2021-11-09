import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:recipe/features/search_recipe/domain/usecases/search_recipes.dart';
import 'package:recipe/features/search_recipe/domain/entities/filter.dart';
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
  final pageNumber = 1;
  final filter = Filter(
    fieldName: 'ingredient_names',
    filterValues: ['salt'],
  );
  final mockResult = ResultModel.fromJson(jsonDecode(fixture('result.json')));

  test(
    'should get search result from the repository',
    () async {
      // arrange
      when(mockRecipesRepository.search(
              query: searchQuery, pageNumber: pageNumber, filter: filter))
          .thenAnswer((_) async => Right(mockResult));
      // act
      final result = await usecase(
          Params(query: searchQuery, pageNumber: pageNumber, filter: filter));
      // assert
      expect(result, Right(mockResult));
      verify(mockRecipesRepository.search(
          query: searchQuery, pageNumber: pageNumber, filter: filter));
      verifyNoMoreInteractions(mockRecipesRepository);
    },
  );
}
