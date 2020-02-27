import 'package:dartz/dartz.dart';
import 'package:ata/util.dart';
import 'package:ata/core/models/failure.dart';
import 'package:ata/core/models/ip_info.dart';

class IpInfoService {
  //* Model reference
  Either<Failure, IpInfo> _ipInfo;
  Either<Failure, IpInfo> get ipInfo => _ipInfo;
  void _setIpInfo(Either<Failure, IpInfo> ipInfo) {
    _ipInfo = ipInfo;
  }

  void fetchDeviceIpInfo() async {
    await Util.request<IpInfo>(RequestType.GET, 'http://ip-api.com/json').then((value) => _setIpInfo(value));
  }
}
