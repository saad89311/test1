import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_responses.dart';
import 'exceptions.dart';

abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url, {String token = ""});

  Future<dynamic> getPostApiResponse(String url, dynamic data,
      {String? token = ""});
  Future<dynamic> getPutApiResponse(String url, dynamic data);
  Future<dynamic> getPatchApiResponse(String url, dynamic data,
      {String? token = ""});
  Future<dynamic> getDeleteApiResponse(String url, dynamic data,
      {String? token = ""});
  Future<dynamic> getMultipartApiResponse(
      String url, dynamic data, List<File> files,
      {String token = "", bool isWfh = false});
}

class NetworkApiService extends BaseApiServices {
  ApiResponses responseClass = ApiResponses();

  @override
  Future getGetApiResponse(String url, {String token = ""}) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: {
        // 'Authorization': 'Bearer $token',
        'Authorization': token,
      }).timeout(const Duration(seconds: 60));
      responseJson = responseClass.returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data,
      {String? token = ""}) async {
    dynamic responseJson;
    try {
      var head = token != ""
          ? {
              // 'Authorization': 'Bearer $token',
              'Authorization': '$token',
              'Content-Type': 'application/json'
            }
          : {'Content-Type': 'application/json'};
      final response = await http
          .post(Uri.parse(url), body: jsonEncode(data), headers: head)
          .timeout(const Duration(seconds: 60));
      responseJson = responseClass.returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    debugPrint(responseJson.toString());
    return responseJson;
  }

  @override
  Future getMultipartApiResponse(
    String url,
    dynamic data,
    List<File> files, {
    String token = "",
    bool isWfh = false,
  }) async {
    dynamic responseJson;
    try {
      Map<String, String> auth = {"Authorization": "Bearer $token"};
      http.MultipartFile multiPort;
      var request = http.MultipartRequest('POST', Uri.parse(url));
      for (var file in files) {
        var stream = http.ByteStream(file.openRead());
        stream.cast();
        var length = await file.length();
        multiPort = isWfh
            ? http.MultipartFile('attach_file', stream, length,
                filename: file.path)
            : http.MultipartFile('media', stream, length, filename: file.path);
        request.files.add(multiPort);
      }
      debugPrint(request.files.toString());
      request.fields.addAll(data);
      debugPrint(request.fields.toString());
      request.headers.addAll(auth);

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        dynamic decodedResponse = jsonDecode(responseBody);
        debugPrint(decodedResponse);

        responseJson = decodedResponse;
      } else {
        return null;
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPutApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      var response = await http.put(Uri.parse(url), body: data, headers: {
        "Content-Type": "application/json"
      }).timeout(const Duration(seconds: 60));
      responseJson = responseClass.returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPatchApiResponse(String url, dynamic data,
      {String? token = ""}) async {
    dynamic responseJson;
    try {
      var head = token != ""
          ? {
              // 'Authorization': 'Bearer $token',
              'Authorization': '$token',
              'Content-Type': 'application/json'
            }
          : {'Content-Type': 'application/json'};

      var response = await http
          // .patch(Uri.parse(url), body: data, headers: head)
          .patch(Uri.parse(url), headers: head)
          .timeout(const Duration(seconds: 60));
      responseJson = responseClass.returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  // @override
  // Future getDeleteApiResponse(String url, data, {String? token = ""}) async {
  //   dynamic responseJson;
  //   try {
  //     var head = token != ""
  //         ? {
  //             'Authorization': 'Bearer $token',
  //             'Content-Type': 'application/json'
  //           }
  //         : {'Content-Type': 'application/json'};

  //     var response = await http
  //         .patch(Uri.parse(url), body: jsonEncode(data), headers: head)
  //         .timeout(const Duration(seconds: 10));
  //     responseJson = responseClass.returnResponse(response);
  //   } on SocketException {
  //     throw FetchDataException('No Internet Connection');
  //   }
  //   return responseJson;
  // }

  @override
  Future getDeleteApiResponse(String url, dynamic data,
      {String? token = ""}) async {
    dynamic responseJson;
    try {
      var head = token != ""
          ? {
              // 'Authorization': 'Bearer $token',
              'Authorization': '$token',
              'Content-Type': 'application/json'
            }
          : {'Content-Type': 'application/json'};

      var response = await http
          .delete(
            Uri.parse(url),
            headers: head,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      responseJson = responseClass.returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }
}
