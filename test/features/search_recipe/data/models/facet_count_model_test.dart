import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/features/search_recipe/data/models/facet_count_model.dart';
import 'package:recipe/features/search_recipe/domain/entities/facet_count.dart';
import 'package:recipe/features/search_recipe/data/models/facet_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('FacetCountModel', () {
    final tFacetCountModel = FacetCountModel(
      facets: [
        FacetModel(
          documentCount: 8277,
          highlighted: 'salt',
          value: 'salt',
        ),
      ],
      fieldName: 'ingredient_names',
    );

    test(
      'should be a subclass of FacetCount entity',
      () async {
        // assert
        expect(tFacetCountModel, isA<FacetCount>());
      },
    );

    test(
      'should return a model from json data',
      () async {
        // arrange
        final json = jsonDecode(fixture('facet_count.json'));
        // act
        final result = FacetCountModel.fromJson(json);
        // assert
        expect(result, tFacetCountModel);
      },
    );

    group('toJson', () {
      test(
        'should return a json map containing the proper data',
        () async {
          // act
          final result = tFacetCountModel.toJson();
          // assert
          final expectedMap = {
            "counts": [
              {"count": 8277, "highlighted": "salt", "value": "salt"}
            ],
            "field_name": "ingredient_names",
          };
          expect(result, equals(expectedMap));
        },
      );
    });
  });
}
