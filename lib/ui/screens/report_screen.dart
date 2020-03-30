import 'package:ata/ui/widgets/ata_screen.dart';
import 'package:ata/ui/widgets/attendance_report.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AtaScreen(
      body: AttendanceReport()
    );
  }
}
