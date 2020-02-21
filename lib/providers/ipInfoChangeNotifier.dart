import 'package:ata/models/ipInfo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:ata/util.dart';
import 'package:ata/models/failure.dart';

enum NotifierState { init, loading, loaded }

class IpInfoChangeNotifier with ChangeNotifier {
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

    await Task(() async {
      final parsedJson =
          await Util.fetch(FetchType.GET, 'http://ip-api.com/jon');
      return IpInfo.fromJson(parsedJson);
    }).attempt().mapLeftToFailure().run().then((value) => _setIpInfo(value));

    _setNotifierState(NotifierState.loaded);
  }
}

extension TaskX<T extends Either<Object, U>, U> on Task<T> {
  Task<Either<Failure, U>> mapLeftToFailure() {
    return this.map(
      (either) => either.leftMap(
        (object) {
          try {
            return object as Failure;
          } catch (_) {
            throw object;
          }
        },
      ),
    );
  }
}
