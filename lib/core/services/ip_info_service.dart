import 'package:ata/core/services/office_service.dart';
import 'package:dartz/dartz.dart';
import 'package:ata/util.dart';
import 'package:ata/core/models/failure.dart';
import 'package:ata/core/models/ip_info.dart';

class IpInfoService {
  final OfficeService _officeService;
  IpInfoService(OfficeService officeService) : _officeService = officeService;

  //* Model reference
  Either<Failure, IpInfo> _ipInfo;
  Either<Failure, IpInfo> get ipInfo => _ipInfo;
  void _setIpInfo(Either<Failure, IpInfo> ipInfo) {
    _ipInfo = ipInfo;
  }

  Future<void> fetchDeviceIpInfo() async {
    await Util.requestEither<IpInfo>(
      RequestType.GET,
      'http://ip-api.com/json',
    ).then((value) => _setIpInfo(value));
  }

  Future<bool> checkIpForAttendance() async {
    var deviceIp = await getDeviceIp();
    var officeIp = await getOfficeIp();
    return deviceIp == officeIp;
  }

  Future<String> getDeviceIp() async {
    await fetchDeviceIpInfo();
    return ipInfo.fold(
      (failure) => failure.toString(),
      (ipInfo) => ipInfo.ipAddress,
    );
  }

  Future<String> getOfficeIp() async {
    await _officeService.fetchOfficeSettings();
    return _officeService.officeSettings.fold(
      (failure) => failure.toString(),
      (office) => office.ipAddress,
    );
  }
}
