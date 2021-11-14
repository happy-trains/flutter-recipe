import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/features/search_recipe/data/models/filter_model.dart';

void main() {
  late FilterModel filterModel;

  setUp(() {
    filterModel = const FilterModel(
      fieldName: 'ingredient_names',
      filterValues: ['salt'],
      exactMatch: false,
    );
  });

  group('FilterModel', () {
    group('toApiSearchParameters', () {
      test(
        'should return a map containing value of "filter_by" key',
        () async {
          // act
          final params = filterModel.toApiSearchParameters();
          // assert
          expect(
            params,
            equals(
              {
                'filter_by': 'ingredient_names:[`salt`]',
              },
            ),
          );
        },
      );

      test(
        'should change operator depending on value of exactMatch',
        () async {
          // arrange
          final _filterModelExactMatch = const FilterModel(
            fieldName: 'ingredient_names',
            filterValues: ['salt'],
            exactMatch: true,
          );
          // act
          final params = _filterModelExactMatch.toApiSearchParameters();
          // assert
          expect(
            params,
            equals(
              {
                'filter_by': 'ingredient_names:=[`salt`]',
              },
            ),
          );
        },
      );
    });
  });
}
