class Highlight {
  final String field;
  final List<String> matchedTokens;
  final String snippet;

  Highlight({
    required this.field,
    required this.matchedTokens,
    required this.snippet,
  });

  factory Highlight.fromJson(Map<String, dynamic> json) => Highlight(
        field: json['field'],
        matchedTokens: json['matched_tokens'].cast<String>(),
        snippet: json['snippet'],
      );
}
