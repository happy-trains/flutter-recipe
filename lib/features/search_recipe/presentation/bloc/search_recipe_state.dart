part of 'search_recipe_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

@immutable
class SearchRecipeState extends Equatable {
  final SearchStatus status;
  final List<Recipe> recipes;
  final int indexSize;
  final Duration searchTime;
  final int resultCount;
  final String failureMessage;

  const SearchRecipeState({
    this.status = SearchStatus.initial,
    this.recipes = const [RecipeModel.empty],
    this.indexSize = -1,
    this.searchTime = Duration.zero,
    this.resultCount = -1,
    this.failureMessage = '',
  });

  @override
  List<Object?> get props =>
      [status, recipes, indexSize, searchTime, resultCount, failureMessage];

  SearchRecipeState copyWith({
    SearchStatus? status,
    List<Recipe>? recipes,
    int? indexSize,
    Duration? searchTime,
    int? resultCount,
    String? failureMessage,
  }) =>
      SearchRecipeState(
        status: status ?? this.status,
        recipes: recipes ?? this.recipes,
        indexSize: indexSize ?? this.indexSize,
        searchTime: searchTime ?? this.searchTime,
        resultCount: resultCount ?? this.resultCount,
        failureMessage: failureMessage ?? this.failureMessage,
      );
}
