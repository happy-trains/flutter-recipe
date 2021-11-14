import 'package:equatable/equatable.dart';

import 'recipe.dart';
import 'highlight.dart';

class Hit extends Equatable {
  final Recipe document;
  final List<Highlight> highlights;
  final int textMatch;

  const Hit({
    required this.document,
    required this.highlights,
    required this.textMatch,
  });

  @override
  List<Object?> get props => [document, highlights, textMatch];
}
