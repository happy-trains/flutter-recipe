// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:recipe/core/error/failures.dart';
import 'package:recipe/core/usecases/usecase.dart';

import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/usecases/get_index_size.dart' as use_case;
import '../../domain/usecases/search_recipes.dart' as use_case;

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
  }) : super(Empty()) {
    on<GetRecipes>(_GetRecipesHandler);
    on<GetIndexSize>(_GetIndexSizeHandler);
  }

  _GetRecipesHandler(GetRecipes event, Emitter<SearchRecipeState> emit) async {
    final result = inputConverter.prunedQuery(event.query);
    await result.fold(
      (failure) async => emit(Error(IVALID_INPUT_FAILURE_MESSAGE)),
      (query) async {
        emit(LoadingRecipes());

        final result = await searchRecipesUseCase(
          use_case.Params(
            query: query,
            queryBy: ['title'],
            pageNumber: 1,
          ),
        );

        await result.fold(
          (failure) async => _failureHandler(emit, failure),
          (result) async => emit(
            LoadedRecipes(
              result.hits.map((h) => h.document).toList(),
              resultCount: result.found,
              searchTimeMS: result.searchTime.inMilliseconds,
            ),
          ),
        );
      },
    );
  }

  _GetIndexSizeHandler(
      GetIndexSize event, Emitter<SearchRecipeState> emit) async {
    emit(LoadingIndexSize());

    final result = await getIndexSizeUseCase(NoParams());
    result.fold((failure) => _failureHandler(emit, failure),
        (indexSize) => emit(LoadedIndexSize(indexSize)));
  }
}

_failureHandler(Emitter<SearchRecipeState> emit, Failure failure) =>
    emit(Error(failure.mapFailureToMessage()));

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
