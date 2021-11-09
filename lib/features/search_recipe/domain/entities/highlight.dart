import 'package:equatable/equatable.dart';

class Highlight extends Equatable {
  final String field;
  final List<String> matchedTokens;
  final String snippet;

  Highlight({
    required this.field,
    required this.matchedTokens,
    required this.snippet,
  });

  @override
  List<Object?> get props => [field, matchedTokens, snippet];
}
