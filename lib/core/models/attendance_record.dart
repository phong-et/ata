import 'package:flutter/foundation.dart';

class AttendanceRecord {
  DateTime checkInTime;
  DateTime checkOutTime;
  String lateReason;
  String error;

  AttendanceRecord({
    @required this.checkInTime,
    @required this.checkOutTime,
    @required this.lateReason,
    @required this.error,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> parsedJson) {
    return AttendanceRecord(
      checkInTime: DateTime.tryParse(parsedJson['in'].toString()),
      checkOutTime: DateTime.tryParse(parsedJson['out'].toString()),
      lateReason: parsedJson['lateReason'],
      error: parsedJson['error'] == null ? null : parsedJson['error'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'in': this.checkInTime.toIso8601String(),
      'out': this.checkOutTime.toIso8601String(),
      'lateReason': this.lateReason,
      'error': this.error,
    };
  }
}
