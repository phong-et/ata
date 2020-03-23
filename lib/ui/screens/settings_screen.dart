import 'package:ata/ui/widgets/ata_screen.dart';
import 'package:ata/ui/widgets/office_settings.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AtaScreen(
      body: OfficeSettings(),
    );
  }
}
