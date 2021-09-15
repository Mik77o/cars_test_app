import 'package:cars_app/models/car_model.dart';
import 'package:flutter/material.dart';

class CarRepository {
  static Future<List<CarModel>> getCarsList() async {
    try {
      List<CarModel> carsList = [];
      //from api
      // var response = await CarsAppApiService.getCarsListAsync();
      // if (response != null) {
      //   for (var car in response) {
      //     carsList.add(CarModel(
      //         id: car.id ?? 'brak',
      //         registrationNumber: car.registration ?? 'brak',
      //         brand: car.brand ?? 'brak',
      //         model: car.model ?? 'brak',
      //         year: car.year ?? DateTime.now(),
      //         ownerId: car.ownerId ?? '',
      //         lat: CarModel.convertToDouble(car.lat) ?? null,
      //         lng: CarModel.convertToDouble(car.lng) ?? null,
      //         color: convertStringToColor(car.color)));
      //   }
      // }

      carsList.add(CarModel(
          id: '100',
          registrationNumber: 'RZ5677',
          brand: 'Opel',
          model: 'Vectra',
          year: DateTime.now(),
          ownerId: '30',
          lat: 56.23456,
          lng: 21.45666,
          color: Colors.red));
      carsList.add(CarModel(
          id: '101',
          registrationNumber: 'RZ2222',
          brand: 'Opel',
          model: 'Astra',
          year: DateTime.now(),
          ownerId: '31',
          lat: 46.23456,
          lng: 22.45666,
          color: Colors.green));

      return carsList;
    } catch (e) {
      return [];
    }
  }

  static Color? convertStringToColor(String? color) {
    if (color == null)
      return Colors.transparent;
    else {
      color = color.replaceAll("#", "");
      if (color.length == 6) {
        return Color(int.parse("0xFF" + color));
      } else if (color.length == 8) {
        return Color(int.parse("0x" + color));
      }
    }
  }
}
