class RequestParams {
  final String collectionName;
  final int perPage;
  final String query;

  RequestParams({
    required this.collectionName,
    required this.perPage,
    required this.query,
  });

  factory RequestParams.fromJson(Map<String, dynamic> json) => RequestParams(
        collectionName: json['collection_name'],
        perPage: json['per_page'],
        query: json['q'],
      );
}
