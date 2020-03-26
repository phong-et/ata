import 'package:ata/core/services/auth_service.dart';
import 'package:dartz/dartz.dart';
import 'package:ata/util.dart';
import 'package:ata/core/models/failure.dart';
import 'package:ata/core/models/office.dart';
import '../../factories.dart';

class OfficeService {
  //* Model reference
  Either<Failure, Office> _officeSettings;
  Either<Failure, Office> get officeSettings => _officeSettings;
  void _setOffice(Either<Failure, Office> officeSettings) {
    _officeSettings = officeSettings;
  }

  final AuthService _authService;
  OfficeService(AuthService authService) : _authService = authService;

  String get _idToken {
    return _authService.auth.fold((failure) => throw (failure.toString()), (auth) => auth.idToken);
  }

  //! Admin features
  Future<void> fetchOfficeSettings() async {
    final officeUrl = dbUrl + '/office.json?auth=$_idToken';
    await Util.requestEither<Office>(
      RequestType.GET,
      officeUrl,
    ).then((value) => _setOffice(value));
  }

  //! Admin features
  Future<void> updateOfficeSettings(
    String ipAddress,
    String lat,
    String lng,
    String authRange,
    String dateIpServiceUrl,
    String startTime,
    String endTime,
    String acceptableLateTime,
  ) async {
    final officeUrl = dbUrl + '/office.json?auth=$_idToken';

    return await Task<Office>(() async {
      try {
        final parsedJson = await Util.request(
          RequestType.PUT,
          officeUrl,
          {
            'ipAddress': ipAddress,
            'lat': double.parse(lat),
            'lng': double.parse(lng),
            'authRange': double.parse(authRange),
            'dateIpServiceUrl': dateIpServiceUrl,
            'startTime': startTime,
            'endTime': endTime,
            'acceptableLateTime': int.parse(acceptableLateTime),
          },
        );
        return make<Office>(parsedJson);
      } on FormatException {
        throw Failure("Bad Office Settings inputs 👎");
      }
    }).attempt().mapLeftToFailure().run().then((value) => _setOffice(value));
  }
}
