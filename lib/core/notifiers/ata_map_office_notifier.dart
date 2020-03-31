import 'package:ata/core/models/location.dart';
import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/location_service.dart';

class AtaMapOfficeNotifier extends BaseNotifier {
  LocationService _locationService;

  Location officeLocation;
  double authRange = 0.1;
  bool isWithinOfficeAuthRange = false;

  AtaMapOfficeNotifier(LocationService locationService) : _locationService = locationService;

  Future<void> refresh() async {
    setBusy(true);
    await _locationService.refreshService();
    officeLocation = _locationService.getOfficeLocation();
    authRange = _locationService.getAuthRange();
    isWithinOfficeAuthRange = await _locationService.checkLocationForAttendance();
    setBusy(false);
  }
}
