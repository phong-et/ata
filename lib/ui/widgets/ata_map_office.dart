import 'package:ata/core/notifiers/ata_map_office_notifier.dart';
import 'package:ata/ui/widgets/ata_map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ata/ui/widgets/base_widget.dart';

class AtaMapOffice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<AtaMapOfficeNotifier>(
        notifier: AtaMapOfficeNotifier(Provider.of(context), Provider.of(context)),
        onNotifierReady: (notifier) => notifier.compareWithOfficeAuthRange(),
        builder: (context, notifier, child) {
          return SizedBox(
            width: double.infinity,
            height: 350.0,
            child: Card(
              elevation: 10.0,
              color: notifier.busy ? Colors.yellow : (notifier.isWithinOfficeAuthRange ? Colors.green : Colors.red),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  child: notifier.busy
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : AtaMap(
                          markedLat: notifier.officeLocation.lat,
                          markedLng: notifier.officeLocation.lng,
                          authRange: notifier.authRange,
                        ),
                ),
              ),
            ),
          );
        });
  }
}
