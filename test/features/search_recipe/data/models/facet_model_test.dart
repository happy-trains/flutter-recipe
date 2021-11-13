import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/features/search_recipe/data/models/facet_model.dart';
import 'package:recipe/features/search_recipe/domain/entities/facet.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tFacetModel = FacetModel(
    documentCount: 8277,
    highlighted: 'salt',
    value: 'salt',
  );

  group('FacetModel', () {
    test(
      'should be a subclass of Facet entity',
      () async {
        // assert
        expect(tFacetModel, isA<Facet>());
      },
    );

    test(
      'should return a model from json data',
      () async {
        // arrange
        final json = jsonDecode(fixture('facet.json'));
        // act
        final result = FacetModel.fromJson(json);
        // assert
        expect(result, tFacetModel);
      },
    );

    group('toJson', () {
      test(
        'should return a json map containing the proper data',
        () async {
          // act
          final result = tFacetModel.toJson();
          // assert
          final expectedMap = {
            "count": 8277,
            "highlighted": "salt",
            "value": "salt"
          };
          expect(result, equals(expectedMap));
        },
      );
    });
  });
}
