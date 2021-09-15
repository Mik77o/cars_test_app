import 'package:cars_app/models/car_owner_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedUsersNotifier extends ChangeNotifier {
  List<CarOwnerModel> _list = [];

  List<CarOwnerModel> get owners => _list;

  void setOwners(List<CarOwnerModel> list) {
    _list = list;
    notifyListeners();
  }
}

final carOwnersProvider = ChangeNotifierProvider((ref) => SelectedUsersNotifier());
