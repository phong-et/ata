import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:ata/util.dart';
import 'package:ata/models/failure.dart';
import 'package:ata/models/ip_info.dart';

enum NotifierState { init, loading, loaded }

class IpInfoNotifier with ChangeNotifier {
  //* Notifier status
  NotifierState _state = NotifierState.init;
  NotifierState get state => _state;
  void _setNotifierState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  Either<Failure, IpInfo> _ipInfo;
  Either<Failure, IpInfo> get ipInfo => _ipInfo;
  void _setIpInfo(Either<Failure, IpInfo> ipInfo) {
    _ipInfo = ipInfo;
    notifyListeners();
  }

  void fetchDeviceIpInfo() async {
    _setNotifierState(NotifierState.loading);

    await Util.fetchDeviceIpInfo<IpInfo>().then((value) => _setIpInfo(value));

    _setNotifierState(NotifierState.loaded);
  }
}
