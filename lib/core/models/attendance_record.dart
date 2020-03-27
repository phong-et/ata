import 'package:flutter/foundation.dart';
class AttendanceRecord {
  DateTime checkInTime;
  DateTime checkOutTime;
  String lateReason;
  String earlyReason;
  String error;

  AttendanceRecord({
    @required this.checkInTime,
    @required this.checkOutTime,
    @required this.lateReason,
    @required this.earlyReason,
    @required this.error,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> parsedJson) {
    return AttendanceRecord(
      checkInTime: DateTime.parse(parsedJson['checkInTime']),
      checkOutTime: DateTime.parse(parsedJson['checkOutTime']),
      lateReason: parsedJson['lateReason'],
      earlyReason: parsedJson['earlyReason'],
      error: parsedJson['error'] == null ? null : parsedJson['error'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'checkInTime': this.checkInTime.toIso8601String(),
      'checkOutTime': this.checkOutTime.toIso8601String(),
      'lateReason': this.lateReason,
      'earlyReason': this.lateReason,
      'error': this.error,
    };
  }
}