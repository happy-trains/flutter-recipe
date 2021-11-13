import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/features/search_recipe/data/models/recipe_model.dart';
import 'package:recipe/features/search_recipe/domain/entities/recipe.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tRecipeModel = RecipeModel(
    directions: [
      'Follow directions on hot roll mix, using 1 cup warm water and no egg; do not let rise.',
      'On a greased baking sheet, roll dough out to 2 12-inch circles.',
      'Pinch edge so that it stands up.',
      'Brush dough with thin coating of oil.',
      'In a skillet, break up sausage into small pieces and brown slowly, stirring often.',
      'Drain fat.',
      'Drain and slice tomatoes, reserving 1/2 cup liquid.',
      'Place tomatoes on dough; sprinkle with salt and pepper, cover with mozzarella cheese, and drizzle each pizza with 1 Tblsp.',
      'olive oil.',
      'Sprinkle with sausage.',
      'Combine tomato paste, reserved tomato juice, garlic, and herbs; spread over sausage.',
      'Sprinkle with salt and pepper and parmesan cheese.',
      'Drizzle with 1 Tblsp.',
      'olive oil for each pizza.',
      'Bake at 450* for 20 minutes or until crust is done.',
    ],
    id: '2230607',
    ingredientNames: [
      'Italian sausage',
      'tomato',
      'salt',
      'ground black pepper',
      'mozzarella cheese',
      'olive oil',
      'tomato paste',
      'garlic',
      'oregano',
      'basil',
      'parmesan cheese',
    ],
    ingredientsWithMeasurements: [
      '1 (16 ounce) package hot roll mix',
      '1 lb Italian sausage',
      '1 lb canned tomato (2 cups)',
      'salt, to taste',
      'fresh coarse ground black pepper, to taste',
      '6 ounces mozzarella cheese, grated',
      '6 tablespoons olive oil',
      '1 (6 ounce) can tomato paste (2/3 cup)',
      '2 garlic cloves, minced',
      '1 tablespoon oregano, crushed',
      '1 tablespoon basil, crushed',
      '14 cup grated parmesan cheese',
    ],
    link: 'http://www.food.com/recipe/pizza-355227',
    recipeId: 2230607,
    title: 'Pizza',
  );

  group('RecipeModel', () {
    test(
      'should be a subclass of Recipe entity',
      () async {
        // assert
        expect(tRecipeModel, isA<Recipe>());
      },
    );

    test(
      'should return a model from json data',
      () async {
        // arrange
        final json = jsonDecode(fixture('recipe.json'));
        // act
        final result = RecipeModel.fromJson(json);
        // assert
        expect(result, tRecipeModel);
      },
    );

    group('toJson', () {
      test(
        'should return a json map containing the proper data',
        () async {
          // act
          final result = tRecipeModel.toJson();
          // assert
          final expectedMap = {
            "directions": [
              "Follow directions on hot roll mix, using 1 cup warm water and no egg; do not let rise.",
              "On a greased baking sheet, roll dough out to 2 12-inch circles.",
              "Pinch edge so that it stands up.",
              "Brush dough with thin coating of oil.",
              "In a skillet, break up sausage into small pieces and brown slowly, stirring often.",
              "Drain fat.",
              "Drain and slice tomatoes, reserving 1/2 cup liquid.",
              "Place tomatoes on dough; sprinkle with salt and pepper, cover with mozzarella cheese, and drizzle each pizza with 1 Tblsp.",
              "olive oil.",
              "Sprinkle with sausage.",
              "Combine tomato paste, reserved tomato juice, garlic, and herbs; spread over sausage.",
              "Sprinkle with salt and pepper and parmesan cheese.",
              "Drizzle with 1 Tblsp.",
              "olive oil for each pizza.",
              "Bake at 450* for 20 minutes or until crust is done."
            ],
            "id": "2230607",
            "ingredient_names": [
              "Italian sausage",
              "tomato",
              "salt",
              "ground black pepper",
              "mozzarella cheese",
              "olive oil",
              "tomato paste",
              "garlic",
              "oregano",
              "basil",
              "parmesan cheese"
            ],
            "ingredients_with_measurements": [
              "1 (16 ounce) package hot roll mix",
              "1 lb Italian sausage",
              "1 lb canned tomato (2 cups)",
              "salt, to taste",
              "fresh coarse ground black pepper, to taste",
              "6 ounces mozzarella cheese, grated",
              "6 tablespoons olive oil",
              "1 (6 ounce) can tomato paste (2/3 cup)",
              "2 garlic cloves, minced",
              "1 tablespoon oregano, crushed",
              "1 tablespoon basil, crushed",
              "14 cup grated parmesan cheese"
            ],
            "link": "http://www.food.com/recipe/pizza-355227",
            "recipe_id": 2230607,
            "title": "Pizza"
          };
          expect(result, equals(expectedMap));
        },
      );
    });
  });
}
