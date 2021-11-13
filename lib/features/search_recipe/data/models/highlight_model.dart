import '../../domain/entities/highlight.dart';

class HighlightModel extends Highlight {
  HighlightModel({
    required String field,
    required List<String> matchedTokens,
    required String snippet,
  }) : super(field: field, matchedTokens: matchedTokens, snippet: snippet);

  factory HighlightModel.fromJson(Map<String, dynamic> json) => HighlightModel(
        field: json['field'],
        matchedTokens: json['matched_tokens'].cast<String>(),
        snippet: json['snippet'],
      );

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'matched_tokens': matchedTokens,
      'snippet': snippet,
    };
  }
}
