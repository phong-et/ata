import 'package:ata/core/notifiers/user_settings_notifier.dart';
import 'package:ata/ui/widgets/ata_button.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final displayNameController = TextEditingController();
  final photoUrlController = TextEditingController();
  final photoUrlFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<UserSettingsNotifier>(
      notifier: UserSettingsNotifier(Provider.of(context, listen: false)),
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
              focusNode: photoUrlFocusNode,
              onEditingComplete: () {
                photoUrlFocusNode.unfocus();
                notifier.userImagePreviewer(
                  displayNameController.text,
                  photoUrlController.text,
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            Consumer<UserSettingsNotifier>(
              builder: (context, notifier, child) {
                return Container(
                  width: 120,
                  height: 120,
                  child: notifier.busy ? _imageLoading : _userImagePreviewer(photoUrlController.text),
                );
              },
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

Widget _userImagePreviewer(String url) {
  return ClipOval(
    child: CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Image(
        fit: BoxFit.cover,
        image: imageProvider,
      ),
      placeholder: (context, url) => _imageLoading,
      errorWidget: (context, url, error) => Icon(Icons.error),
    ),
  );
}

Widget get _imageLoading {
  return Center(
    child: SizedBox(
      width: 20.0,
      height: 20.0,
      child: CircularProgressIndicator(),
    ),
  );
}
