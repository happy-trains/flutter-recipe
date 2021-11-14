import 'package:equatable/equatable.dart';

class RequestParams extends Equatable {
  final String collectionName;
  final int perPage;
  final String query;

  const RequestParams({
    required this.collectionName,
    required this.perPage,
    required this.query,
  });

  @override
  List<Object?> get props => [
        collectionName,
        perPage,
        query,
      ];
}
