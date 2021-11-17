import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('prunedQuery', () {
    test(
      'should remove stop words from the query',
      () {
        // arrange
        final query = 'If Pizza and Salad';
        // act
        final result = inputConverter.prunedQuery(query);
        // assert
        expect(result, equals(Right('Pizza Salad')));
      },
    );

    test('should remove forbidden characters from the query', () {
      final query = 'Pizza & Salad?';
      // act
      final result = inputConverter.prunedQuery(query);
      // assert
      expect(result, equals(Right('Pizza Salad')));
    });

    test(
      'should return InvalidInputFailure if pruned query is empty',
      () async {
        // arrange
        final query = 'Not ok?';
        // act
        final result = inputConverter.prunedQuery(query);
        // assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );
  });
}
