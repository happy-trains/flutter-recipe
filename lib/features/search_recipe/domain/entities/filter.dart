class Filter {
  final String fieldName;
  final List<String> filterValues;
  final bool exactMatch;

  Filter({
    required this.fieldName,
    required this.filterValues,
    this.exactMatch = true,
  });
}
