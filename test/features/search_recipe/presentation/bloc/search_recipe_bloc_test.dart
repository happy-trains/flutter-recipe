import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
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

  final tIndexSize = 2231142;
  final tSearchQuery = 'A Pizza';
  final tPrunedSearchQuery = 'Pizza';
  final tEmtpyResultSearchQuery = 'totallyEmptySearchQuery';
  final tPageNumber = 1;
  final tPerPage = 1;
  final tQueryBy = ['title'];
  final tResultCount = 7514;
  final tEmptyResultCount = 0;
  final tSearchTime = Duration(milliseconds: 117);

  void setUpMockGetIndexSuccess() => when(mockGetIndexSize(any))
      .thenAnswer((_) => Future.value(Right(tIndexSize)));

  void setUpMockInputConverterSuccess() =>
      when(mockInputConverter.prunedQuery(any))
          .thenReturn(Right(tPrunedSearchQuery));

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
    found: tResultCount,
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
    page: tPageNumber,
    requestParams: RequestParamsModel(
      collectionName: 'recipes_1630513346',
      perPage: tPerPage,
      query: 'Pizza',
    ),
    searchTime: tSearchTime,
  );
  final tEmptyResult = ResultModel(
    facetCounts: [],
    found: tEmptyResultCount,
    hits: [],
    outOf: 2231142,
    page: tPageNumber,
    requestParams: RequestParamsModel(
      collectionName: 'recipes_1630513346',
      perPage: tPerPage,
      query: 'totallyEmptySearchQuery',
    ),
    searchTime: tSearchTime,
  );
  void setUpMockSearchRecipesSuccess() => when(mockSearchRecipes(any))
      .thenAnswer((_) => Future.value(Right(tResult)));

  group("initial state's", () {
    test(
      "status should be SearchStatus.initial",
      () async {
        // assert
        expect(bloc.state.status, equals(SearchStatus.initial));
      },
    );
    test(
      'recipes should be a list containing Recipe.empty',
      () async {
        // assert
        expect(bloc.state.recipes, equals([RecipeModel.empty]));
      },
    );
    test(
      'indexSize should be -1',
      () async {
        // assert
        expect(bloc.state.indexSize, equals(-1));
      },
    );
    test(
      'searchTime should be Duration.zero',
      () async {
        // assert
        expect(bloc.state.searchTime, equals(Duration.zero));
      },
    );
    test(
      'resultCount should be -1',
      () async {
        // assert
        expect(bloc.state.resultCount, equals(-1));
      },
    );
    test(
      'failureMessage should be empty',
      () async {
        // assert
        expect(bloc.state.failureMessage, equals(''));
      },
    );
    test(
      'page should be -1',
      () async {
        // assert
        expect(bloc.state.page, equals(-1));
      },
    );
    test(
      'query should be empty',
      () async {
        // assert
        expect(bloc.state.query, equals(''));
      },
    );
    test(
      'canGetNextPage should be true',
      () async {
        // assert
        expect(bloc.state.canGetNextPage, isTrue);
      },
    );
    test(
      'perPage should be -1 ',
      () async {
        // assert
        expect(bloc.state.perPage, equals(-1));
      },
    );
  });

  group('GetIndexSize', () {
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
      'should emit SearchRecipeState with status [loading, success] when data is retrieved successfully',
      () async {
        // arrange
        setUpMockGetIndexSuccess();
        // assert later
        expectLater(
            bloc.stream,
            emitsInOrder([
              SearchRecipeState(status: SearchStatus.loading),
              SearchRecipeState(
                status: SearchStatus.success,
                indexSize: tIndexSize,
              )
            ]));
        // act
        bloc.add(GetIndexSize());
      },
    );

    test(
      'should emit SearchRecipeState with status [loading, failure] when data retrieval is unsuccessful',
      () async {
        // arrange
        when(mockGetIndexSize(any))
            .thenAnswer((_) => Future.value(Left(ServerFailure())));
        // assert later
        expectLater(
            bloc.stream,
            emitsInOrder([
              SearchRecipeState(status: SearchStatus.loading),
              SearchRecipeState(
                  status: SearchStatus.failure,
                  failureMessage: SERVER_FAILURE_MESSAGE),
            ]));
        // act
        bloc.add(GetIndexSize());
      },
    );

    test(
      'should emit SearchRecipeState with status [loading, failure] and a proper message for failure',
      () async {
        // arrange
        when(mockGetIndexSize(any))
            .thenAnswer((_) => Future.value(Left(CacheFailure())));
        // assert later
        expectLater(
            bloc.stream,
            emitsInOrder([
              SearchRecipeState(status: SearchStatus.loading),
              SearchRecipeState(
                  status: SearchStatus.failure,
                  failureMessage: CACHE_FAILURE_MESSAGE),
            ]));
        // act
        bloc.add(GetIndexSize());
      },
    );
  });

  group('GetRecipes', () {
    final tInvalidSearchQuery = 'Not ok?';

    test(
      'should call InputConverter to prune the query',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockSearchRecipesSuccess();
        // act
        bloc.add(GetRecipes(tSearchQuery, tPerPage));
        await untilCalled(mockInputConverter.prunedQuery(any));
        // assert
        verify(mockInputConverter.prunedQuery(tSearchQuery));
      },
    );
    blocTest(
      'should set page to 1',
      build: () {
        setUpMockInputConverterSuccess();
        setUpMockSearchRecipesSuccess();
        return bloc;
      },
      act: (_) => bloc.add(GetRecipes(tSearchQuery, tPerPage)),
      verify: (_) => expect(bloc.state.page, equals(tPageNumber)),
    );
    blocTest(
      'should set query to pruned search query',
      build: () {
        setUpMockInputConverterSuccess();
        setUpMockSearchRecipesSuccess();
        return bloc;
      },
      act: (_) => bloc.add(GetRecipes(tSearchQuery, tPerPage)),
      verify: (_) => expect(bloc.state.query, equals(tPrunedSearchQuery)),
    );
    blocTest(
      'should set canGetNextPage to false in case of no hits',
      build: () {
        when(mockInputConverter.prunedQuery(any))
            .thenReturn(Right(tEmtpyResultSearchQuery));
        when(mockSearchRecipes(any))
            .thenAnswer((_) => Future.value(Right(tEmptyResult)));

        expect(bloc.state.canGetNextPage, isTrue);

        return bloc;
      },
      act: (_) => bloc.add(GetRecipes(tEmtpyResultSearchQuery, tPerPage)),
      verify: (_) => expect(bloc.state.canGetNextPage, isFalse),
    );
    blocTest(
      'should set perPage according to value passed',
      build: () {
        setUpMockInputConverterSuccess();
        setUpMockSearchRecipesSuccess();
        return bloc;
      },
      act: (_) => bloc.add(GetRecipes(tEmtpyResultSearchQuery, tPerPage)),
      verify: (_) => expect(bloc.state.perPage, equals(tPerPage)),
    );

    test(
        'should emit SearchRecipeState with status [failure] when input is invalid',
        () async {
      // arrange
      when(mockInputConverter.prunedQuery(any))
          .thenReturn(Left(InvalidInputFailure()));
      // assert later
      expectLater(
          bloc.stream,
          emitsInOrder([
            SearchRecipeState(
              status: SearchStatus.failure,
              failureMessage: IVALID_INPUT_FAILURE_MESSAGE,
            )
          ]));
      // act
      bloc.add(GetRecipes(tInvalidSearchQuery, tPerPage));
    });
    test(
      'should get data from SearchRecipes use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockSearchRecipesSuccess();
        // act
        bloc.add(GetRecipes(tSearchQuery, tPerPage));
        await untilCalled(mockSearchRecipes(any));
        // assert
        verify(mockSearchRecipes(use_case.Params(
          query: tPrunedSearchQuery,
          queryBy: tQueryBy,
          pageNumber: tPageNumber,
          perPage: tPerPage,
        )));
      },
    );
    test(
      'should emit SearchRecipeState with status [loading, success] when data is retrieved successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockSearchRecipesSuccess();
        // assert later
        expectLater(
            bloc.stream,
            emitsInOrder([
              SearchRecipeState(
                status: SearchStatus.loading,
                page: tPageNumber,
                query: tPrunedSearchQuery,
                perPage: tPerPage,
              ),
              SearchRecipeState(
                status: SearchStatus.success,
                recipes: [tRecipe],
                resultCount: tResultCount,
                searchTime: tSearchTime,
                page: tPageNumber,
                query: tPrunedSearchQuery,
                perPage: tPerPage,
              ),
            ]));
        // act
        bloc.add(GetRecipes(tSearchQuery, tPerPage));
      },
    );
    test(
      'should emit SearchRecipeState with status [loading, failure] when data retrieval is unsuccessful',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockSearchRecipes(any))
            .thenAnswer((_) => Future.value(Left(ServerFailure())));
        // assert later
        expectLater(
            bloc.stream,
            emitsInOrder([
              SearchRecipeState(
                status: SearchStatus.loading,
                page: tPageNumber,
                query: tPrunedSearchQuery,
                perPage: tPerPage,
              ),
              SearchRecipeState(
                status: SearchStatus.failure,
                failureMessage: SERVER_FAILURE_MESSAGE,
                page: tPageNumber,
                query: tPrunedSearchQuery,
                perPage: tPerPage,
              ),
            ]));
        // act
        bloc.add(GetRecipes(tSearchQuery, tPerPage));
      },
    );
    test(
      'should emit SearchRecipeState with status [loading, failure] and a proper message for failure',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockSearchRecipes(any))
            .thenAnswer((_) => Future.value(Left(CacheFailure())));
        // assert later
        expectLater(
            bloc.stream,
            emitsInOrder([
              SearchRecipeState(
                status: SearchStatus.loading,
                page: tPageNumber,
                query: tPrunedSearchQuery,
                perPage: tPerPage,
              ),
              SearchRecipeState(
                status: SearchStatus.failure,
                failureMessage: CACHE_FAILURE_MESSAGE,
                page: tPageNumber,
                query: tPrunedSearchQuery,
                perPage: tPerPage,
              ),
            ]));
        // act
        bloc.add(GetRecipes(tSearchQuery, tPerPage));
      },
    );
  });

  group('GetNextPage', () {
    blocTest(
      'should increment the page',
      build: () {
        setUpMockInputConverterSuccess();
        setUpMockSearchRecipesSuccess();
        return bloc;
      },
      act: (_) {
        bloc.add(GetRecipes(tSearchQuery, tPerPage));
        bloc.add(GetNextPage());
      },
      verify: (_) {
        verify(mockSearchRecipes(use_case.Params(
          query: tPrunedSearchQuery,
          queryBy: tQueryBy,
          pageNumber: tPageNumber,
          perPage: tPerPage,
        )));
        verify(mockSearchRecipes(use_case.Params(
          query: tPrunedSearchQuery,
          queryBy: tQueryBy,
          pageNumber: tPageNumber + 1,
          perPage: tPerPage,
        )));
        expect(bloc.state.page, equals(2));
      },
    );
    blocTest(
      'should only increment the page when canGetNextPage is true',
      build: () {
        when(mockInputConverter.prunedQuery(any))
            .thenReturn(Right(tEmtpyResultSearchQuery));
        when(mockSearchRecipes(any))
            .thenAnswer((_) => Future.value(Right(tEmptyResult)));

        expect(bloc.state.canGetNextPage, isTrue);

        return bloc;
      },
      act: (_) {
        bloc.add(GetRecipes(tEmtpyResultSearchQuery, tPerPage));
        bloc.add(GetNextPage());
      },
      expect: () => [
        SearchRecipeState(
          status: SearchStatus.loading,
          page: tPageNumber,
          query: tEmtpyResultSearchQuery,
          perPage: tPerPage,
        ),
        SearchRecipeState(
          status: SearchStatus.success,
          recipes: [],
          resultCount: tEmptyResultCount,
          searchTime: tSearchTime,
          page: tPageNumber,
          query: tEmtpyResultSearchQuery,
          canGetNextPage: false,
          perPage: tPerPage,
        ),
      ],
      verify: (_) => expect(bloc.state.canGetNextPage, isFalse),
    );
    blocTest(
      'should append the result to recipes',
      build: () {
        setUpMockInputConverterSuccess();
        setUpMockSearchRecipesSuccess();
        return bloc;
      },
      act: (_) {
        bloc.add(GetRecipes(tSearchQuery, tPerPage));
        bloc.add(GetNextPage());
      },
      expect: () => [
        SearchRecipeState(
          status: SearchStatus.loading,
          page: tPageNumber,
          query: tPrunedSearchQuery,
          perPage: tPerPage,
        ),
        SearchRecipeState(
          status: SearchStatus.success,
          recipes: [tRecipe],
          resultCount: tResultCount,
          searchTime: tSearchTime,
          page: tPageNumber,
          query: tPrunedSearchQuery,
          perPage: tPerPage,
        ),
        SearchRecipeState(
          status: SearchStatus.loading,
          recipes: [tRecipe],
          resultCount: tResultCount,
          searchTime: tSearchTime,
          page: tPageNumber + 1,
          query: tPrunedSearchQuery,
          perPage: tPerPage,
        ),
        SearchRecipeState(
          status: SearchStatus.success,
          recipes: [tRecipe, tRecipe],
          resultCount: tResultCount,
          searchTime: tSearchTime,
          page: tPageNumber + 1,
          query: tPrunedSearchQuery,
          perPage: tPerPage,
        ),
      ],
    );
    blocTest(
      'should use value of perPage to get next page',
      build: () {
        setUpMockInputConverterSuccess();
        setUpMockSearchRecipesSuccess();
        return bloc;
      },
      act: (_) {
        bloc.add(GetRecipes(tSearchQuery, tPerPage));
        bloc.add(GetNextPage());
      },
      verify: (_) {
        verify(mockSearchRecipes(use_case.Params(
          query: tPrunedSearchQuery,
          queryBy: tQueryBy,
          pageNumber: tPageNumber,
          perPage: tPerPage,
        )));
        verify(mockSearchRecipes(use_case.Params(
          query: tPrunedSearchQuery,
          queryBy: tQueryBy,
          pageNumber: tPageNumber + 1,
          perPage: tPerPage,
        )));
      },
    );
  });

  blocTest(
    'should persist the indexSize in subsequent emitted states',
    build: () {
      setUpMockGetIndexSuccess();
      setUpMockInputConverterSuccess();
      setUpMockSearchRecipesSuccess();

      return bloc;
    },
    act: (_) async {
      bloc.add(GetIndexSize());
      await Future.delayed(Duration.zero);
      bloc.add(GetRecipes(tSearchQuery, tPerPage));
    },
    expect: () => [
      SearchRecipeState(
        status: SearchStatus.loading,
      ),
      SearchRecipeState(
        status: SearchStatus.success,
        indexSize: tIndexSize,
      ),
      SearchRecipeState(
        status: SearchStatus.loading,
        indexSize: tIndexSize,
        page: tPageNumber,
        query: tPrunedSearchQuery,
        perPage: tPerPage,
      ),
      SearchRecipeState(
        status: SearchStatus.success,
        indexSize: tIndexSize,
        recipes: [tRecipe],
        resultCount: tResultCount,
        searchTime: tSearchTime,
        page: tPageNumber,
        query: tPrunedSearchQuery,
        perPage: tPerPage,
      ),
    ],
  );
}
