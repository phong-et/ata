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
  static DateTime now = DateTime.now();
  static DateTime firstDayOfMonth = new DateTime(now.year, now.month, 1);
  String fromDate = parseDateTime(firstDayOfMonth);
  String toDate = parseDateTime(now);

  String parseFromDate;
  String parseToDate;

  String fromDateAttendance;
  String toDateAttendance;

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
    fromDateAttendance = fromDate;
    toDateAttendance = toDate;
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
                                          size: 14.0,
                                          color: Colors.green[600],
                                        ),
                                        Text(
                                          fromDateAttendance,
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
                                                size: 14.0,
                                                color: Colors.green[600],
                                              ),
                                              Text(
                                                toDateAttendance,
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
                height: 15,
              ),
              Container(
                height: 400,
                child: notifier.busy
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[300],
                        ),
                        itemCount: notifier.attendanceRecordList == null ? 0 : notifier.attendanceRecordList.length,
                        itemBuilder: (BuildContext context, int index) {
                          String ataDate = parseDateTime(notifier.attendanceRecordList[index].checkInTime);
                          final convertCheckInTime = notifier.attendanceRecordList[index].checkInTime;
                          String inTime = DateFormat('kk:mm a').format(convertCheckInTime);
                          final checkOutTime = notifier.attendanceRecordList[index].checkOutTime;
                          String outTime;
                          String ataTotalTime;
                          if (checkOutTime != null) {
                            outTime = DateFormat('kk:mm a').format(checkOutTime);
                            ataTotalTime = "${convertCheckInTime.difference(checkOutTime).inHours}";
                          }
                          final startDate = DateTime.parse(fromDateAttendance);
                          final endDate = DateTime.parse(toDateAttendance);
                          final rangeAtaDate = DateTime.parse(ataDate);
                          if (rangeAtaDate.isBefore(endDate) && rangeAtaDate.isAfter(startDate)) {
                            String rangeDates = parseDateTime(rangeAtaDate);
                            print(rangeDates);
                            return Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
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
                                      Row(children: [
                                        Text(
                                          rangeDates,
                                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                        ),
                                      ])
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Row(children: [
                                        Text(
                                          'In Time',
                                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                        ),
                                      ]),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(children: [
                                        Text(
                                          inTime,
                                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                        ),
                                      ])
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Row(children: [
                                        Text(
                                          'Out Time',
                                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                        ),
                                      ]),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(children: [
                                        Text(
                                          outTime == null ? 'Forgot' : outTime,
                                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                        ),
                                      ])
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Text(
                                            'Total Hours',
                                            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            outTime == null ? '' : ataTotalTime + ' Hrs ',
                                            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.0),
                                          ),
                                          outTime == null
                                              ? Text('')
                                              : Icon(
                                                  Icons.access_time,
                                                  color: Colors.green[600],
                                                ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
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
