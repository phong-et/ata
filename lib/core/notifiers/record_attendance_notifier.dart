import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/user_service.dart';

class RecordAttendanceNotifier extends BaseNotifier {
  final UserService _userService;

  RecordAttendanceNotifier(UserService userService) : _userService = userService;

  AttendanceStatus attendanceStatus;
  String checkInStatus = '';
  String checkOutStatus = '';

  Future<void> refresh() async {
    setBusy(true);
    await _userService.refreshService();
    attendanceStatus = _userService.getAttendanceStatus();
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
