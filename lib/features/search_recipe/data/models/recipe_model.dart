import '../../domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required List<String> directions,
    required String id,
    required List<String> ingredientNames,
    required List<String> ingredientsWithMeasurements,
    required String link,
    required int recipeId,
    required String title,
  }) : super(
            directions: directions,
            id: id,
            ingredientNames: ingredientNames,
            ingredientsWithMeasurements: ingredientsWithMeasurements,
            link: link,
            recipeId: recipeId,
            title: title);

  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        directions: json['directions'].cast<String>(),
        id: json['id'],
        ingredientNames: (json['ingredient_names'] as List)
            .cast<String>()
            .map((i) => '${i[0].toUpperCase()}${i.substring(1)}')
            .toList(),
        ingredientsWithMeasurements:
            json['ingredients_with_measurements'].cast<String>(),
        link: json['link'],
        recipeId: json['recipe_id'],
        title: json['title'],
      );
  Map<String, dynamic> toJson() {
    return {
      'directions': directions,
      'id': id,
      'ingredient_names': ingredientNames,
      'ingredients_with_measurements': ingredientsWithMeasurements,
      'link': link,
      'recipe_id': recipeId,
      'title': title,
    };
  }
}
