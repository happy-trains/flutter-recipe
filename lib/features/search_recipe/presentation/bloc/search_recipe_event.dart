part of 'search_recipe_bloc.dart';

@immutable
abstract class SearchRecipeEvent extends Equatable {}

class GetRecipes extends SearchRecipeEvent {
  final String query;
  final int pageNumber;

  GetRecipes(this.query, this.pageNumber);

  @override
  List<Object?> get props => [query];
}

class GetIndexSize extends SearchRecipeEvent {
  @override
  List<Object?> get props => [];
}
