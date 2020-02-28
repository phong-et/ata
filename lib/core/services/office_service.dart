import 'package:dartz/dartz.dart';
import 'package:ata/util.dart';
import 'package:ata/core/models/failure.dart';
import 'package:ata/core/models/office.dart';

class OfficeService {
  String _idToken;
  OfficeService(this._idToken) {
    fetchOfficeSettings();
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
    // _setNotifierState(NotifierState.LOADING);
    final officeUrl = 'https://atapp-7720c.firebaseio.com/office.json?auth=$_idToken';
    _setOffice(
      await Util.request<Office>(
        RequestType.GET,
        officeUrl,
      ),
    );
    _office.fold(
      (failure) {
        // _setNotifierState(NotifierState.ERROR);
      },
      (office) {
        if (office.error != null) {
        }
        // _setNotifierState(NotifierState.LOADED_ERROR);
        else {}
        // _setNotifierState(NotifierState.LOADED);
      },
    );
  }

  //! Admin features
  Future<void> updateOfficeSettings(
    String ipAddress,
    String lon,
    String lat,
    String authRange,
  ) async {
    final officeUrl = 'https://atapp-7720c.firebaseio.com/office.json?auth=$_idToken';
    // _setNotifierState(NotifierState.LOADING);
    _setOffice(
      await Util.request<Office>(
        RequestType.PUT,
        officeUrl,
        {
          'ipAddress': ipAddress,
          'lon': double.parse(lon),
          'lat': double.parse(lat),
          'authRange': double.parse(authRange),
        },
      ),
    );
    // _setNotifierState(NotifierState.LOADED);
  }
}
