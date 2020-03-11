import 'package:ata/core/models/failure.dart';
import 'package:ata/core/models/user.dart';
import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/user_service.dart';
import 'package:dartz/dartz.dart';

class UserSettingsNotifier extends BaseNotifier {
  UserService _userService;

  UserSettingsNotifier(UserService userService) : _userService = userService;

  String displayName;
  String photoUrl;

  Future<void> getUserSettings() async {
    setBusy(true);
    Either<Failure, User> userSettings = await _userService.fetchUserInfo();
    setNotifierInfo(userSettings);
    setBusy(false);
  }

  Future<void> saveUserSettings(String displayName, String photoUrl) async {
    setBusy(true);
    Either<Failure, User> userSettings = await _userService.updateUserInfo(
      displayName,
      photoUrl,
    );
    setNotifierInfo(userSettings);
    setBusy(false);
  }

  void setNotifierInfo(Either<Failure, User> userSettings) {
    userSettings.fold(
      (failure) {
        displayName = failure.toString();
        photoUrl = failure.toString();
      },
      (user) {
        displayName = user.error == null ? user.displayName.toString() : user.error;
        photoUrl = user.error == null ? user.photoUrl.toString() : user.error;
      },
    );
  }
}
