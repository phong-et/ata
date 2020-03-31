import 'package:flutter/foundation.dart';

class Location {
  double lat;
  double lng;

  Location({
    @required this.lat,
    @required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> parsedJson) {
    return Location(
      lat: parsedJson['lat'],
      lng: parsedJson['lng'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'lat': this.lat,
      'lng': this.lng,
    };
  }
}
