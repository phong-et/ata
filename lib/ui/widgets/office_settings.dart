import 'package:ata/core/notifiers/office_settings_notifier.dart';
import 'package:ata/ui/widgets/ata_button.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfficeSettings extends StatelessWidget {
  final ipAddressController = TextEditingController();
  final lonController = TextEditingController();
  final latController = TextEditingController();
  final authRangeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<OfficeSettingsNotifier>(
      notifier: OfficeSettingsNotifier(Provider.of(context)),
      onNotifierReady: (notifier) => notifier.getOfficeSettings(),
      builder: (context, notifier, child) {
        ipAddressController.text = notifier.busy ? 'Loading ...' : notifier.ipAddress;
        lonController.text = notifier.busy ? 'Loading ...' : notifier.officeLon;
        latController.text = notifier.busy ? 'Loading ...' : notifier.officeLon;
        authRangeController.text = notifier.busy ? 'Loading ...' : notifier.authRange;
        return Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Office IP Address'),
              controller: ipAddressController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Office Location\'s Longitude'),
              controller: lonController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Office Location\'s Lattitude'),
              controller: latController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Authentication Range'),
              controller: authRangeController,
            ),
            SizedBox(
              height: 30,
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
                  onPressed: notifier.busy
                      ? null
                      : () => notifier.saveOfficeSettings(
                            ipAddressController.text,
                            lonController.text,
                            latController.text,
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
