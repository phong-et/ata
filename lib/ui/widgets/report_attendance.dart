import 'package:ata/core/models/attendance_record.dart';
import 'package:ata/core/notifiers/report_attendance_notifier.dart';
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
  static DateTime now = DateTime.now();
  String fromtDate = parseDateTime(now);
  String toDate = parseDateTime(now);

  String parseFromDate;
  String parseToDate;

  String fromDateAttendance;
  String toDateAttendance;

  // Format DateTime -> String
  static String parseDateTime(DateTime dateTime) {
    return DateFormat("y-MM-d", 'en-US').format(dateTime);
  }

  // Convert String DateTime -> Object DateTime
  DateTime convertStringToDateTime(String string) {
    return DateTime.parse(string);
  }

  @override
  void initState() {
    super.initState();
    fromDateAttendance = fromtDate;
    toDateAttendance = toDate;
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<AttendanceReportNotifier>(
        notifier: AttendanceReportNotifier(Provider.of(context)),
        onNotifierReady: (notifier) => notifier.refresh(),
        builder: (context, notifier, child) {
          return Center(
              child: Column(children: [
            Column(children: <Widget>[
              Container(
                  height: 120,
                  child: Card(
                      color: Colors.grey[100],
                      margin: EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      elevation: 8.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(width: 15),
                              Text('From',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                  )),
                              FlatButton(
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      theme: DatePickerTheme(
                                        containerHeight: 210.0,
                                      ),
                                      showTitleActions: true,
                                      minTime: DateTime(2000, 01, 1),
                                      maxTime: DateTime(2050, 12, 31), onConfirm: (date) {
                                    parseFromDate = parseDateTime(date);
                                    setState(() {
                                      fromDateAttendance = parseFromDate;
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
                                                  size: 20.0,
                                                  color: Colors.green[600],
                                                ),
                                                Text(
                                                  fromDateAttendance,
                                                  style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold, fontSize: 15.0),
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
                                  Text('To',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.italic,
                                      )),
                                  FlatButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          theme: DatePickerTheme(
                                            containerHeight: 210.0,
                                          ),
                                          showTitleActions: true,
                                          minTime: DateTime(2000, 01, 1),
                                          maxTime: DateTime(2050, 12, 31), onConfirm: (date) {
                                        parseToDate = parseDateTime(date);
                                        setState(() {
                                          toDateAttendance = parseToDate;
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
                                                      size: 20.0,
                                                      color: Colors.green[600],
                                                    ),
                                                    Text(
                                                      toDateAttendance,
                                                      style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold, fontSize: 15.0),
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
                              )),
                            ],
                          ),
                          Divider(),
                          titleReport()
                        ],
                      ))),
            ]),
            Container(
                height: 400,
                child: Card(
                  color: Colors.grey[100],
                  margin: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  elevation: 8.0,
                  child: ListView.builder(
                    itemCount: notifier.attendanceRecordList == null ? 0 : notifier.attendanceRecordList.length,
                    itemBuilder: (BuildContext context, int index) {
                      AttendanceRecord attendanceRecord = AttendanceRecord.fromJson(notifier.attendanceRecordList, index);
                      String daysAttendance = attendanceRecord.dateAttendance;
                      String timeCheckIn = attendanceRecord.timeCheckIn;
                      final convertTimeCheckIn = DateTime.parse(timeCheckIn);
                      String timeIn = DateFormat('kk:mm a').format(convertTimeCheckIn);
                      String timeCheckOut = attendanceRecord.timeCheckOut;
                      String timeOut;
                      String sumTimeAttendance;
                      if (timeCheckOut != null) {
                        DateTime convertTimeCheckOut = DateTime.parse(timeCheckOut);
                        timeOut = DateFormat('kk:mm a').format(convertTimeCheckOut);
                        sumTimeAttendance = "${convertTimeCheckIn.difference(convertTimeCheckOut).inHours}";
                      }
                      final startDay = DateTime.parse(fromDateAttendance);
                      final endDay = DateTime.parse(toDateAttendance);
                      final rangeDayAttendance = DateTime.parse(daysAttendance);
                      if (rangeDayAttendance.isBefore(endDay) && rangeDayAttendance.isAfter(startDay)) {
                        String rangeDays = parseDateTime(rangeDayAttendance);
                        print(rangeDays);
                        return Card(
                          child: Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(rangeDays, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14.0)),
                                  Text(timeIn, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14.0)),
                                  Text(timeCheckOut == null ? 'ForgotCheckOut' : timeOut,
                                      style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14.0)),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    Text(timeCheckOut == null ? '' : sumTimeAttendance + ' Hrs ',
                                        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14.0)),
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.green[600],
                                    ),
                                  ])
                                ],
                              )),
                          margin: EdgeInsets.all(8.0),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                )),
          ]));
        });
  }

  Widget titleReport() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text('Date',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            )),
        Text('In Time',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            )),
        Text('Out Time',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            )),
        Text('Total Hours',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            )),
      ],
    );
  }
}
