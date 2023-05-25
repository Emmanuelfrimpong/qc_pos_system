// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class StockModel {
  String? id;
  String? productId;
  String? productName;
  Map<String, dynamic>? supplier;
  double? quantity;
  String? productSKU;
  double? productCost;
  String? productBrand;
  String? paymentStatus;
  String? paymentMethod;
  String? paymentDate;
  Map<String, dynamic>? otherCost;
  List<Map<String, dynamic>>? variants;
  String? createdAt;
  StockModel({
    this.id,
    this.productId,
    this.productName,
    this.supplier,
    this.quantity,
    this.productSKU,
    this.productCost,
    this.productBrand,
    this.paymentStatus,
    this.paymentMethod,
    this.paymentDate,
    this.otherCost,
    this.variants,
    this.createdAt,
  });

  StockModel copyWith({
    String? id,
    String? productId,
    String? productName,
    Map<String, dynamic>? supplier,
    double? quantity,
    String? productSKU,
    double? productCost,
    String? productBrand,
    String? paymentStatus,
    String? paymentMethod,
    String? paymentDate,
    Map<String, dynamic>? otherCost,
    List<Map<String, dynamic>>? variants,
    String? createdAt,
  }) {
    return StockModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      supplier: supplier ?? this.supplier,
      quantity: quantity ?? this.quantity,
      productSKU: productSKU ?? this.productSKU,
      productCost: productCost ?? this.productCost,
      productBrand: productBrand ?? this.productBrand,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentDate: paymentDate ?? this.paymentDate,
      otherCost: otherCost ?? this.otherCost,
      variants: variants ?? this.variants,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'id': id,
      'productId': productId,
      'productName': productName,
      'supplier': supplier,
      'quantity': quantity,
      'productSKU': productSKU,
      'productCost': productCost,
      'productBrand': productBrand,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'paymentDate': paymentDate,
      'otherCost': otherCost,
      'variants': variants,
      'createdAt': createdAt,
    };
  }

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      id: map['id'] != null ? map['id'] as String : null,
      productId: map['productId'] != null ? map['productId'] as String : null,
      productName:
          map['productName'] != null ? map['productName'] as String : null,
      supplier: map['supplier'] != null
          ? Map<String, dynamic>.from((map['supplier'] as Map<String, dynamic>))
          : null,
      quantity: map['quantity'] != null ? map['quantity'] as double : null,
      productSKU:
          map['productSKU'] != null ? map['productSKU'] as String : null,
      productCost:
          map['productCost'] != null ? map['productCost'] as double : null,
      productBrand:
          map['productBrand'] != null ? map['productBrand'] as String : null,
      paymentStatus:
          map['paymentStatus'] != null ? map['paymentStatus'] as String : null,
      paymentMethod:
          map['paymentMethod'] != null ? map['paymentMethod'] as String : null,
      paymentDate:
          map['paymentDate'] != null ? map['paymentDate'] as String : null,
      otherCost: map['otherCost'] != null
          ? Map<String, dynamic>.from(
              (map['otherCost'] as Map<String, dynamic>))
          : null,
      variants: map['variants'] != null
          ? List<Map<String, dynamic>>.from(
              (map['variants'] as List<Map<String, dynamic>>)
                  .map<Map<String, dynamic>?>(
                (x) => x,
              ),
            )
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StockModel.fromJson(String source) =>
      StockModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StockModel(id: $id, productId: $productId, productName: $productName, supplier: $supplier, quantity: $quantity, productSKU: $productSKU, productCost: $productCost, productBrand: $productBrand, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, paymentDate: $paymentDate, otherCost: $otherCost, variants: $variants, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant StockModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.productId == productId &&
        other.productName == productName &&
        mapEquals(other.supplier, supplier) &&
        other.quantity == quantity &&
        other.productSKU == productSKU &&
        other.productCost == productCost &&
        other.productBrand == productBrand &&
        other.paymentStatus == paymentStatus &&
        other.paymentMethod == paymentMethod &&
        other.paymentDate == paymentDate &&
        mapEquals(other.otherCost, otherCost) &&
        listEquals(other.variants, variants) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        productId.hashCode ^
        productName.hashCode ^
        supplier.hashCode ^
        quantity.hashCode ^
        productSKU.hashCode ^
        productCost.hashCode ^
        productBrand.hashCode ^
        paymentStatus.hashCode ^
        paymentMethod.hashCode ^
        paymentDate.hashCode ^
        otherCost.hashCode ^
        variants.hashCode ^
        createdAt.hashCode;
  }
}
