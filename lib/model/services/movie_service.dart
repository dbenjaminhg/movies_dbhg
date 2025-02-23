import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:movies_dbhg/model/exceptions/app_exceptions.dart';
import 'dart:convert';

import 'package:movies_dbhg/model/services/app_base_service.dart';

// Class MovieService created to execute the apis and handler the response of the request
class MovieService extends AppBaseService {
  final box = Hive.box('MovieService');

  @visibleForTesting
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occured while communication with server with status code : ${response.statusCode}',
        );
    }
  }

  @override
  Future getResponse(String url) async {
    dynamic responseJson;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          box.put(url, response.body.toString());
          responseJson = returnResponse(response);
        }
      } else {
        if (box.containsKey(url)) {
          responseJson = jsonDecode(box.get(url));
        }
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }
}
