import 'package:ata/core/notifiers/base_notifier.dart';

class UserImagePreviewerNotifier extends BaseNotifier {
  String photoUrl;

  void updatePhotoUrl(String url) {
    setBusy(true);
    photoUrl = url;
    setBusy(false);
  }
}
