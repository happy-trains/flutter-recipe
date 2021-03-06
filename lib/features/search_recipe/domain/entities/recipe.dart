import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final List<String> directions;
  final String id;
  final List<String> ingredientNames;
  final List<String> ingredientsWithMeasurements;
  final String link;
  final int recipeId;
  final String title;

  const Recipe({
    required this.directions,
    required this.id,
    required this.ingredientNames,
    required this.ingredientsWithMeasurements,
    required this.link,
    required this.recipeId,
    required this.title,
  });

  String get authority => Uri.parse(link).authority.replaceFirst('www.', '');

  @override
  List<Object?> get props => [
        directions,
        id,
        ingredientNames,
        ingredientsWithMeasurements,
        link,
        recipeId,
        title
      ];
}
