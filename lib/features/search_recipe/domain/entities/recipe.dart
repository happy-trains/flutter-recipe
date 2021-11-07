class Recipe {
  final List<String> directions;
  final String id;
  final List<String> ingredientNames;
  final List<String> ingredientsWithMeasurements;
  final String link;
  final int recipeId;
  final String title;

  Recipe({
    required this.directions,
    required this.id,
    required this.ingredientNames,
    required this.ingredientsWithMeasurements,
    required this.link,
    required this.recipeId,
    required this.title,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        directions: json['directions'].cast<String>(),
        id: json['id'],
        ingredientNames: json['ingredient_names'].cast<String>(),
        ingredientsWithMeasurements:
            json['ingredients_with_measurements'].cast<String>(),
        link: json['link'],
        recipeId: json['recipe_id'],
        title: json['title'],
      );
}
