import 'package:ata/core/notifiers/attendance_report_notifier.dart';
import 'package:flutter/material.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceReport extends StatefulWidget {
  @override
  _AttendanceReportState createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  String attendanceFromDate;
  String attendanceToDate;

  // Format DateTime -> String
  static String parseDateTime(DateTime dateTime) {
    return DateFormat("y-MM-dd", 'en-US').format(dateTime);
  }

  // Convert String DateTime -> Object DateTime
  DateTime convertStringToDateTime(String string) {
    return DateTime.parse(string);
  }

  @override
  void initState() {
    super.initState();
    DateTime toDate = DateTime.now();
    DateTime fromDate = new DateTime(toDate.year, toDate.month, 1);
    attendanceFromDate = parseDateTime(fromDate);
    attendanceToDate = parseDateTime(toDate);
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<AttendanceReportNotifier>(
      notifier: AttendanceReportNotifier(Provider.of(context)),
      onNotifierReady: (notifier) => notifier.refresh(),
      builder: (context, notifier, child) {
        return Center(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(width: 15),
                      Text(
                        'From',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true,
                              minTime: DateTime(2000, 01, 1),
                              maxTime: DateTime(2050, 12, 31), onConfirm: (date) {
                            String parseFromDate = parseDateTime(date);
                            setState(() {
                              attendanceFromDate = parseFromDate;
                            });
                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          size: 14.0,
                                          color: Colors.green[600],
                                        ),
                                        Text(
                                          attendanceFromDate,
                                          style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold, fontSize: 14.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'To',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    theme: DatePickerTheme(
                                      containerHeight: 210.0,
                                    ),
                                    showTitleActions: true,
                                    minTime: DateTime(2000, 01, 1),
                                    maxTime: DateTime(2050, 12, 31), onConfirm: (date) {
                                  String parseToDate = parseDateTime(date);
                                  setState(() {
                                    attendanceToDate = parseToDate;
                                  });
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.date_range,
                                                size: 14.0,
                                                color: Colors.green[600],
                                              ),
                                              Text(
                                                attendanceToDate,
                                                style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold, fontSize: 14.0),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.green[600],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 380,
                child: notifier.busy
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: notifier.attendanceRecordList == null ? 0 : notifier.attendanceRecordList.length,
                        itemBuilder: (BuildContext context, int index) {
                          String attendanceDate = parseDateTime(notifier.attendanceRecordList[index].checkInTime);
                          final convertCheckInTime = notifier.attendanceRecordList[index].checkInTime;
                          String inTime = DateFormat('kk:mm a').format(convertCheckInTime);
                          final checkOutTime = notifier.attendanceRecordList[index].checkOutTime;
                          String outTime;
                          String totalTime;
                          if (checkOutTime != null) {
                            outTime = DateFormat('kk:mm a').format(checkOutTime);
                            totalTime = "${convertCheckInTime.difference(checkOutTime).inHours}";
                          }
                          final startDate = DateTime.parse(attendanceFromDate);
                          final endDate = DateTime.parse(attendanceToDate);
                          final rangeDate = DateTime.parse(attendanceDate);
                          if (rangeDate.isBefore(endDate.add(new Duration(days: 1))) && rangeDate.isAfter(startDate.subtract(new Duration(days: 1)))) {
                            String rangeDates = parseDateTime(rangeDate);
                            print(rangeDates);
                            return Container(
                              height: 50,
                              child: Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Date',
                                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              rangeDates,
                                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'In Time',
                                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              inTime,
                                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Out Time',
                                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              outTime == null ? '-' : outTime,
                                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Total Hours',
                                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              outTime == null ? '-' : totalTime + ' Hrs ',
                                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                            ),
                                            outTime == null
                                                ? Text('')
                                                : Icon(
                                                    Icons.access_time,
                                                    color: Colors.green[600],
                                                    size: 14,
                                                  ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return SizedBox();
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
