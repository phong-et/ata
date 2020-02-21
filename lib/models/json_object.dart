import 'package:ata/models/ip_info.dart';

abstract class JsonObject {
  JsonObject.fromJson(Map<String, dynamic> x);
}

/// Add factory functions for every Type and every constructor you want to make available to `make`
final factories = <Type, Function>{IpInfo: (Map<String, dynamic> x) => IpInfo.fromJson(x)};

T make<T extends JsonObject>(Map<String, dynamic> x) {
  return factories[T](x);
}
