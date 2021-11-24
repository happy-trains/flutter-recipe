part of 'search_recipe_bloc.dart';

@immutable
abstract class SearchRecipeState extends Equatable {
  final List<Object?> properties;

  SearchRecipeState(this.properties);

  @override
  List<Object?> get props => properties;
}

class Empty extends SearchRecipeState {
  Empty() : super([]);
}

class LoadingRecipes extends SearchRecipeState {
  LoadingRecipes() : super([]);
}

class LoadedRecipes extends SearchRecipeState {
  final List<Recipe> recipes;
  final int resultCount;
  final int searchTimeMS;

  LoadedRecipes(
    this.recipes, {
    required this.resultCount,
    required this.searchTimeMS,
  }) : super([recipes]);
}

class LoadingIndexSize extends SearchRecipeState {
  LoadingIndexSize() : super([]);
}

class LoadedIndexSize extends SearchRecipeState {
  final int indexSize;

  LoadedIndexSize(this.indexSize) : super([indexSize]);
}

class Error extends SearchRecipeState {
  final String error;

  Error(this.error) : super([error]);
}
