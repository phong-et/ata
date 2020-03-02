import 'package:flutter/foundation.dart';

class Office {
  String ipAddress;
  double lon;
  double lat;
  double authRange;
  String error;

  Office({
    @required this.ipAddress,
    @required this.lon,
    @required this.lat,
    @required this.authRange,
    @required this.error,
  });

  factory Office.fromJson(Map<String, dynamic> parsedJson) {
    return Office(
      ipAddress: parsedJson['ipAddress'],
      lon: parsedJson['lon'],
      lat: parsedJson['lat'],
      authRange: parsedJson['authRange'],
      error: parsedJson['error'] == null ? null : parsedJson['error'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'ipAddress': this.ipAddress,
      'lon': this.lon,
      'lat': this.lat,
      'authRange': this.authRange,
      'error': this.error,
    };
  }
}
