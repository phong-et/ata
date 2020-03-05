import 'package:ata/ui/widgets/ata_button.dart';
import 'package:flutter/material.dart';

class RecordAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AtaButton(
            label: 'Check In',
            color: Colors.green,
            icon: Icon(Icons.add_location),
            onPressed: () {},
          ),
          AtaButton(
            label: 'Check Out',
            color: Colors.green,
            icon: Icon(Icons.location_off),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
