import 'package:ata/ui/widgets/report_attendance.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:ReportAttendance()
    );
  }
}
