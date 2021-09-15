import 'package:flutter/material.dart';

class CarModel {
  CarModel(
      {this.id,
      this.registrationNumber,
      this.brand,
      this.model,
      this.color,
      this.year,
      this.ownerId,
      this.lat,
      this.lng});
  String? id;
  String? registrationNumber;
  String? brand;
  String? model;
  Color? color;
  DateTime? year;
  String? ownerId;
  dynamic lat;
  dynamic lng;

  static double? convertToDouble(dynamic value) {
    if (value is double)
      return value;
    else if (value is String)
      return double.tryParse(value);
    else if (value is int)
      return value.toDouble();
    else
      return null;
  }
}
