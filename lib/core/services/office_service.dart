import 'package:dartz/dartz.dart';
import 'package:ata/util.dart';
import 'package:ata/core/models/failure.dart';
import 'package:ata/core/models/office.dart';

class OfficeService {
  String _idToken;

  //* Model reference
  Either<Failure, Office> _officeSettings;
  Either<Failure, Office> get officeSettings => _officeSettings;
  void _setOffice(Either<Failure, Office> officeSettings) {
    _officeSettings = officeSettings;
  }

  void setAuthToken(String token) {
    _idToken = token;
  }

  //! Admin features
  Future<void> fetchOfficeSettings() async {
    // _setNotifierState(NotifierState.LOADING);
    final officeUrl =
        'https://atapp-7720c.firebaseio.com/office.json?auth=$_idToken';
    await Util.request<Office>(
      RequestType.GET,
      officeUrl,
    ).then((value) => _setOffice(value));
    // _office.fold(
    //   (failure) {
    //     _setNotifierState(NotifierState.ERROR);
    //   },
    //   (office) {
    //     if (office.error != null) {
    //     }
    //     _setNotifierState(NotifierState.LOADED_ERROR);
    //     else {}
    //     _setNotifierState(NotifierState.LOADED);
    //   },
    // );
  }

  //! Admin features
  Future<void> updateOfficeSettings(
    String ipAddress,
    String lon,
    String lat,
    String authRange,
  ) async {
    final officeUrl =
        'https://atapp-7720c.firebaseio.com/office.json?auth=$_idToken';
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
