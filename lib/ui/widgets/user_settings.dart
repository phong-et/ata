import 'package:ata/core/notifiers/user_settings_notifier.dart';
import 'package:ata/ui/widgets/ata_button.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatelessWidget {
  final displayNameController = TextEditingController();
  final photoUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<UserSettingsNotifier>(
      notifier: UserSettingsNotifier(Provider.of(context)),
      onNotifierReady: (notifier) => notifier.getUserSettings(),
      builder: (context, notifier, child) {
        displayNameController.text = notifier.busy ? 'Loading ...' : notifier.displayName;
        photoUrlController.text = notifier.busy ? 'Loading ...' : notifier.photoUrl;
        return Column(
          children: <Widget>[
            Text(
              'User Settings',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontSize: 30,
                color: Colors.green[800],
                shadows: [Shadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 5.0)],
              ),
            ),
            Divider(),
            TextField(
              decoration: InputDecoration(labelText: 'Display Name'),
              keyboardType: TextInputType.text,
              controller: displayNameController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Photo Url'),
              keyboardType: TextInputType.url,
              controller: photoUrlController,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AtaButton(
                  label: 'Refresh',
                  onPressed: notifier.busy ? null : () => notifier.getUserSettings(),
                ),
                SizedBox(width: 25.0),
                AtaButton(
                  label: 'Update',
                  icon: Icon(Icons.save),
                  onPressed: notifier.busy
                      ? null
                      : () => notifier.saveUserSettings(
                            displayNameController.text,
                            photoUrlController.text,
                          ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
