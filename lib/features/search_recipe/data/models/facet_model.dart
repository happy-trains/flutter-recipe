import '../../domain/entities/facet.dart';

class FacetModel extends Facet {
  FacetModel({
    required int documentCount,
    required String highlighted,
    required String value,
  }) : super(
            documentCount: documentCount,
            highlighted: highlighted,
            value: value);

  factory FacetModel.fromJson(Map<String, dynamic> json) => FacetModel(
        documentCount: json['count'],
        highlighted: json['highlighted'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() {
    return {
      'count': documentCount,
      'highlighted': highlighted,
      'value': value,
    };
  }
}
