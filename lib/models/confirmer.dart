import 'dart:convert';

class ConfirmerModel {
  num? id;
  String? name;

  ConfirmerModel({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ConfirmerModel.fromJson(Map<String, dynamic> map) {
    return ConfirmerModel(
      id: map["id"] ?? 0,
      name: map["name"] ?? "",
    );
  }

  static List<ConfirmerModel> fromJsonToList(List data) {
    return List<ConfirmerModel>.from(data.map(
      (item) => ConfirmerModel.fromJson(item),
    ));
  }

  static String toJson(ConfirmerModel data) {
    final mapData = data.toMap();
    return json.encode(mapData);
  }
}
