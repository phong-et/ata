import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ata/models/http_exception.dart';

enum AuthType { SignUp, SignIn }

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  // Timer _authTimer;

  String _getUrl(AuthType authType) {
    switch (authType) {
      case AuthType.SignUp:
        return 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDauVEL3nQHSaX7_i93z-a8q2vlgLAi7F0';
      case AuthType.SignIn:
        return 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDauVEL3nQHSaX7_i93z-a8q2vlgLAi7F0';
    }
  }

  Future<void> _authenticate(String email, String password, AuthType authType) async {
    // Requesting to Firebase
    final response = await http.post(
      _getUrl(authType),
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) throw HttpException(responseData['error']['message']);

    // Setting login data
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(responseData['expiresIn']),
      ),
    );

    // Saving to shared prefs
    final prefs = await SharedPreferences.getInstance();
    final loginDataJson = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String(),
    });
    prefs.setString('loginData', loginDataJson);

    // Updating UI
    notifyListeners();
  }

  bool get isAuth {
    return _token != null;
  }

  Future<void> signIn(String email, String password) {
    return _authenticate(email, password, AuthType.SignIn);
  }

  Future<void> signUp(String email, String password) {
    return _authenticate(email, password, AuthType.SignUp);
  }

  Future<void> signOut() async {
    _token = null;
    _expiryDate = null;
    _userId = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    notifyListeners();
  }
}
