// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/input_converter.dart';
import '../../data/models/recipe_model.dart';
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
  }) : super(SearchRecipeState()) {
    on<GetRecipes>(_GetRecipesHandler);
    on<GetIndexSize>(_GetIndexSizeHandler);
  }

  _GetRecipesHandler(GetRecipes event, Emitter<SearchRecipeState> emit) async {
    final result = inputConverter.prunedQuery(event.query);
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: IVALID_INPUT_FAILURE_MESSAGE,
        ),
      ),
      (query) async {
        emit(state.copyWith(status: SearchStatus.loading));

        final result = await searchRecipesUseCase(
          use_case.Params(
            query: query,
            queryBy: ['title'],
            pageNumber: 1,
          ),
        );

        await result.fold(
          (failure) async => _failureHandler(failure, emit, state),
          (result) async => emit(
            state.copyWith(
              status: SearchStatus.success,
              recipes: result.hits.map((h) => h.document).toList(),
              resultCount: result.found,
              searchTime: result.searchTime,
            ),
          ),
        );
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
}

_failureHandler(Failure failure, Emitter<SearchRecipeState> emit,
        SearchRecipeState state) =>
    emit(state.copyWith(
      status: SearchStatus.failure,
      errorMessage: failure.mapFailureToMessage(),
    ));

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
