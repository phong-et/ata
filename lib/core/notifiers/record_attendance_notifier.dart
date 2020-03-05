import 'package:dartz/dartz.dart';
import 'package:ata/core/models/failure.dart';
import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/user_service.dart';

class RecordAttendanceNotifier extends BaseNotifier {
  final UserService _userService;

  RecordAttendanceNotifier(UserService userService) : _userService = userService;

  Either<Failure, AttendanceStatus> _attendanceStatus;

  Future<void> refresh() async {
    _attendanceStatus = await _userService.getAttendanceStatus();
  }

  AttendanceStatus getAttendanceStatus() {
    return _attendanceStatus.fold(
      (failure) => null,
      (attendanceStatus) => attendanceStatus,
    );
  }
}
