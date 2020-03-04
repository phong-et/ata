import 'package:ata/core/models/location.dart';
import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/location_service.dart';
import 'package:ata/core/services/office_service.dart';

class AtaMapOfficeNotifier extends BaseNotifier {
  OfficeService _officeService;
  LocationService _locationService;

  Location _deviceLocation;
  Location officeLocation;
  double authRange = 0.1;

  bool isWithinOfficeAuthRange = false;

  AtaMapOfficeNotifier(OfficeService officeService, LocationService locationService)
      : _officeService = officeService,
        _locationService = locationService;

  Future<void> compareWithOfficeAuthRange() async {
    setBusy(true);
    await _officeService.fetchOfficeSettings();
    _officeService.officeSettings.fold(
      (failure) => officeLocation = Location(lat: 0.0, lng: 0.0),
      (office) {
        officeLocation = Location(lat: office.lat, lng: office.lng);
        authRange = office.authRange;
      },
    );
    _deviceLocation = (await _locationService.fetchDeviceLocation()).fold(
      (failure) => Location(lat: 1.1, lng: 1.1),
      (location) => Location(lat: location.lat, lng: location.lng),
    );

    isWithinOfficeAuthRange =
        (await _locationService.compareAuthRange(_deviceLocation, officeLocation, authRange)).fold(
      (failure) => false,
      (isWithin) => isWithin,
    );
    setBusy(false);
  }
}
