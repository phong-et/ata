import 'package:ata/core/models/auth.dart';
import 'package:ata/core/models/failure.dart';
import 'package:ata/util.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

enum AttendanceType { In, Out }
enum AttendanceStatus { CheckedIn, CheckedOut, NotCheckIn, NotCheckOut }

class UserService {
  String _localId;
  String _idToken;
  String _urlReports = "https://atapp-7720c.firebaseio.com/reports/";
  UserService(Either<Failure, Auth> auth) {
    auth.fold((failure) => failure, (auth) => {_localId = auth.localId, _idToken = auth.idToken});
  }

  String get currentDateString {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String get urlRecordAttendance {
    return "$_urlReports$_localId/$currentDateString.json?auth=$_idToken";
  }

  Future<Either<Failure, AttendanceStatus>> checkAttendance() async {
    AttendanceStatus status;
    var responseData;
    try {
      responseData = await Util.request(RequestType.GET, urlRecordAttendance);
    } catch (error) {
      return Left(Failure(error.toString()));
    }

    if (responseData != null) {
      if (responseData['error'] != null) return Left(Failure(responseData['error']));
      if (responseData['in'] != null) status = AttendanceStatus.CheckedIn;
      if (responseData['out'] != null) status = AttendanceStatus.CheckedOut;
      if (responseData['out'] == null) status = AttendanceStatus.NotCheckOut;
    } else
      status = AttendanceStatus.NotCheckIn;
    return Right(status);
  }

  Future<String> recordAttendance(AttendanceType attendanceType) async {
    List<bool> lstChecked = await Future.wait([/*checkIP(), checkLocation()*/]);
    if (!lstChecked[0]) return 'Wrong IP';
    if (!lstChecked[1]) return 'Wrong Location';

    final Either<Failure, AttendanceStatus> resAttendanceStatus = await checkAttendance();
    final attendanceStatus = resAttendanceStatus.fold((error) => error, (status) => status);
    if (attendanceStatus is Failure) return attendanceStatus.toString();

    var responseData;
    try {
      switch (attendanceType) {
        case AttendanceType.In:
          if (attendanceStatus == AttendanceStatus.NotCheckIn) {
            responseData = await Util.request(RequestType.PUT, urlRecordAttendance, {
              'in': DateTime.now().toString(),
            });
          } else
            return "Checked In Before !!!";
          break;
        case AttendanceType.Out:
          if (attendanceStatus == AttendanceStatus.NotCheckOut) {
            responseData = await Util.request(RequestType.PATCH, urlRecordAttendance, {
              'out': DateTime.now().toString(),
            });
          } else if (attendanceStatus == AttendanceStatus.CheckedOut)
            return "Checked Out Before !!!!";
          else
            return "Not Check In !!!";
          break;
      }

      if (responseData['error'] != null) return responseData['error'];

      return null;
    } catch (error) {
      return error.toString();
    }
  }
}
