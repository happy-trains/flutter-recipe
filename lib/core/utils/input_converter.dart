import 'package:dartz/dartz.dart';
import 'package:recipe/core/error/failures.dart';

class InputConverter {
  Either<Failure, String> prunedQuery(String query) {
    final _query = query.replaceAll(forbiddenCharacters, '');

    final allowedWords = <String>[];
    for (final word in _query.split(' ')) {
      if (!stopWords.contains(word.toLowerCase())) {
        if (word.isNotEmpty) {
          allowedWords.add(word);
        }
      }
    }

    final pruned = allowedWords.join(' ');
    if (pruned.isNotEmpty) {
      return Right(pruned);
    } else {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}

const stopWords = [
  'a',
  'am',
  'an',
  'and',
  'as',
  'at',
  'by',
  "c's",
  'co',
  'do',
  'eg',
  'et',
  'for',
  'he',
  'hi',
  'i',
  "i'd",
  "i'm",
  'ie',
  'if',
  'in',
  'inc',
  'is',
  'it',
  'its',
  'me',
  'my',
  'nd',
  'no',
  'non',
  'nor',
  'not',
  'of',
  'off',
  'oh',
  'ok',
  'on',
  'or',
  'per',
  'que',
  'qv',
  'rd',
  're',
  'so',
  'sub',
  "t's",
  'th',
  'the',
  'to',
  'too',
  'two',
  'un',
  'up',
  'us',
  'vs',
  'w',
];
final forbiddenCharacters = RegExp(r"[&\/\\#,+()$~%.'"
    '"'
    ":*?<>{}]");
