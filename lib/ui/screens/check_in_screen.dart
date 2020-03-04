import 'package:ata/ui/widgets/ata_map_office.dart';
import 'package:flutter/material.dart';
import 'package:ata/ui/widgets/device_ip.dart';

class CheckInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ATAMapOffice(),
          DeviceIp(),
        ],
      ),
    );
  }
}
