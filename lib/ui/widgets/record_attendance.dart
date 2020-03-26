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

  final reasonTextFieldController = TextEditingController();
  Future showReasonDialog(BuildContext context, RecordAttendanceNotifier notifier, String reasonLabel) async {
    reasonTextFieldController.text = '';
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: reasonLabel),
                    controller: reasonTextFieldController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Ok"),
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () {
                          if (reasonTextFieldController.text != '') Navigator.of(context).pop();
                        },
                      ),
                      RaisedButton(
                        child: Text("Cancel"),
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () {
                          reasonTextFieldController.text = '';
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
    String reasonContent = reasonTextFieldController.text;
    if (reasonContent == '' || reasonContent == null) return null;
    switch(reasonLabel){
      case 'Reason checkin late': return  notifier.checkIn(reasonContent); 
      case 'Reason checkout early': return  notifier.checkOut(reasonContent); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<RecordAttendanceNotifier>(
      notifier: RecordAttendanceNotifier(Provider.of(context)),
      onNotifierReady: (notifier) => notifier.refresh(),
      builder: (context, notifier, child) {
        return SizedBox(
          width: 140.0,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AtaButton(
                  label: 'Check In',
                  color: Colors.green,
                  icon: Icon(Icons.add_location),
                  onPressed: notifier.attendanceStatus == AttendanceStatus.NotYetCheckedIn
                      ? (notifier.isLateCheckIn()
                          ? () => showReasonDialog(context, notifier, 'Reason checkin late')
                          : () => notifier.checkIn())
                      : null,
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
                  onPressed: notifier.attendanceStatus == AttendanceStatus.NotYetCheckedOut
                      ? (notifier.isEarlyCheckOut()
                          ? () => showReasonDialog(context, notifier, 'Reason checkout early')
                          : () => notifier.checkOut())
                      : null,
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
