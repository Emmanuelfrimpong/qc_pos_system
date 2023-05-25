// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProductsModel {
  String? id;
  String? productName;
  String? productDescription;
  String? productImage;
  String? barcode;
  String? unitOfMeasurement;
  String? sku;
  double? inStock;
  double? minimumStock;
  double? sellingPricePerUnit;
  List<String>? tags;
  List<String>? variants;
  List<Map<String, dynamic>>? customData;
  ProductsModel({
    this.id,
    this.productName,
    this.productDescription,
    this.productImage,
    this.barcode,
    this.unitOfMeasurement,
    this.sku,
    this.inStock,
    this.minimumStock,
    this.sellingPricePerUnit,
    this.tags,
    this.variants,
    this.customData,
  });

  ProductsModel copyWith({
    String? id,
    String? productName,
    String? productDescription,
    String? productImage,
    String? barcode,
    String? unitOfMeasurement,
    String? sku,
    double? inStock,
    double? minimumStock,
    double? sellingPricePerUnit,
    List<String>? tags,
    List<String>? variants,
    List<Map<String, dynamic>>? customData,
  }) {
    return ProductsModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      productImage: productImage ?? this.productImage,
      barcode: barcode ?? this.barcode,
      unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
      sku: sku ?? this.sku,
      inStock: inStock ?? this.inStock,
      minimumStock: minimumStock ?? this.minimumStock,
      sellingPricePerUnit: sellingPricePerUnit ?? this.sellingPricePerUnit,
      tags: tags ?? this.tags,
      variants: variants ?? this.variants,
      customData: customData ?? this.customData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'id': id,
      'productName': productName,
      'productDescription': productDescription,
      'productImage': productImage,
      'barcode': barcode,
      'unitOfMeasurement': unitOfMeasurement,
      'sku': sku,
      'inStock': inStock,
      'minimumStock': minimumStock,
      'sellingPricePerUnit': sellingPricePerUnit,
      'tags': tags,
      'variants': variants,
      'customData': customData,
    };
  }

  factory ProductsModel.fromMap(Map<String, dynamic> map) {
    return ProductsModel(
      id: map['id'] != null ? map['id'] as String : null,
      productName:
          map['productName'] != null ? map['productName'] as String : null,
      productDescription: map['productDescription'] != null
          ? map['productDescription'] as String
          : null,
      productImage:
          map['productImage'] != null ? map['productImage'] as String : null,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      unitOfMeasurement: map['unitOfMeasurement'] != null
          ? map['unitOfMeasurement'] as String
          : null,
      sku: map['sku'] != null ? map['sku'] as String : null,
      inStock: map['inStock'] != null ? map['inStock'] as double : null,
      minimumStock:
          map['minimumStock'] != null ? map['minimumStock'] as double : null,
      sellingPricePerUnit: map['sellingPricePerUnit'] != null
          ? map['sellingPricePerUnit'] as double
          : null,
      tags: map['tags'] != null
          ? List<String>.from((map['tags'] as List<String>))
          : null,
      variants: map['variants'] != null
          ? List<String>.from((map['variants'] as List<String>))
          : null,
      customData: map['customData'] != null
          ? List<Map<String, dynamic>>.from(
              (map['customData'] as List<Map<String, dynamic>>)
                  .map<Map<String, dynamic>?>(
                (x) => x,
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductsModel.fromJson(String source) =>
      ProductsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductsModel(id: $id, productName: $productName, productDescription: $productDescription, productImage: $productImage, barcode: $barcode, unitOfMeasurement: $unitOfMeasurement, sku: $sku, inStock: $inStock, minimumStock: $minimumStock, sellingPricePerUnit: $sellingPricePerUnit, tags: $tags, variants: $variants, customData: $customData)';
  }

  @override
  bool operator ==(covariant ProductsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.productName == productName &&
        other.productDescription == productDescription &&
        other.productImage == productImage &&
        other.barcode == barcode &&
        other.unitOfMeasurement == unitOfMeasurement &&
        other.sku == sku &&
        other.inStock == inStock &&
        other.minimumStock == minimumStock &&
        other.sellingPricePerUnit == sellingPricePerUnit &&
        listEquals(other.tags, tags) &&
        listEquals(other.variants, variants) &&
        listEquals(other.customData, customData);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        productName.hashCode ^
        productDescription.hashCode ^
        productImage.hashCode ^
        barcode.hashCode ^
        unitOfMeasurement.hashCode ^
        sku.hashCode ^
        inStock.hashCode ^
        minimumStock.hashCode ^
        sellingPricePerUnit.hashCode ^
        tags.hashCode ^
        variants.hashCode ^
        customData.hashCode;
  }
}
