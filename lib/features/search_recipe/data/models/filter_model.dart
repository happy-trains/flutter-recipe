import '../../domain/entities/filter.dart';

class FilterModel extends Filter {
  const FilterModel({
    required String fieldName,
    required List<String> filterValues,
    bool exactMatch = true,
  }) : super(
          fieldName: fieldName,
          filterValues: filterValues,
          exactMatch: exactMatch,
        );

  Map<String, String> toApiSearchParameters() {
    final _filterValues = filterValues.map((f) => '`$f`').toList();

    return {'filter_by': '$fieldName${exactMatch ? ':=' : ':'}$_filterValues'};
  }
}
