import 'dart:convert';
import 'dart:io';
import 'package:cars_app/helpers/app_exception.dart';
import 'package:http/http.dart' as http;

class ApiBaseHelper {
  final String _baseUrl;
  const ApiBaseHelper(this._baseUrl);
  static const apiKey = '';

  Future<dynamic> get(String url, {Map<String, dynamic>? parameters, Map<String, String>? headers}) async {
    try {
      if (headers == null) headers = {};
      headers.addAll({'Content-Type': 'application/json', 'x-apikey': apiKey});

      final uri = Uri.https(_baseUrl, url, parameters);
      final response = await http.get(uri, headers: headers);
      return response.body.toString();
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> body,
      {Map<String, dynamic>? parameters, Map<String, String>? headers}) async {
    try {
      final uri = Uri.https(_baseUrl, url, parameters);
      var bodyJson = jsonEncode(body);
      if (headers == null) headers = {};
      headers.addAll({'Content-Type': 'application/json', 'x-apikey': apiKey});
      final response = await http.post(uri, body: bodyJson, encoding: Encoding.getByName("utf-8"), headers: headers);
      return json.decode(response.body.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print(e);
    }
  }
}
