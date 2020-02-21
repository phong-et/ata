import 'dart:convert';
import 'dart:io';
import 'package:ata/models/json_object.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import 'models/failure.dart';

enum RequestType { POST, GET, PUT, PATCH, DELETE }

class Util {
  static Future<dynamic> request(RequestType type, String url, [Map<String, dynamic> requestPayload = const {}]) async {
    try {
      http.Response response;
      switch (type) {
        case RequestType.POST:
          response = await http.post(
            url,
            body: json.encode(requestPayload),
          );
          break;
        case RequestType.GET:
          response = await http.get(
            url,
          );
          break;
        case RequestType.PUT:
          response = await http.put(
            url,
            body: json.encode(requestPayload),
          );
          break;
        case RequestType.PATCH:
          response = await http.patch(
            url,
            body: json.encode(requestPayload),
          );
          break;
        case RequestType.DELETE:
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

  static Future<Either<Failure, T>> fetchDeviceIpInfo<T extends JsonObject>() async {
    return await Task(() async {
      final parsedJson = await Util.request(RequestType.GET, 'http://ip-api.com/json');
      return make<T>(parsedJson);
    }).attempt().mapLeftToFailure().run();
  }
}

extension TaskX<T extends Either<Object, U>, U> on Task<T> {
  Task<Either<Failure, U>> mapLeftToFailure() {
    return this.map(
      (either) => either.leftMap(
        (object) {
          try {
            return object as Failure;
          } catch (_) {
            throw object;
          }
        },
      ),
    );
  }
}
