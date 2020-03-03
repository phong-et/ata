import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/ip_info_service.dart';

class DeviceIpNotifier extends BaseNotifier {
  final IpInfoService _ipInfoService;
  DeviceIpNotifier(IpInfoService ipInfoService) : _ipInfoService = ipInfoService;

  String ipAddress;

  Future<void> getIpAddress() async {
    setBusy(true);
    await _ipInfoService.fetchDeviceIpInfo();
    _ipInfoService.ipInfo.fold(
      (failure) => ipAddress = failure.toString(),
      (ipInfo) => ipAddress = ipInfo.ipAddress,
    );
    setBusy(false);
  }
}
