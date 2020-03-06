import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ata/core/services/location_service.dart';
import 'package:ata/core/services/office_service.dart';
import 'package:ata/core/services/user_service.dart';
import 'package:ata/core/services/auth_service.dart';
import 'package:ata/core/services/ip_info_service.dart';

List<SingleChildWidget> providers = [
  ...services,
  ...uIservices,
  ...proxyServices,
  ...proxyUiServices,
];

List<SingleChildWidget> services = [];

List<SingleChildWidget> uIservices = [
  Provider<AuthService>(
    create: (_) => AuthService(),
  )
];

List<SingleChildWidget> proxyServices = [
  ProxyProvider<AuthService, OfficeService>(
    update: (_, authService, __) => OfficeService(authService),
  ),
  ProxyProvider<OfficeService, LocationService>(
    update: (_, officeService, __) => LocationService(officeService),
  ),
  ProxyProvider<OfficeService, IpInfoService>(
    update: (_, officeService, __) => IpInfoService(officeService),
  ),
  ProxyProvider3<AuthService, LocationService, IpInfoService, UserService>(
    update: (
      _,
      authService,
      locationService,
      ipInfoService,
      __,
    ) =>
        UserService(
      authService,
      locationService,
      ipInfoService,
    ),
  ),
];

List<SingleChildWidget> proxyUiServices = [];
