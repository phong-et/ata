import 'package:flutter/foundation.dart';

class User {
  String localId;
  String email;
  String displayName;
  String photoUrl;
  String error;

  User({@required this.localId, @required this.email, @required this.displayName, @required this.photoUrl, this.error});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      localId: parsedJson['localId'],
      email: parsedJson['email'],
      displayName: parsedJson['displayName'],
      photoUrl: parsedJson['photoUrl'],
      error: parsedJson['error'] == null ? null : parsedJson['error'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'localId': this.localId,
      'email': this.email,
      'displayName': this.displayName,
      'photoUrl': this.photoUrl,
      'error': this.error,
    };
  }
}
