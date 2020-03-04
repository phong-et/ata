import 'package:ata/core/models/location.dart';
import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/location_service.dart';

class AtaMapOfficeNotifier extends BaseNotifier {
  LocationService _locationService;

  Location officeLocation;
  double authRange = 0.1;

  bool isWithinOfficeAuthRange = false;

  AtaMapOfficeNotifier(LocationService locationService) : _locationService = locationService;

  Future<void> compareWithOfficeAuthRange() async {
    setBusy(true);
    await _locationService.updateLocationStatus();
    officeLocation = _locationService.officeLocation;
    authRange = _locationService.authRange;
    isWithinOfficeAuthRange = _locationService.isWithinOfficeAuthRange;
    setBusy(false);
  }
}
