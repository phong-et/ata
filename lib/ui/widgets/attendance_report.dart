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
  // Format DateTime -> DateString
  static String parseDateTime(DateTime dateTime) {
    return DateFormat("dd-MMM-yyyy").format(dateTime);
  }

  // Format DateTime -> TimeString
  static String formatTime(DateTime time) {
    if (time == null) return '-';
    return DateFormat('kk:mm a').format(time);
  }

  DateTime fromDate;
  DateTime toDate;
  @override
  void initState() {
    super.initState();
    toDate = DateTime.now();
    fromDate = new DateTime(toDate.year, toDate.month, 1);
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
                          DatePicker.showDatePicker(
                            context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true,
                            minTime: DateTime(2000, 01, 1),
                            maxTime: DateTime(2050, 12, 31),
                            onConfirm: (date) {
                              setState(
                                () {
                                  fromDate = date;
                                },
                              );
                            },
                            currentTime: fromDate,
                            locale: LocaleType.en,
                          );
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
                                          parseDateTime(fromDate),
                                          style: TextStyle(
                                            color: Colors.green[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
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
                                DatePicker.showDatePicker(
                                  context,
                                  theme: DatePickerTheme(
                                    containerHeight: 210.0,
                                  ),
                                  showTitleActions: true,
                                  minTime: DateTime(2000, 01, 1),
                                  maxTime: DateTime(2050, 12, 31),
                                  onConfirm: (date) {
                                    setState(
                                      () {
                                        toDate = date;
                                      },
                                    );
                                  },
                                  currentTime: toDate,
                                  locale: LocaleType.en,
                                );
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
                                                parseDateTime(toDate),
                                                style: TextStyle(
                                                  color: Colors.green[600],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0,
                                                ),
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
                          final checkInTime = notifier.attendanceRecordList[index].checkInTime;
                          final checkOutTime = notifier.attendanceRecordList[index].checkOutTime;
                          String totalTime = '-';
                          if (checkOutTime != null) {
                            totalTime = "${checkOutTime.difference(checkInTime).inHours}";
                          }
                          if (checkInTime.isBefore(toDate.add(new Duration(days: 1))) &&
                              checkInTime.isAfter(fromDate.subtract(new Duration(days: 0)))) {
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
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              parseDateTime(checkInTime),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
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
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              formatTime(checkInTime),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
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
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              formatTime(checkOutTime) == null ? '-' : formatTime(checkOutTime),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
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
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
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
                                              formatTime(checkOutTime) == null ? '-' : totalTime + ' Hrs ',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            formatTime(checkOutTime) == null
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
