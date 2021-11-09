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
}
