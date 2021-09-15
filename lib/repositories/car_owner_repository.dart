import 'package:cars_app/models/car_owner_model.dart';

class CarOwnerRepository {
  static Future<List<CarOwnerModel>> getCarOwnersList() async {
    try {
      List<CarOwnerModel> ownersList = [];
      //from api
      //var response = await CarsAppApiService.getCarOwnersListAsync();
      // if (response != null) {
      //   for (var owner in response) {
      //     ownersList.add(CarOwnerModel(
      //         id: owner.id ?? '',
      //         firstName: owner.firstName ?? 'brak',
      //         lastName: owner.lastName ?? 'brak',
      //         birthDate: owner.birthDate ?? DateTime.now()));
      //   }
      // }

      ownersList.add(CarOwnerModel(id: '30', firstName: 'Jan', lastName: 'Nowak', birthDate: DateTime.now()));
      ownersList.add(CarOwnerModel(id: '31', firstName: 'Adam', lastName: 'Góra', birthDate: DateTime.now()));
      return ownersList;
    } catch (e) {
      return [];
    }
  }
}
