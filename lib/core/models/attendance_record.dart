import 'package:flutter/foundation.dart';

class AttendanceRecord {
  DateTime timeCheckIn;
  DateTime timeCheckOut;
  String lateReason;
  String earlyReason;
  String error;

  AttendanceRecord({
    @required this.timeCheckIn,
    @required this.timeCheckOut,
    @required this.lateReason,
    @required this.earlyReason,
    @required this.error,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> parsedJson) {
    return AttendanceRecord(
      timeCheckIn: DateTime.parse(parsedJson['timeCheckIn']),
      timeCheckOut: DateTime.parse(parsedJson['timeCheckIn']),
      lateReason: parsedJson['lateReason'],
      earlyReason: parsedJson['earlyReason'],
      error: parsedJson['error'] == null ? null : parsedJson['error'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'timeCheckIn': this.timeCheckIn.toIso8601String(),
      'timeCheckIn': this.timeCheckOut.toIso8601String(),
      'lateReason': this.lateReason,
      'earlyReason': this.lateReason,
      'error': this.error,
    };
  }
}
