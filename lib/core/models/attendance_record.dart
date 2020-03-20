import 'package:flutter/foundation.dart';

class AttendanceRecord {
  String dateAttendance;
  String timeCheckIn;
  String timeCheckOut;
  String reasonLate;
  String error;

  AttendanceRecord({
    @required this.dateAttendance,
    @required this.timeCheckIn,
    @required this.timeCheckOut,
    @required this.reasonLate,
    @required this.error,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> parsedJson,int index) {
    return AttendanceRecord(
      dateAttendance: parsedJson.keys.elementAt(index),
      timeCheckIn: parsedJson.values.elementAt(index)['in'],
      timeCheckOut: parsedJson.values.elementAt(index)['out'],
      reasonLate: parsedJson['reasonLate'],
      error: parsedJson['error'] == null ? null : parsedJson['error'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'dateTime': this.dateAttendance,
      'in': this.timeCheckIn,
      'out': this.timeCheckOut,
      'reasonLate': this.reasonLate,
      'error': this.error,
    };
  }
}
