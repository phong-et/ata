import 'package:ata/core/models/auth.dart';
import 'package:ata/core/models/failure.dart';
import 'package:ata/util.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

enum AttendanceType { In, Out }
enum AttendanceStatus { CheckedIn, CheckedOut, NotCheckIn, NotCheckOut }

class UserService {
  String _urlReports = "https://atapp-7720c.firebaseio.com/reports";
  Either<Failure, Auth> _auth;
  UserService(Either<Failure, Auth> auth) : _auth = auth;

  String get _localId {
    return _auth.fold((failure) => throw (failure.toString()), (auth) => auth.localId);
  }

  String get _idToken {
    return _auth.fold((failure) => throw (failure.toString()), (auth) => auth.idToken);
  }

  String get currentDateString {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String get urlRecordAttendance {
    return "$_urlReports/$_localId/$currentDateString.json?auth=$_idToken";
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

    return (await checkAttendance()).fold((failure) => failure.toString(), (attendanceStatus) async {
      try {
        var responseData;
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
        return responseData['error'] != null ? responseData['error'] : null;
      } catch (error) {
        return error.toString();
      }
    });
  }
}
