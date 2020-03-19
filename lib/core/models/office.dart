import 'package:flutter/foundation.dart';

class Office {
  String ipAddress;
  double lat;
  double lng;
  double authRange;
  String dateIpServiceUrl;
  String startTime;
  String endTime;
  String acceptableLateTime;
  String error;

  Office({
    @required this.ipAddress,
    @required this.lat,
    @required this.lng,
    @required this.authRange,
    @required this.dateIpServiceUrl,
    @required this.startTime,
    @required this.endTime,
    @required this.acceptableLateTime,
    @required this.error,
  });

  factory Office.fromJson(Map<String, dynamic> parsedJson) {
    return Office(
      ipAddress: parsedJson['ipAddress'],
      lat: parsedJson['lat'],
      lng: parsedJson['lng'],
      authRange: parsedJson['authRange'],
      dateIpServiceUrl: parsedJson['dateIpServiceUrl'],
      startTime: parsedJson['startTime'],
      endTime: parsedJson['endTime'],
      acceptableLateTime: parsedJson['acceptableLateTime'],
      error: parsedJson['error'] == null ? null : parsedJson['error'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'ipAddress': this.ipAddress,
      'lat': this.lat,
      'lng': this.lng,
      'authRange': this.authRange,
      'dateIpServiceUrl': this.dateIpServiceUrl,
      'startTime': this.startTime,
      'endTime': this.endTime,
      'acceptableLateTime': this.acceptableLateTime,
      'error': this.error,
    };
  }
}
