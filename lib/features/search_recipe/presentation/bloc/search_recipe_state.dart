part of 'search_recipe_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

@immutable
class SearchRecipeState extends Equatable {
  final int page;
  final String query;
  final SearchStatus status;
  final int perPage;
  final List<Recipe> recipes;
  final int indexSize;
  final Duration searchTime;
  final int resultCount;
  final String failureMessage;
  final bool canGetNextPage;

  const SearchRecipeState({
    this.page = -1,
    this.query = '',
    this.status = SearchStatus.initial,
    this.perPage = -1,
    this.recipes = const [RecipeModel.empty],
    this.indexSize = -1,
    this.searchTime = Duration.zero,
    this.resultCount = -1,
    this.failureMessage = '',
    this.canGetNextPage = true,
  });

  @override
  List<Object?> get props => [
        page,
        query,
        status,
        perPage,
        recipes,
        indexSize,
        searchTime,
        resultCount,
        failureMessage,
        canGetNextPage,
      ];

  SearchRecipeState copyWith({
    int? page,
    String? query,
    SearchStatus? status,
    int? perPage,
    List<Recipe>? recipes,
    int? indexSize,
    Duration? searchTime,
    int? resultCount,
    String? failureMessage,
    bool? canGetNextPage,
  }) =>
      SearchRecipeState(
        page: page ?? this.page,
        query: query ?? this.query,
        status: status ?? this.status,
        perPage: perPage ?? this.perPage,
        recipes: recipes ?? this.recipes,
        indexSize: indexSize ?? this.indexSize,
        searchTime: searchTime ?? this.searchTime,
        resultCount: resultCount ?? this.resultCount,
        failureMessage: failureMessage ?? this.failureMessage,
        canGetNextPage: canGetNextPage ?? this.canGetNextPage,
      );
}
