import 'package:ata/core/notifiers/base_notifier.dart';
import 'package:ata/core/services/ip_info_service.dart';

class DeviceIpNotifier extends BaseNotifier {
  final IpInfoService _ipInfoService;
  DeviceIpNotifier(IpInfoService ipInfoService) : _ipInfoService = ipInfoService;

  String deviceIp = '0.0.0.0';
  bool isWithinOfficeNetwork = false;

  Future<void> refresh() async {
    setBusy(true);
    await _ipInfoService.refreshService();
    deviceIp = _ipInfoService.getDeviceIp();
    isWithinOfficeNetwork = _ipInfoService.checkIpForAttendance();
    setBusy(false);
  }
}
