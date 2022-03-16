

import 'dart:convert';

import 'package:superviso/models/office.dart';

class EmployeeModel {
  num? id;
  String? name;
  String? email;
  String? employeeId;
  String? handphone;
  String? placeOfBirth;
  String? birthDate;
  String? gender;
  String? maritalStatus;
  String? bloodType;
  String? religion;
  String? identityType;
  String? identityNumber;
  String? identityExpiryDate;
  String? identityAddress;
  String? postalCode;
  String? residentialAddress;
  String? photo;
  num? officeId;
  OfficeModel? office;

  EmployeeModel(
      {this.id,
      this.name,
      this.employeeId,
      this.handphone,
      this.placeOfBirth,
      this.birthDate,
      this.bloodType,
      this.religion,
      this.identityType,
      this.identityNumber,
      this.identityExpiryDate,
      this.identityAddress,
      this.postalCode,
      this.residentialAddress,
      this.photo,
      this.officeId,
        this.email,
      this.office});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'employeeId': employeeId,
      'handphone': handphone,
      'placeOfBiirth': placeOfBirth,
      'birthDate': birthDate,
      'bloodType': bloodType,
      'religion': religion,
      'identityType': identityType,
      'identityNumber': identityNumber,
      "identityExpiryDate": identityExpiryDate,
      "identityAddress": identityAddress,
      "postalCode": postalCode,
      "photo": photo,
      "OfficeId": officeId,
      "office": office,
      "email":email
    };
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map["id"] ?? 0,
      name: map["name"] ?? "",
      email: map['email']??"",
      employeeId: map['employeeId'],
      handphone: map["handphone"] ?? "",
      placeOfBirth: map["plceOfBirth"] ?? "",
      birthDate: map["birthDate"] ?? "",
      bloodType: map['blood_type'],
      religion: map['religion'],
      identityType: map['identityType'],
      identityNumber: map['identityNumber'],
      identityExpiryDate: map['identityExpiryDate'],
      identityAddress: map['idendityAddress'],
      postalCode: map['postlCode'] ?? "",
      photo: map['photo'] ?? "",
      officeId: map['officeId'] ?? 0,
      office:
          map['office'] != null ? OfficeModel.fromJson(map['office']) : null,
      // companyLocation: map['company_location'] != null
      //     ? CompanyLocationModel.fromJson(map['company_location'])
      //     : null,
    );
  }

  static List<EmployeeModel> fromJsonToList(List data) {
    return List<EmployeeModel>.from(data.map(
      (item) => EmployeeModel.fromJson(item),
    ));
  }

  static String toJson(EmployeeModel data) {
    final mapData = data.toMap();
    return json.encode(mapData);
  }
}
