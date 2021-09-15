import 'package:cars_app/helpers/api_base_helper.dart';

abstract class CarsAppApiService {
  static String apiUrl = '';
  static ApiBaseHelper _helper = ApiBaseHelper(apiUrl.replaceAll('https://', ''));

  //with api 
  static Future<dynamic> getCarsListAsync() async {}

  static Future<dynamic> getCarOwnersListAsync() async {}

  static Future<dynamic> addCarAsync(dynamic request) async {}
}
