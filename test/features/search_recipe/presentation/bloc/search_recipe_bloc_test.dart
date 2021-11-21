import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:recipe/core/error/failures.dart';
import 'package:recipe/core/usecases/usecase.dart';
import 'package:recipe/core/utils/input_converter.dart';
import 'package:recipe/features/search_recipe/data/models/facet_count_model.dart';
import 'package:recipe/features/search_recipe/data/models/facet_model.dart';
import 'package:recipe/features/search_recipe/data/models/highlight_model.dart';
import 'package:recipe/features/search_recipe/data/models/hit_model.dart';
import 'package:recipe/features/search_recipe/data/models/recipe_model.dart';
import 'package:recipe/features/search_recipe/data/models/request_params_model.dart';
import 'package:recipe/features/search_recipe/data/models/result_model.dart';
import 'package:recipe/features/search_recipe/domain/usecases/get_index_size.dart'
    as use_case;
import 'package:recipe/features/search_recipe/domain/usecases/search_recipes.dart'
    as use_case;
import 'package:recipe/features/search_recipe/presentation/bloc/search_recipe_bloc.dart';

import 'search_recipe_bloc_test.mocks.dart';

@GenerateMocks([use_case.GetIndexSize, use_case.SearchRecipes, InputConverter])
void main() {
  late MockGetIndexSize mockGetIndexSize;
  late MockSearchRecipes mockSearchRecipes;
  late MockInputConverter mockInputConverter;
  late SearchRecipeBloc bloc;

  setUp(() {
    mockGetIndexSize = MockGetIndexSize();
    mockSearchRecipes = MockSearchRecipes();
    mockInputConverter = MockInputConverter();

    bloc = SearchRecipeBloc(
      getIndexSizeUseCase: mockGetIndexSize,
      searchRecipesUseCase: mockSearchRecipes,
      inputConverter: mockInputConverter,
    );
  });

  test(
    'initial state should be Empty',
    () async {
      // assert
      expect(bloc.state, equals(Empty()));
    },
  );

  group('GetIndexSize', () {
    final tIndexSize = 2231142;

    void setUpMockGetIndexSuccess() => when(mockGetIndexSize(any))
        .thenAnswer((_) => Future.value(Right(tIndexSize)));

    test(
      'should get data from GetIndexSize use case',
      () async {
        // arrange
        setUpMockGetIndexSuccess();
        // act
        bloc.add(GetIndexSize());
        await untilCalled(mockGetIndexSize(NoParams()));
        // assert
        verify(mockGetIndexSize(NoParams()));
      },
    );

    test(
      'should emit [LoadingIndexSize, LoadedIndexSize] when data is retrieved successfully',
      () async {
        // arrange
        setUpMockGetIndexSuccess();
        // assert later
        expectLater(bloc.stream,
            emitsInOrder([LoadingIndexSize(), LoadedIndexSize(tIndexSize)]));
        // act
        bloc.add(GetIndexSize());
      },
    );

    test(
      'should emit [LoadingIndexSize, Error] when data retrieval is unsuccessful',
      () async {
        // arrange
        when(mockGetIndexSize(any))
            .thenAnswer((_) => Future.value(Left(ServerFailure())));
        // assert later
        expectLater(bloc.stream,
            emitsInOrder([LoadingIndexSize(), Error(SERVER_FAILURE_MESSAGE)]));
        // act
        bloc.add(GetIndexSize());
      },
    );

    test(
      'should emit [LoadingIndexSize, Error] with a proper message for failure',
      () async {
        // arrange
        when(mockGetIndexSize(any))
            .thenAnswer((_) => Future.value(Left(CacheFailure())));
        // assert later
        expectLater(bloc.stream,
            emitsInOrder([LoadingIndexSize(), Error(CACHE_FAILURE_MESSAGE)]));
        // act
        bloc.add(GetIndexSize());
      },
    );
  });

  group('GetRecipes', () {
    final tSearchQuery = 'A Pizza';
    final tInvalidSearchQuery = 'Not ok?';
    final tPrunedSearchQuery = 'Pizza';
    final tQueryBy = ['title'];
    final tPageNumber = 1;
    final tRecipe = RecipeModel(
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
    );
    final tResult = ResultModel(
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
          document: tRecipe,
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

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.prunedQuery(any))
            .thenReturn(Right(tPrunedSearchQuery));

    void setUpMockSearchRecipesSuccess() => when(mockSearchRecipes(any))
        .thenAnswer((_) => Future.value(Right(tResult)));

    test(
      'should call InputConverter to prune the query',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockSearchRecipesSuccess();
        // act
        bloc.add(GetRecipes(tSearchQuery, tPageNumber));
        await untilCalled(mockInputConverter.prunedQuery(any));
        // assert
        verify(mockInputConverter.prunedQuery(tSearchQuery));
      },
    );

    test('should emit [Eror] when input is invalid', () async {
      // arrange
      when(mockInputConverter.prunedQuery(any))
          .thenReturn(Left(InvalidInputFailure()));
      // assert later
      expectLater(
          bloc.stream, emitsInOrder([Error(IVALID_INPUT_FAILURE_MESSAGE)]));
      // act
      bloc.add(GetRecipes(tInvalidSearchQuery, tPageNumber));
    });

    test(
      'should get data from SearchRecipes use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockSearchRecipesSuccess();
        // act
        bloc.add(GetRecipes(tSearchQuery, tPageNumber));
        await untilCalled(mockSearchRecipes(any));
        // assert
        verify(mockSearchRecipes(use_case.Params(
          query: tPrunedSearchQuery,
          queryBy: tQueryBy,
          pageNumber: tPageNumber,
        )));
      },
    );

    test(
      'should emit [LoadingRecipes, LoadedRecipes] when data is retrieved successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockSearchRecipesSuccess();
        // assert later
        expectLater(
            bloc.stream,
            emitsInOrder([
              LoadingRecipes(),
              LoadedRecipes([tRecipe])
            ]));
        // act
        bloc.add(GetRecipes(tSearchQuery, tPageNumber));
      },
    );

    test(
      'should emit [LoadingRecipes, Error] when data retrieval is unsuccessful',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockSearchRecipes(any))
            .thenAnswer((_) => Future.value(Left(ServerFailure())));
        // assert later
        expectLater(bloc.stream,
            emitsInOrder([LoadingRecipes(), Error(SERVER_FAILURE_MESSAGE)]));
        // act
        bloc.add(GetRecipes(tSearchQuery, tPageNumber));
      },
    );

    test(
      'should emit [LoadingRecipes, Error] with a proper message for failure',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockSearchRecipes(any))
            .thenAnswer((_) => Future.value(Left(CacheFailure())));
        // assert later
        expectLater(bloc.stream,
            emitsInOrder([LoadingRecipes(), Error(CACHE_FAILURE_MESSAGE)]));
        // act
        bloc.add(GetRecipes(tSearchQuery, tPageNumber));
      },
    );
  });
}
