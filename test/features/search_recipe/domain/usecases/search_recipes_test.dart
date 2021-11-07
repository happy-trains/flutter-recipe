import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:recipe/features/search_recipe/domain/usecases/search_recipes.dart';
import 'package:recipe/features/search_recipe/domain/entities/filter.dart';
import 'package:recipe/features/search_recipe/domain/entities/result.dart';
import 'package:recipe/features/search_recipe/domain/repositories/recipes_repository.dart';

import 'search_recipes_test.mocks.dart';

@GenerateMocks([RecipesRepository])
void main() {
  late SearchRecipes usecase;
  late MockRecipesRepository mockRecipesRepository;

  setUp(() {
    mockRecipesRepository = MockRecipesRepository();
    usecase = SearchRecipes(mockRecipesRepository);
  });

  final searchQuery = 'Pizza';
  final pageNumber = 1;
  final filter = Filter(
    fieldName: 'ingredient_names',
    filterValues: ['salt'],
  );
  final mockResult = Result.fromJson({
    "facet_counts": [
      {
        "counts": [
          {"count": 8277, "highlighted": "salt", "value": "salt"}
        ],
        "field_name": "ingredient_names",
        "stats": {}
      }
    ],
    "found": 7514,
    "hits": [
      {
        "document": {
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
        },
        "highlights": [
          {
            "field": "title",
            "matched_tokens": ["Pizza"],
            "snippet": "<mark>Pizza</mark>"
          }
        ],
        "text_match": 33514500
      }
    ],
    "out_of": 2231142,
    "page": 1,
    "request_params": {
      "collection_name": "recipes_1630513346",
      "per_page": 1,
      "q": "Pizza"
    },
    "search_time_ms": 117
  });

  test(
    'should get search result from the repository',
    () async {
      // arrange
      when(mockRecipesRepository.search(
              query: searchQuery, pageNumber: pageNumber, filter: filter))
          .thenAnswer((_) async => Right(mockResult));
      // act
      final result = await usecase.execute(
          query: searchQuery, pageNumber: pageNumber, filter: filter);
      // assert
      expect(result, Right(mockResult));
      verify(mockRecipesRepository.search(
          query: searchQuery, pageNumber: pageNumber, filter: filter));
      verifyNoMoreInteractions(mockRecipesRepository);
    },
  );
}
