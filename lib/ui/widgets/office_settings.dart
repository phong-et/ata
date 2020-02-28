import 'package:ata/core/notifiers/office_settings_notifier.dart';
import 'package:ata/ui/widgets/ata_button.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';

class OfficeSettings extends StatelessWidget {
  final ipAddressController = TextEditingController();
  final lonController = TextEditingController();
  final latController = TextEditingController();
  final authRangeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<OfficeSettingsNotifier>(
      notifier: OfficeSettingsNotifier(),
      builder: (context, notifier, child) {
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
              children: <Widget>[
                AtaButton(
                  label: 'Update',
                  onPressed: () {},
                ),
                AtaButton(
                  label: 'Update',
                  onPressed: () {},
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
