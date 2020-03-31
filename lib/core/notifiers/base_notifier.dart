import 'package:flutter/foundation.dart';

class BaseNotifier extends ChangeNotifier {
  bool _busy = false;
  bool get busy => _busy;

  bool _isDisposed = false;

  void setBusy(bool value) {
    _busy = value;
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }
}
