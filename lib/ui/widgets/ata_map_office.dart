import 'package:ata/ui/widgets/ata_map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:ata/core/notifiers/office_settings_notifier.dart';

class ATAMapOffice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<OfficeSettingsNotifier>(
        notifier: OfficeSettingsNotifier(Provider.of(context)),
        onNotifierReady: (notifier) => notifier.getOfficeSettings(),
        builder: (context, notifier, child) {
          return SizedBox(
            width: double.infinity,
            height: 350.0,
            child: Card(
              elevation: 10.0,
              color: Colors.green,
              child: notifier.busy
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ATAMap(
                        markedLng: double.parse(notifier.officeLon),
                        markedLat: double.parse(notifier.officeLat),
                        authRange: double.parse(notifier.authRange),
                      ),
                    ),
            ),
          );
        });
  }
}
