import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/user_service.dart';
class AttendanceReportNotifier extends BaseNotifier {
  final UserService _userService;

  AttendanceReportNotifier(UserService userService) : _userService = userService;

  Map attendanceRecordList = new Map();

  //* all async request here
  Future<void> refresh() async {
    setBusy(true);
    attendanceRecordList = await _userService.getDataAttendanceRecord();
    await _userService.fetchDataToAttendanceRecord();
    setBusy(false);
  }
}
