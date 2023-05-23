// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? id;
  String? fullName;
  String? gender;
  String? telephone;
  String? image;
  String? role;
  String? password;
  String? status;
  String? lastLogin;
  String? createdAt;
  UserModel({
    this.id,
    this.fullName,
    this.gender,
    this.telephone,
    this.image,
    this.role,
    this.password,
    this.status,
    this.lastLogin,
    this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? gender,
    String? telephone,
    String? image,
    String? role,
    String? password,
    String? status,
    String? lastLogin,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      telephone: telephone ?? this.telephone,
      image: image ?? this.image,
      role: role ?? this.role,
      password: password ?? this.password,
      status: status ?? this.status,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'id': id,
      'fullName': fullName,
      'gender': gender,
      'telephone': telephone,
      'image': image,
      'role': role,
      'password': password,
      'status': status,
      'lastLogin': lastLogin,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      telephone: map['telephone'] != null ? map['telephone'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      lastLogin: map['lastLogin'] != null ? map['lastLogin'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, gender: $gender, telephone: $telephone, image: $image, role: $role, password: $password, status: $status, lastLogin: $lastLogin, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullName == fullName &&
        other.gender == gender &&
        other.telephone == telephone &&
        other.image == image &&
        other.role == role &&
        other.password == password &&
        other.status == status &&
        other.lastLogin == lastLogin &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        gender.hashCode ^
        telephone.hashCode ^
        image.hashCode ^
        role.hashCode ^
        password.hashCode ^
        status.hashCode ^
        lastLogin.hashCode ^
        createdAt.hashCode;
  }
}
