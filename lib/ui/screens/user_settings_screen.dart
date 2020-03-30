import 'package:ata/ui/widgets/ata_screen.dart';
import 'package:flutter/material.dart';
import 'package:ata/ui/widgets/user_settings.dart';

class UserSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AtaScreen(
      body: UserSettings(),
    );
  }
}
