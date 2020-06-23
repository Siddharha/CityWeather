import 'dart:convert';

import 'package:CityWeather/constant.dart';
import 'package:http/http.dart';

Future<Response> getReq(String cityName) async {
  return await get(BASE_URL+cityName);
}

Future<Map<String, dynamic>> postReq(String cityName) async{
  // make POST request
  Map<String, String> headers = {"Content-type": "application/json"};
  Response response = await post(Uri.parse(BASE_URL+cityName),headers: headers);
  Map<String, dynamic> mResponse = jsonDecode(response.body);
  return mResponse;
}