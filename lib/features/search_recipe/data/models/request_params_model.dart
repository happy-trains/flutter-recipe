import '../../domain/entities/request_params.dart';

class RequestParamsModel extends RequestParams {
  RequestParamsModel({
    required String collectionName,
    required int perPage,
    required String query,
  }) : super(
          collectionName: collectionName,
          perPage: perPage,
          query: query,
        );

  factory RequestParamsModel.fromJson(Map<String, dynamic> json) =>
      RequestParamsModel(
        collectionName: json['collection_name'],
        perPage: json['per_page'],
        query: json['q'],
      );
}
