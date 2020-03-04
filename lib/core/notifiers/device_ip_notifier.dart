import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/ip_info_service.dart';
import 'package:ata/core/services/office_service.dart';

class DeviceIpNotifier extends BaseNotifier {
  final IpInfoService _ipInfoService;
  final OfficeService _officeService;
  DeviceIpNotifier(IpInfoService ipInfoService, OfficeService officeService)
      : _ipInfoService = ipInfoService,
        _officeService = officeService;

  String ipAddress = '0.0.0.0';
  String _officeIpAddress = '1.1.1.1';
  bool isWithinOfficeNetwork = false;

  Future<void> compareWithOfficeIpAddress() async {
    setBusy(true);
    await _ipInfoService.fetchDeviceIpInfo();
    _ipInfoService.ipInfo.fold(
      (failure) => ipAddress = failure.toString(),
      (ipInfo) => ipAddress = ipInfo.ipAddress,
    );
    await _officeService.fetchOfficeSettings();
    _officeService.officeSettings.fold(
      (failure) => failure.toString(),
      (office) => _officeIpAddress = office.ipAddress,
    );
    isWithinOfficeNetwork = ipAddress == _officeIpAddress;
    setBusy(false);
  }
}
