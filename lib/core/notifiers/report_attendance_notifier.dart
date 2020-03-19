import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/user_service.dart';
import 'package:ata/util.dart';
class ReportAttendanceNotifier extends BaseNotifier {
  final UserService _userService;

  ReportAttendanceNotifier(UserService userService) : _userService = userService;

  Map recordAttendanceList = new Map();
 
  //* all async request here
  Future<void> refresh() async {
    setBusy(true);
    recordAttendanceList = await fetchDataRecordAttendance();
    setBusy(false);
  }

  Future fetchDataRecordAttendance() async {
    var responseData = await Util.request(RequestType.GET, _userService.urlLocalIdRecordAttendance);
    return responseData;
  }
}
