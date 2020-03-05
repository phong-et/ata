import 'package:ata/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:ata/core/notifiers/record_attendance_notifier.dart';
import 'package:ata/ui/widgets/ata_button.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:provider/provider.dart';

class RecordAttendance extends StatelessWidget {
  String showAttendanceMessage(AttendanceStatus attendanceStatus) {
    switch (attendanceStatus) {
      case AttendanceStatus.CheckedIn:
        return 'You\'ve just checked in!';
      case AttendanceStatus.CheckedOut:
        return 'You\'ve done for the day.';
      case AttendanceStatus.NotYetCheckedIn:
        return 'Please proceed to Check In.';
      case AttendanceStatus.NotYetCheckedOut:
        return 'Check Out to end your working day.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<RecordAttendanceNotifier>(
      notifier: RecordAttendanceNotifier(Provider.of(context), Provider.of(context), Provider.of(context)),
      onNotifierReady: (notifier) => notifier.refresh(),
      builder: (context, notifier, child) {
        return SizedBox(
          width: 150.0,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AtaButton(
                  label: 'Check In',
                  color: Colors.green,
                  icon: Icon(Icons.add_location),
                  onPressed:
                      notifier.attendanceStatus == AttendanceStatus.NotYetCheckedIn ? () => notifier.checkIn() : null,
                ),
                Text(
                  notifier.checkInStatus == null ? 'Success!' : notifier.checkInStatus,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: notifier.checkInStatus == null ? Colors.green[600] : Colors.red[600],
                    shadows: [Shadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 5.0)],
                  ),
                ),
                Divider(),
                AtaButton(
                  label: 'Check Out',
                  color: Colors.green,
                  icon: Icon(Icons.location_off),
                  onPressed:
                      notifier.attendanceStatus == AttendanceStatus.NotYetCheckedOut ? () => notifier.checkOut() : null,
                ),
                Text(
                  notifier.checkOutStatus == null ? 'Success!' : notifier.checkOutStatus,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: notifier.checkInStatus == null ? Colors.green[600] : Colors.red[600],
                    shadows: [Shadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 5.0)],
                  ),
                ),
                Divider(),
                Text(
                  showAttendanceMessage(notifier.attendanceStatus),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: Colors.blue[600],
                    shadows: [Shadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 5.0)],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
