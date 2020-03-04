import 'package:flutter/foundation.dart';

class IpInfo {
  final String ipAddress;
  final double ipLat;
  final double ipLon;
  final String org;
  final String city;
  final String country;
  final String timezone;

  IpInfo({
    @required this.ipAddress,
    @required this.ipLat,
    @required this.ipLon,
    @required this.org,
    @required this.city,
    @required this.country,
    @required this.timezone,
  });

  factory IpInfo.fromJson(Map<String, dynamic> parsedJson) {
    return IpInfo(
      city: parsedJson['city'],
      country: parsedJson['country'],
      ipAddress: parsedJson['query'],
      ipLat: parsedJson['lat'],
      ipLon: parsedJson['lng'],
      org: parsedJson['org'],
      timezone: parsedJson['timezone'],
    );
  }
}
