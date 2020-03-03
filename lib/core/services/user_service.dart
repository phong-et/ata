import 'package:ata/core/models/auth.dart';
import 'package:ata/core/models/failure.dart';
import 'package:ata/util.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

enum AttendanceStatus { CheckedIn, CheckedOut, NotYetCheckedIn, NotYetCheckedOut }

class UserService {
  String _urlReports = "https://attendance-dcecd.firebaseio.com/reports";
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
    } catch (failure) {
      return Left(failure);
    }

    if (responseData != null) {
      if (responseData['error'] != null) return Left(Failure(responseData['error']));
      if (responseData['in'] != null) status = AttendanceStatus.CheckedIn;
      if (responseData['out'] != null)
        status = AttendanceStatus.CheckedOut;
      else
        status = AttendanceStatus.NotYetCheckedOut;
    } else
      status = AttendanceStatus.NotYetCheckedIn;
    return Right(status);
  }

  Future<String> checkLocationIP() async {
    List<bool> lstChecked = await Future.wait([/*checkIP(), checkLocation()*/]);
    if (!lstChecked[0]) return 'Wrong IP !!!';
    if (!lstChecked[1]) return 'Wrong Location !!!';
    return null;
  }

  Future<String> checkIn() async {
    String checkMsg = await checkLocationIP();
    if (checkMsg != null) return checkMsg;

    return (await checkAttendance()).fold(
      (failure) => failure.toString(),
      (attendanceStatus) async {
        try {
          var responseData;
          switch (attendanceStatus) {
            case AttendanceStatus.NotYetCheckedIn:
              responseData = await Util.request(RequestType.PUT, urlRecordAttendance, {
                'in': DateTime.now().toIso8601String(),
              });
              return responseData['error'] != null ? responseData['error'] : null;
            default:
              return "Already Checked In Before !!!";
          }
        } catch (error) {
          return error.toString();
        }
      },
    );
  }

  Future<String> checkOut() async {
    String checkMsg = await checkLocationIP();
    if (checkMsg != null) return checkMsg;

    return (await checkAttendance()).fold(
      (failure) => failure.toString(),
      (attendanceStatus) async {
        try {
          var responseData;
          switch (attendanceStatus) {
            case AttendanceStatus.NotYetCheckedOut:
              responseData = await Util.request(RequestType.PATCH, urlRecordAttendance, {
                'out': DateTime.now().toIso8601String(),
              });
              return responseData['error'] != null ? responseData['error'] : null;
            case AttendanceStatus.CheckedOut:
              return "Already Checked Out Before !!!";
            default:
              return "Not Yet Checked In !!!";
          }
        } catch (error) {
          return error.toString();
        }
      },
    );
  }
}
