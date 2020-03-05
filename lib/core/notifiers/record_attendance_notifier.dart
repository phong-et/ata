import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/ip_info_service.dart';
import 'package:ata/core/services/location_service.dart';
import 'package:ata/core/services/user_service.dart';

class RecordAttendanceNotifier extends BaseNotifier {
  final UserService _userService;
  final LocationService _locationService;
  final IpInfoService _ipInfoService;

  RecordAttendanceNotifier(UserService userService, LocationService locationService, IpInfoService ipInfoService)
      : _userService = userService,
        _locationService = locationService,
        _ipInfoService = ipInfoService;

  AttendanceStatus attendanceStatus;
  String checkInStatus = '';
  String checkOutStatus = '';

  Future<void> refresh() async {
    setBusy(true);
    await _userService.refreshService();
    attendanceStatus = _userService.getAttendanceStatus();
    _userService.setLocationAndIpServices(_locationService, _ipInfoService);
    setBusy(false);
  }

  Future<void> checkIn() async {
    checkInStatus = '';
    setBusy(true);
    checkInStatus = await _userService.checkIn();
    if (checkInStatus == null) await refresh();
    setBusy(false);
  }

  Future<void> checkOut() async {
    checkOutStatus = '';
    setBusy(true);
    checkOutStatus = await _userService.checkOut();
    if (checkOutStatus == null) await refresh();
    setBusy(false);
  }
}
