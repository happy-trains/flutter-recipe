import 'package:equatable/equatable.dart';

class Facet extends Equatable {
  /// count
  final int documentCount;
  final String highlighted;
  final String value;

  const Facet({
    required this.documentCount,
    required this.highlighted,
    required this.value,
  });

  @override
  List<Object?> get props => [documentCount, highlighted, value];
}
