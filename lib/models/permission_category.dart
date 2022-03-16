import 'dart:convert';

class PermissionCategoryModel {
  num? id;
  String? name;
  num? maxDay;

  PermissionCategoryModel({
    this.id,
    this.name,
    this.maxDay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'maxDay': maxDay,
    };
  }

  factory PermissionCategoryModel.fromJson(Map<String, dynamic> map) {
    return PermissionCategoryModel(
      id: map["id"] ?? 0,
      name: map["name"] ?? "",
      maxDay: map['maxDay'] ?? 0,
    );
  }

  static List<PermissionCategoryModel> fromJsonToList(List data) {
    return List<PermissionCategoryModel>.from(data.map(
      (item) => PermissionCategoryModel.fromJson(item),
    ));
  }

  static String toJson(PermissionCategoryModel data) {
    final mapData = data.toMap();
    return json.encode(mapData);
  }
}
