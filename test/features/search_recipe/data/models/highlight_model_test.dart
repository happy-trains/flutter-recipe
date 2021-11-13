import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/features/search_recipe/data/models/highlight_model.dart';
import 'package:recipe/features/search_recipe/domain/entities/highlight.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tHighlightModel = HighlightModel(
    field: 'title',
    matchedTokens: ['Pizza'],
    snippet: '<mark>Pizza</mark>',
  );

  group('Highlight', () {
    test(
      'should be a subclass of Highlight entity',
      () async {
        // assert
        expect(tHighlightModel, isA<Highlight>());
      },
    );

    test(
      'should return a model from json data',
      () async {
        // arrange
        final json = jsonDecode(fixture('highlight.json'));
        // act
        final result = HighlightModel.fromJson(json);
        // assert
        expect(result, tHighlightModel);
      },
    );

    group('toJson', () {
      test(
        'should return a json map containing the proper data',
        () async {
          // act
          final result = tHighlightModel.toJson();
          // assert
          final expectedMap = {
            "field": "title",
            "matched_tokens": ["Pizza"],
            "snippet": "<mark>Pizza</mark>"
          };
          expect(result, equals(expectedMap));
        },
      );
    });
  });
}
