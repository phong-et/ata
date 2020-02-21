import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'models/failure.dart';

enum FetchType { POST, GET, PUT, PATCH, DELETE }

class Util {
  static Future<dynamic> fetch(FetchType type, String url,
      [Map<String, dynamic> requestPayload = const {}]) async {
    try {
      http.Response response;
      switch (type) {
        case FetchType.POST:
          response = await http.post(
            url,
            body: json.encode(requestPayload),
          );
          break;
        case FetchType.GET:
          response = await http.get(
            url,
          );
          break;
        case FetchType.PUT:
          response = await http.put(
            url,
            body: json.encode(requestPayload),
          );
          break;
        case FetchType.PATCH:
          response = await http.patch(
            url,
            body: json.encode(requestPayload),
          );
          break;
        case FetchType.DELETE:
          response = await http.delete(
            url,
          );
          break;
      }
      //! No Internet Connection
      // throw SocketException('No Internet');

      //! 404
      // throw HttpException('404');

      //! Invalid JSON response
      // return 'yxz';

      //! Deadly Unexpected exception
      //throw FileSystemException();

      return json.decode(response.body);
    } on SocketException {
      throw Failure('No Internet connection 😑');
    } on HttpException {
      throw Failure("Couldn't find the resource 😱");
    } on FormatException {
      throw Failure("Bad response format 👎");
    }
  }
}
