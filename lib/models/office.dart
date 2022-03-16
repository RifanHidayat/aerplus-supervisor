import 'dart:convert';

class OfficeModel {
  num? id;
  String? name;
  String? phone;
  String? address;
  String? latitude;
  String? longitude;

  OfficeModel({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory OfficeModel.fromJson(Map<String, dynamic> map) {
    return OfficeModel(
      id: map["id"] ?? 0,
      name: map["name"] ?? "",
      phone: map['phone'] ?? "",
      address: map['address'] ?? "",
      latitude: map['latitude'] ?? "0",
      longitude: map['longitude'] ?? "0",
    );
  }

  static List<OfficeModel> fromJsonToList(List data) {
    return List<OfficeModel>.from(data.map(
      (item) => OfficeModel.fromJson(item),
    ));
  }

  static String toJson(OfficeModel data) {
    final mapData = data.toMap();
    return json.encode(mapData);
  }
}
