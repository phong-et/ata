import 'package:ata/models/ip_info.dart';

/// Add factory functions for every Type and every constructor you want to make available to `make`
final factories = <Type, Function>{
  IpInfo: (Map<String, dynamic> x) => IpInfo.fromJson(x),
};

T make<T>(Map<String, dynamic> x) {
  return factories[T](x);
}
