import 'package:ata/core/notifiers/device_ip_notifier.dart';
import 'package:ata/ui/widgets/ata_button.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeviceIp extends StatelessWidget {
  final ipAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<DeviceIpNotifier>(
      notifier: DeviceIpNotifier(Provider.of(context)),
      onNotifierReady: (notifier) => notifier.refresh(),
      builder: (context, notifier, child) {
        ipAddressController.text = notifier.busy ? 'Loading ...' : notifier.deviceIp;
        return SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 10.0,
            color: notifier.busy ? Colors.yellow : (notifier.isWithinOfficeNetwork ? Colors.green : Colors.red),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Current IP Address:'),
                          controller: ipAddressController,
                          enabled: false,
                        ),
                      ),
                      AtaButton(
                        onPressed: notifier.busy ? null : () => notifier.refresh(),
                        color: notifier.busy
                            ? Colors.yellow
                            : (notifier.isWithinOfficeNetwork ? Colors.green : Colors.red),
                        label: 'Refresh',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
