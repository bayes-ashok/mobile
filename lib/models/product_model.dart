// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ProductModel? productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel? data) => json.encode(data!.toJson());

class ProductModel {
  ProductModel({
    this.id,
    this.userId,
    this.productName,
    this.productDescription,
  });

  String? id;
  String? userId;
  String? productName;
  String? productDescription;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    userId: json["user_id"],
    productName: json["productName"],
    productDescription: json["productDescription"],
  );



  factory ProductModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => ProductModel(
    id: json.id,
    userId: json["user_id"],
    productName: json["productName"],
    productDescription: json["productDescription"],
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "productName": productName,
    "productDescription": productDescription,
  };
}
