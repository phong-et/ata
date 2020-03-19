import 'package:ata/ui/widgets/ata_screen.dart';
import 'package:ata/ui/widgets/office_settings.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AtaScreen(
      body: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: OfficeSettings(),
        ),
      ),
    );
  }
}
