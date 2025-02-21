import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_dbhg/model/exceptions/app_exceptions.dart';
import 'dart:convert';

import 'package:movies_dbhg/model/services/app_base_service.dart';

class MovieService extends AppBaseService {
  // static Future<List<Movie>> fetchMovies() async {
  //   final response = await http.get(
  //     Uri.parse(
  //       '${Constants.baseUrl}/movie/popular?api_key=${Constants.apiKey}',
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final List<dynamic> results = data['results'];
  //     return results.map((json) => Movie.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to fetch movies');
  //   }
  // }

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
      final response = await http.get(Uri.parse(url));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }
}
