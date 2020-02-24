import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:ata/util.dart';
import 'package:ata/models/failure.dart';
import 'package:ata/models/office.dart';

class OfficeNotifier with ChangeNotifier {
  String _idToken;
  OfficeNotifier(this._idToken) {
    fetchOfficeSettings();
  }

  //* Notifier status
  NotifierState _state = NotifierState.INIT;
  NotifierState get state => _state;
  void _setNotifierState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  //* Model reference
  Either<Failure, Office> _office;
  Either<Failure, Office> get office => _office;
  void _setOffice(Either<Failure, Office> office) {
    _office = office;
  }

  void setAuthToken(String token) {
    _idToken = token;
  }

  //! Admin features
  Future<void> fetchOfficeSettings() async {
    _setNotifierState(NotifierState.LOADING);
    final officeUrl = 'https://atapp-7720c.firebaseio.com/office.json?auth=$_idToken';
    _setOffice(
      await Util.request<Office>(
        RequestType.GET,
        officeUrl,
      ),
    );
    _office.fold(
      (failure) {
        _setNotifierState(NotifierState.ERROR);
      },
      (office) {
        if (office.error != null)
          _setNotifierState(NotifierState.ERROR);
        else
          _setNotifierState(NotifierState.LOADED);
      },
    );
  }

  //! Admin features
  Future<void> updateOfficeSettings(String ipAddress, String lon, String lat, String authRange) async {
    final officeUrl = 'https://atapp-7720c.firebaseio.com/office.json?auth=$_idToken';
    _setNotifierState(NotifierState.LOADING);
    await Util.request(
      RequestType.PUT,
      officeUrl,
      {
        'ipAddress': ipAddress,
        'lon': lon,
        'lat': lat,
        'authRange': authRange,
      },
    );
    _setNotifierState(NotifierState.LOADED);
  }
}
