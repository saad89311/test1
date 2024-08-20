import 'package:flutter/material.dart';
import 'package:test1/service/config_keys/app_urls.dart';

import 'network_api_servies.dart';

class ApiRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> signIn({
    required String email,
    required String password,
  }) async {
    Map<String, String> body = {"email": email, "password": password};
    try {
      final res = await _apiServices.getPostApiResponse(ApiUrl.signIn, body);
      return res;
    } catch (e) {
      debugPrint("Login Error: ${e.toString()}");
      return {};
    }
  }
}
