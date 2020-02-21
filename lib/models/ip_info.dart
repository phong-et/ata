import 'package:flutter/foundation.dart';
import 'package:ata/models/json_object.dart';

class IpInfo implements JsonObject {
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

  @override
  factory IpInfo.fromJson(Map<String, dynamic> parsedJson) {
    return IpInfo(
      city: parsedJson['city'],
      country: parsedJson['country'],
      ipAddress: parsedJson['query'],
      ipLat: parsedJson['lat'],
      ipLon: parsedJson['lon'],
      org: parsedJson['org'],
      timezone: parsedJson['timezone'],
    );
  }
}
