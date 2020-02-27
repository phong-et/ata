import 'package:flutter/foundation.dart';

class Auth {
  static final apiKey = 'AIzaSyCfrk-pANuYEeE3Npr87FEyyk8TwH6jJ5s';
  String idToken; // Firebase ID token of the account.
  String localId; // The uid of the current user.
  String email;
  String refreshToken;
  String expiresIn;
  String error;

  Auth({
    @required this.idToken,
    @required this.localId,
    @required this.email,
    @required this.refreshToken,
    @required this.expiresIn,
    @required this.error,
  });

  factory Auth.fromJson(Map<String, dynamic> parsedJson) {
    return Auth(
      idToken: parsedJson['idToken'],
      localId: parsedJson['localId'],
      email: parsedJson['email'],
      refreshToken: parsedJson['refreshToken'],
      expiresIn: parsedJson['expiresIn'],
      error: parsedJson['error'] == null ? null : (parsedJson['error']['message'] ?? parsedJson['error']),
    );
  }

  Map<String, dynamic> toJson() => {
        'idToken': this.idToken,
        'localId': this.localId,
        'email': this.email,
        'refreshToken': this.refreshToken,
        'expiresIn': this.expiresIn,
        'error': this.error,
      };
}
