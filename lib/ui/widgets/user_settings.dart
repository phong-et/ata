import 'package:ata/core/notifiers/user_settings_notifier.dart';
import 'package:ata/ui/widgets/ata_button.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:ata/ui/widgets/user_image_previewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final displayNameController = TextEditingController();
  String photoUrl;

  @override
  void dispose() {
    super.dispose();
    displayNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<UserSettingsNotifier>(
      notifier: UserSettingsNotifier(Provider.of(context)),
      onNotifierReady: (notifier) => notifier.getUserSettings(),
      builder: (context, notifier, child) {
        displayNameController.text = notifier.busy ? 'Loading ...' : notifier.displayName;
        photoUrl = notifier.busy ? 'Loading ...' : notifier.photoUrl;
        return Column(
          children: <Widget>[
            Text(
              'User Profile',
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
              style: TextStyle(color: notifier.busy ? Colors.grey : Colors.black),
            ),
            UserImagePreviewer(
              photoUrl: photoUrl,
              loadingState: notifier.busy,
              onUpdateUrl: (url) => photoUrl = url,
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
                  onPressed:
                      notifier.busy ? null : () => notifier.saveUserSettings(displayNameController.text, photoUrl),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
