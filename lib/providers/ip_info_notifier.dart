import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:ata/util.dart';
import 'package:ata/models/failure.dart';
import 'package:ata/models/ip_info.dart';

class IpInfoNotifier with ChangeNotifier {
  //* Notifier status
  NotifierState _state = NotifierState.INIT;
  NotifierState get state => _state;
  void _setNotifierState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  //* Model reference
  Either<Failure, IpInfo> _ipInfo;
  Either<Failure, IpInfo> get ipInfo => _ipInfo;
  void _setIpInfo(Either<Failure, IpInfo> ipInfo) {
    _ipInfo = ipInfo;
    notifyListeners();
  }

  void fetchDeviceIpInfo() async {
    _setNotifierState(NotifierState.LOADING);

    await Util.request<IpInfo>(RequestType.GET, 'http://ip-api.com/json').then((value) => _setIpInfo(value));

    _setNotifierState(NotifierState.LOADED);
  }
}
