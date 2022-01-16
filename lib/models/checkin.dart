import 'dart:convert';

class CheckinModel {
  num? id;
  String? name;
  String? number;

  CheckinModel({this.name, this.number, this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
    };
  }

  factory CheckinModel.fromJson(Map<String, dynamic> map) {
    return CheckinModel(
        id: map["id"] ?? -1,
        name: map["name"] ?? "",
        number: map['number'] ?? "");
  }

  static List<CheckinModel> fromJsonToList(List data) {
    return List<CheckinModel>.from(data.map(
      (item) => CheckinModel.fromJson(item),
    ));
  }

  static String toJson(CheckinModel data) {
    final mapData = data.toMap();
    return json.encode(mapData);
  }
}
