import 'dart:async';
import 'dart:convert';
import 'package:ata/util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthType { SignUp, SignIn }

class Auth with ChangeNotifier {
  final _apiKey = 'AIzaSyDauVEL3nQHSaX7_i93z-a8q2vlgLAi7F0';
  String _token;
  DateTime _expiryDate;
  String _userId;
  // Timer _authTimer;

  String _getUrl(AuthType authType) {
    String firebaseAuthType;
    switch (authType) {
      case AuthType.SignUp:
        firebaseAuthType = 'signUp';
        break;
      case AuthType.SignIn:
        firebaseAuthType = 'signInWithPassword';
        break;
    }
    return 'https://identitytoolkit.googleapis.com/v1/accounts:$firebaseAuthType?key=$_apiKey';
  }

  Future<String> authenticate(String email, String password, AuthType authType) async {
    // Requesting to Firebase
    try {
      var reponseText = await Util.fetch(FetchType.POST, _getUrl(authType), {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });

      final responseData = json.decode(reponseText);
      if (responseData['error'] != null) return responseData['error']['message'];

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
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  bool get isAuth {
    return _token != null;
  }

  Future<void> signOut() async {
    _token = null;
    _expiryDate = null;
    _userId = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    notifyListeners();
  }

  Future<bool> autoSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2), null);
    if (!prefs.containsKey('loginData')) return false;

    final loginData = json.decode(prefs.getString('loginData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(loginData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) return false;
    _token = loginData['token'];
    _userId = loginData['userId'];
    _expiryDate = expiryDate;
    return true;
  }
}
