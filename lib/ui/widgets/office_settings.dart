import 'package:ata/core/notifiers/office_settings_notifier.dart';
import 'package:ata/ui/widgets/ata_button.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'ata_map.dart';

class OfficeSettings extends StatelessWidget {
  final ipAddressController = TextEditingController();
  final lngController = TextEditingController();
  final latController = TextEditingController();
  final authRangeController = TextEditingController();
  final dateIpServiceUrlController = TextEditingController();
  final starTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final acceptableLateTimeController = TextEditingController();

  Future<DateTime> showPicker(context, currentValue) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
    );
    if (time != null) return DateTimeField.combine(DateTime.now(), time);
    return currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<OfficeSettingsNotifier>(
      notifier: OfficeSettingsNotifier(Provider.of(context)),
      onNotifierReady: (notifier) => notifier.getOfficeSettings(),
      builder: (context, notifier, child) {
        ipAddressController.text = notifier.busy ? 'Loading ...' : notifier.ipAddress;
        latController.text = notifier.busy ? 'Loading ...' : notifier.officeLat;
        lngController.text = notifier.busy ? 'Loading ...' : notifier.officeLng;
        authRangeController.text = notifier.busy ? 'Loading ...' : notifier.authRange;
        dateIpServiceUrlController.text = notifier.busy ? 'Loading ...' : notifier.dateIpServiceUrl;
        starTimeController.text = notifier.busy ? 'Loading ...' : notifier.startTime;
        endTimeController.text = notifier.busy ? 'Loading ...' : notifier.endTime;
        acceptableLateTimeController.text = notifier.busy ? 'Loading ...' : notifier.acceptableLateTime;
        return Column(
          children: <Widget>[
            Text(
              'Admin Settings',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontSize: 30,
                color: Colors.green[800],
                shadows: [Shadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 5.0)],
              ),
            ),
            Divider(),
            Text(
              '(Tap and Hold to select Office Location)',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 300.0,
              child: Card(
                elevation: 10.0,
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    color: Colors.white,
                    child: notifier.busy
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : AtaMap(
                            markedLat: double.tryParse(notifier.officeLat),
                            markedLng: double.tryParse(notifier.officeLng),
                            isMoveableMarker: true,
                            authRange: double.tryParse(notifier.authRange),
                            onLongPress: (LatLng point) => notifier.setOfficeLocation(
                              point.latitude.toString(),
                              point.longitude.toString(),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Office Location\'s Lattitude'),
              keyboardType: TextInputType.number,
              controller: latController,
              style: TextStyle(color: notifier.busy ? Colors.grey : Colors.black),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Office Location\'s Longitude'),
              keyboardType: TextInputType.number,
              controller: lngController,
              style: TextStyle(color: notifier.busy ? Colors.grey : Colors.black),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Authentication Range (in meters)'),
              keyboardType: TextInputType.number,
              controller: authRangeController,
              style: TextStyle(color: notifier.busy ? Colors.grey : Colors.black),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Office IP Address'),
              keyboardType: TextInputType.number,
              controller: ipAddressController,
              style: TextStyle(color: notifier.busy ? Colors.grey : Colors.black),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Date IP and Service Url'),
              keyboardType: TextInputType.url,
              controller: dateIpServiceUrlController,
              style: TextStyle(color: notifier.busy ? Colors.grey : Colors.black),
            ),
            DateTimeField(
              resetIcon: null,
              decoration: InputDecoration(labelText: 'Working-Hour From'),
              keyboardType: TextInputType.datetime,
              controller: starTimeController,
              style: TextStyle(color: notifier.busy ? Colors.grey : Colors.black),
              format: DateFormat.Hm(),
              onShowPicker: showPicker,
            ),
            DateTimeField(
              resetIcon: null,
              decoration: InputDecoration(labelText: 'Working-Hour To'),
              keyboardType: TextInputType.datetime,
              controller: endTimeController,
              style: TextStyle(color: notifier.busy ? Colors.grey : Colors.black),
              format: DateFormat.Hm(),
              onShowPicker: showPicker,
            ),
            Visibility(
              child: TextField(
                decoration: InputDecoration(labelText: 'Acceptable Late Time(minute)'),
                keyboardType: TextInputType.number,
                controller: acceptableLateTimeController,
                style: TextStyle(color: notifier.busy ? Colors.grey : Colors.black),
              ),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: true,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AtaButton(
                  label: 'Refresh',
                  onPressed: notifier.busy ? null : () => notifier.getOfficeSettings(),
                ),
                SizedBox(width: 25.0),
                AtaButton(
                  label: 'Update',
                  icon: Icon(Icons.save),
                  onPressed: notifier.busy
                      ? null
                      : () => notifier.saveOfficeSettings(
                            ipAddressController.text,
                            latController.text,
                            lngController.text,
                            authRangeController.text,
                            dateIpServiceUrlController.text,
                            starTimeController.text,
                            endTimeController.text,
                            acceptableLateTimeController.text,
                          ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
