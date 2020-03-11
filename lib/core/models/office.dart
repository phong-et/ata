import 'package:flutter/foundation.dart';

class Office {
  String ipAddress;
  double lat;
  double lng;
  double authRange;
  String dateIPServiceUrl;
  String error;

  Office({
    @required this.ipAddress,
    @required this.lat,
    @required this.lng,
    @required this.authRange,
    @required this.dateIPServiceUrl,
    @required this.error,
  });

  factory Office.fromJson(Map<String, dynamic> parsedJson) {
    return Office(
      ipAddress: parsedJson['ipAddress'],
      lat: parsedJson['lat'],
      lng: parsedJson['lng'],
      authRange: parsedJson['authRange'],
      dateIPServiceUrl: parsedJson['dateIPServiceUrl'],
      error: parsedJson['error'] == null ? null : parsedJson['error'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'ipAddress': this.ipAddress,
      'lat': this.lat,
      'lng': this.lng,
      'authRange': this.authRange,
      'dateIPServiceUrl': this.dateIPServiceUrl,
      'error': this.error,
    };
  }
}
