part of 'search_recipe_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

@immutable
class SearchRecipeState extends Equatable {
  final SearchStatus status;
  final List<Recipe> recipes;
  final int indexSize;
  final Duration searchTime;
  final int resultCount;
  final String errorMessage;

  const SearchRecipeState({
    this.status = SearchStatus.initial,
    this.recipes = const [RecipeModel.empty],
    this.indexSize = -1,
    this.searchTime = Duration.zero,
    this.resultCount = -1,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props =>
      [status, recipes, indexSize, searchTime, resultCount, errorMessage];

  SearchRecipeState copyWith({
    SearchStatus? status,
    List<Recipe>? recipes,
    int? indexSize,
    Duration? searchTime,
    int? resultCount,
    String? errorMessage,
  }) =>
      SearchRecipeState(
        status: status ?? this.status,
        recipes: recipes ?? this.recipes,
        indexSize: indexSize ?? this.indexSize,
        searchTime: searchTime ?? this.searchTime,
        resultCount: resultCount ?? this.resultCount,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
