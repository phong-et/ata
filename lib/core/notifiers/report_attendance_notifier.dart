import 'package:ata/core/models/attendance_record.dart';
import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/user_service.dart';

class AttendanceReportNotifier extends BaseNotifier {
  final UserService _userService;

  AttendanceReportNotifier(UserService userService) : _userService = userService;

  List<AttendanceRecord> ataDataList = new List();

  Future<void> refresh() async {
    setBusy(true);
    ataDataList = await _userService.fetchAtaData();
    setBusy(false);
  }
}
