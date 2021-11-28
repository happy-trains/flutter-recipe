// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/input_converter.dart';
import '../../data/models/recipe_model.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/usecases/get_index_size.dart' as use_case;
import '../../domain/usecases/search_recipes.dart' as use_case;
import 'package:recipe/features/search_recipe/domain/entities/result.dart';

part 'search_recipe_event.dart';
part 'search_recipe_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHE_FAILURE_MESSAGE = 'Cache Failure';
const IVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - Please enter a relevant search query';

class SearchRecipeBloc extends Bloc<SearchRecipeEvent, SearchRecipeState> {
  final use_case.GetIndexSize getIndexSizeUseCase;
  final use_case.SearchRecipes searchRecipesUseCase;
  final InputConverter inputConverter;

  SearchRecipeBloc({
    required this.getIndexSizeUseCase,
    required this.searchRecipesUseCase,
    required this.inputConverter,
  }) : super(SearchRecipeState()) {
    on<GetRecipes>(_GetRecipesHandler);
    on<GetIndexSize>(_GetIndexSizeHandler);
    on<GetNextPage>(_GetNextPageHandler);
  }

  _GetRecipesHandler(GetRecipes event, Emitter<SearchRecipeState> emit) async {
    final result = inputConverter.prunedQuery(event.query);
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: SearchStatus.failure,
          failureMessage: IVALID_INPUT_FAILURE_MESSAGE,
        ),
      ),
      (query) async {
        emit(
          state.copyWith(
            status: SearchStatus.loading,
            page: 1,
            query: query,
            perPage: event.perPage,
          ),
        );

        final result = await searchRecipesUseCase(
          use_case.Params(
            query: query,
            queryBy: ['title'],
            pageNumber: 1,
            perPage: event.perPage,
          ),
        );

        _searchRecipesResultHandler(result, emit);
      },
    );
  }

  _GetIndexSizeHandler(
      GetIndexSize event, Emitter<SearchRecipeState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading));

    final result = await getIndexSizeUseCase(NoParams());
    result.fold(
      (failure) => _failureHandler(failure, emit, state),
      (indexSize) => emit(
        state.copyWith(
          status: SearchStatus.success,
          indexSize: indexSize,
        ),
      ),
    );
  }

  _GetNextPageHandler(
      GetNextPage event, Emitter<SearchRecipeState> emit) async {
    if (state.canGetNextPage) {
      emit(state.copyWith(status: SearchStatus.loading, page: state.page + 1));

      final result = await searchRecipesUseCase(
        use_case.Params(
          query: state.query,
          queryBy: ['title'],
          pageNumber: state.page,
          perPage: state.perPage,
        ),
      );

      _searchRecipesResultHandler(result, emit, appendResult: true);
    }
  }

  _searchRecipesResultHandler(
      Either<Failure, Result> result, Emitter<SearchRecipeState> emit,
      {bool appendResult = false}) {
    return result.fold((failure) => _failureHandler(failure, emit, state),
        (result) {
      var _currentRecipes = List.from(state.recipes).cast<Recipe>();
      final _resultRecipes = result.hits.map((h) => h.document).toList();

      if (appendResult) {
        _currentRecipes.addAll(_resultRecipes);
      } else {
        _currentRecipes = _resultRecipes;
      }

      emit(
        state.copyWith(
          status: SearchStatus.success,
          recipes: _currentRecipes,
          resultCount: result.found,
          searchTime: result.searchTime,
          canGetNextPage: _resultRecipes.isNotEmpty,
        ),
      );
    });
  }

  _failureHandler(Failure failure, Emitter<SearchRecipeState> emit,
          SearchRecipeState state) =>
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          failureMessage: failure.mapFailureToMessage(),
        ),
      );
}

extension _Map on Failure {
  String mapFailureToMessage() {
    switch (runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;

      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;

      default:
        return 'Unexpected error';
    }
  }
}
