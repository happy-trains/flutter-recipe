import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/features/search_recipe/data/models/request_params_model.dart';
import 'package:recipe/features/search_recipe/domain/entities/request_params.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tRequestParamsModel = RequestParamsModel(
    collectionName: 'recipes_1630513346',
    perPage: 1,
    query: 'Pizza',
  );
  group('RequestParamsModel', () {
    test(
      'should be a subclass of RequestParams entity',
      () async {
        // assert
        expect(tRequestParamsModel, isA<RequestParams>());
      },
    );

    test(
      'should return a model from json data',
      () async {
        // arrange
        final json = jsonDecode(fixture('request_params.json'));
        // act
        final result = RequestParamsModel.fromJson(json);
        // assert
        expect(result, tRequestParamsModel);
      },
    );

    group('toJson', () {
      test(
        'should return a json map containing the proper data',
        () async {
          // act
          final result = tRequestParamsModel.toJson();
          // assert
          final expectedMap = {
            "collection_name": "recipes_1630513346",
            "per_page": 1,
            "q": "Pizza"
          };
          expect(result, equals(expectedMap));
        },
      );
    });
  });
}
