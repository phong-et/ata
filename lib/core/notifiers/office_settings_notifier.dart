import 'package:ata/core/models/failure.dart';
import 'package:ata/core/models/office.dart';
import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/office_service.dart';
import 'package:dartz/dartz.dart';

class OfficeSettingsNotifier extends BaseNotifier {
  OfficeService _officeService;

  OfficeSettingsNotifier(OfficeService officeService) : _officeService = officeService;

  String ipAddress;
  String officeLng;
  String officeLat;
  String authRange;
  String dateIpServiceUrl;
  String startTime;
  String endTime;
  String acceptableLateTime;

  Future<void> getOfficeSettings() async {
    setBusy(true);
    await _officeService.fetchOfficeSettings();
    setNotifierInfo(_officeService.officeSettings);
    setBusy(false);
  }

  Future<void> saveOfficeSettings(
    String ipAddress,
    String lat,
    String lng,
    String authRange,
    String dateIpServiceUrl,
    String startTime,
    String endTime,
    String acceptableLateTime
  ) async {
    setBusy(true);
    await _officeService.updateOfficeSettings(
      ipAddress,
      lat,
      lng,
      authRange,
      dateIpServiceUrl,
      startTime,
      endTime,
      acceptableLateTime
    );
    setNotifierInfo(_officeService.officeSettings);
    setBusy(false);
  }

  void setNotifierInfo(Either<Failure, Office> officeSettings) {
    officeSettings.fold(
      (failure) {
        ipAddress = failure.toString();
        officeLat = failure.toString();
        officeLng = failure.toString();
        authRange = failure.toString();
        dateIpServiceUrl = failure.toString();
        startTime = failure.toString();
        endTime = failure.toString();
        acceptableLateTime = failure.toString();
      },
      (office) {
        ipAddress = office.error == null ? office.ipAddress.toString() : office.error;
        officeLat = office.error == null ? office.lat.toString() : office.error;
        officeLng = office.error == null ? office.lng.toString() : office.error;
        authRange = office.error == null ? office.authRange.toString() : office.error;
        dateIpServiceUrl = office.error == null ? office.dateIpServiceUrl.toString() : office.error;
        startTime = office.error == null ? office.startTime.toString() : office.error;
        endTime = office.error == null ? office.endTime.toString() : office.error;
        acceptableLateTime = office.error == null ? office.acceptableLateTime.toString() : office.error;
      },
    );
  }

  void setOfficeLocation(
    String lat,
    String lng,
  ) {
    setBusy(true);
    officeLng = lng;
    officeLat = lat;
    setBusy(false);
  }
}
