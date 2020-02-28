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
      onNotifierReady: (notifier) => notifier.getIpAddress(),
      builder: (context, notifier, child) {
        ipAddressController.text =
            notifier.busy ? 'Loading ...' : notifier.ipAddress;
        return Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Current IP Address:'),
                controller: ipAddressController,
                enabled: false,
              ),
            ),
            AtaButton(
              onPressed: () => notifier.getIpAddress(),
              label: 'Refresh',
            ),
          ],
        );
      },
    );
  }
}
