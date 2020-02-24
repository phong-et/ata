import 'dart:convert';
import 'package:ata/widgets/ata_map.dart';
import 'package:flutter/material.dart';
import 'package:ata/util.dart';
//import 'package:ata/screens/loading-screen.dart';

class CheckInScreen extends StatelessWidget {
  Future<Map<String, dynamic>> getDeviceIP() async {
    try {
      var responseText =
          await Util.fetch(FetchType.GET, 'http://ip-api.com/json');
      final responseData = json.decode(responseText) as Map<String, dynamic>;
      return responseData;
    } catch (error) {
      return {'error': error};
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: ATAMap(
        centerMapLat: 10.7440878,
        centerMapLng: 106.7007886,
      ),
    );
  }
}
