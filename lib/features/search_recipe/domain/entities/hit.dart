import 'recipe.dart';
import 'highlight.dart';

class Hit {
  final Recipe document;
  final List<Highlight> highlights;
  final int textMatch;

  Hit({
    required this.document,
    required this.highlights,
    required this.textMatch,
  });

  factory Hit.fromJson(Map<String, dynamic> json) {
    final document = Recipe.fromJson(json['document']);

    final highlights =
        (json['highlights'] as List).map((h) => Highlight.fromJson(h)).toList();

    return Hit(
      document: document,
      highlights: highlights,
      textMatch: json['text_match'],
    );
  }
}
