import 'highlight_model.dart';
import 'recipe_model.dart';

import '../../domain/entities/recipe.dart';
import '../../domain/entities/hit.dart';
import '../../domain/entities/highlight.dart';

class HitModel extends Hit {
  HitModel({
    required Recipe document,
    required List<Highlight> highlights,
    required int textMatch,
  }) : super(document: document, highlights: highlights, textMatch: textMatch);

  factory HitModel.fromJson(Map<String, dynamic> json) {
    final document = RecipeModel.fromJson(json['document']);

    final highlights = (json['highlights'] as List)
        .map((h) => HighlightModel.fromJson(h))
        .toList();

    return HitModel(
      document: document,
      highlights: highlights,
      textMatch: json['text_match'],
    );
  }

  Map<String, dynamic> toJson() {
    final list =
        highlights.cast<HighlightModel>().map((h) => h.toJson()).toList();
    return {
      'document': (document as RecipeModel).toJson(),
      'highlights': list,
      'text_match': textMatch,
    };
  }
}
