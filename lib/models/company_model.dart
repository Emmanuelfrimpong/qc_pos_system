// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

class CompanyInfoModel {
  String? id;
  String? companyName;
  Map<String, dynamic>? companyAddress;
  String? companyPhoneNumber;
  String? companyEmail;
  String? companyWebsite;
  String? companyLogo;
  String? companyDescription;
  Map<String, dynamic>? passwordReset;
  String? createdAt;
  CompanyInfoModel({
    this.id,
    this.companyName,
    this.companyAddress,
    this.companyPhoneNumber,
    this.companyEmail,
    this.companyWebsite,
    this.companyLogo,
    this.companyDescription,
    this.passwordReset,
    this.createdAt,
  });

  static CompanyInfoModel empty() {
    return CompanyInfoModel();
  }

  CompanyInfoModel copyWith({
    String? id,
    String? companyName,
    Map<String, dynamic>? companyAddress,
    String? companyPhoneNumber,
    String? companyEmail,
    String? companyWebsite,
    String? companyLogo,
    String? companyDescription,
    Map<String, dynamic>? passwordReset,
    String? createdAt,
  }) {
    return CompanyInfoModel(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      companyPhoneNumber: companyPhoneNumber ?? this.companyPhoneNumber,
      companyEmail: companyEmail ?? this.companyEmail,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      companyLogo: companyLogo ?? this.companyLogo,
      companyDescription: companyDescription ?? this.companyDescription,
      passwordReset: passwordReset ?? this.passwordReset,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id ?? 'company',
      'id': id ?? 'company',
      'companyName': companyName,
      'companyAddress': companyAddress,
      'companyPhoneNumber': companyPhoneNumber,
      'companyEmail': companyEmail,
      'companyWebsite': companyWebsite,
      'companyLogo': companyLogo,
      'companyDescription': companyDescription,
      'passwordReset': passwordReset,
      'createdAt': createdAt,
    };
  }

  factory CompanyInfoModel.fromMap(Map<String, dynamic> map) {
    return CompanyInfoModel(
      id: map['id'] != null ? map['id'] as String : null,
      companyName:
          map['companyName'] != null ? map['companyName'] as String : null,
      companyAddress: map['companyAddress'] != null
          ? Map<String, dynamic>.from(
              (map['companyAddress'] as Map<String, dynamic>))
          : null,
      companyPhoneNumber: map['companyPhoneNumber'] != null
          ? map['companyPhoneNumber'] as String
          : null,
      companyEmail:
          map['companyEmail'] != null ? map['companyEmail'] as String : null,
      companyWebsite: map['companyWebsite'] != null
          ? map['companyWebsite'] as String
          : null,
      companyLogo:
          map['companyLogo'] != null ? map['companyLogo'] as String : null,
      companyDescription: map['companyDescription'] != null
          ? map['companyDescription'] as String
          : null,
      passwordReset: map['passwordReset'] != null
          ? Map<String, dynamic>.from(
              (map['passwordReset'] as Map<String, dynamic>))
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyInfoModel.fromJson(String source) =>
      CompanyInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CompanyInfoModel(id: $id, companyName: $companyName, companyAddress: $companyAddress, companyPhoneNumber: $companyPhoneNumber, companyEmail: $companyEmail, companyWebsite: $companyWebsite, companyLogo: $companyLogo, companyDescription: $companyDescription, passwordReset: $passwordReset, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant CompanyInfoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.companyName == companyName &&
        mapEquals(other.companyAddress, companyAddress) &&
        other.companyPhoneNumber == companyPhoneNumber &&
        other.companyEmail == companyEmail &&
        other.companyWebsite == companyWebsite &&
        other.companyLogo == companyLogo &&
        other.companyDescription == companyDescription &&
        mapEquals(other.passwordReset, passwordReset) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companyName.hashCode ^
        companyAddress.hashCode ^
        companyPhoneNumber.hashCode ^
        companyEmail.hashCode ^
        companyWebsite.hashCode ^
        companyLogo.hashCode ^
        companyDescription.hashCode ^
        passwordReset.hashCode ^
        createdAt.hashCode;
  }
}
