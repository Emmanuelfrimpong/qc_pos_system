// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SuppliersModel {
  String? id;
  String? name;
  String? telephone;
  String? address;
  SuppliersModel({
    this.id,
    this.name,
    this.telephone,
    this.address,
  });

  SuppliersModel copyWith({
    String? id,
    String? name,
    String? telephone,
    String? address,
  }) {
    return SuppliersModel(
      id: id ?? this.id,
      name: name ?? this.name,
      telephone: telephone ?? this.telephone,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'id': id,
      'name': name,
      'telephone': telephone,
      'address': address,
    };
  }

  factory SuppliersModel.fromMap(Map<String, dynamic> map) {
    return SuppliersModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      telephone: map['telephone'] != null ? map['telephone'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SuppliersModel.fromJson(String source) =>
      SuppliersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SuppliersModel(id: $id, name: $name, telephone: $telephone, address: $address)';
  }

  @override
  bool operator ==(covariant SuppliersModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.telephone == telephone &&
        other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ telephone.hashCode ^ address.hashCode;
  }
}
