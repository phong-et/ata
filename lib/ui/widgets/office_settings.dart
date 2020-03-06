import 'package:ata/core/notifiers/office_settings_notifier.dart';
import 'package:ata/ui/widgets/ata_button.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfficeSettings extends StatelessWidget {
  final ipAddressController = TextEditingController();
  final lngController = TextEditingController();
  final latController = TextEditingController();
  final authRangeController = TextEditingController();

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
            TextField(
              decoration: InputDecoration(labelText: 'Office IP Address'),
              keyboardType: TextInputType.number,
              controller: ipAddressController,
              //* TextStyle currently cassing issue, will be fixed soon by Flutter team *//
              // style: TextStyle(color: notifier.busy ? Colors.grey : Colors.white),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Office Location\'s Lattitude'),
              keyboardType: TextInputType.number,
              controller: latController,
              // style: TextStyle(color: notifier.busy ? Colors.grey : Colors.white),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Office Location\'s Longitude'),
              keyboardType: TextInputType.number,
              controller: lngController,
              // style: TextStyle(color: notifier.busy ? Colors.grey : Colors.white),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Authentication Range (in meters)'),
              keyboardType: TextInputType.number,
              controller: authRangeController,
              // style: TextStyle(color: notifier.busy ? Colors.grey : Colors.white),
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
