import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ata/screens/splash-screen.dart';

class CheckInScreen extends StatelessWidget {
  Future<Map<String, dynamic>> getDeviceIP() async {
    var response = await http.get('http://ip-api.com/json');
    final responseData = json.decode(response.body) as Map<String, dynamic>;

    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDeviceIP(),
      builder: (ctx, AsyncSnapshot<Map<String, dynamic>> snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? SplashScreen()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data['city']),
                      Text(snapshot.data['org']),
                      Text(snapshot.data['query']),
                    ],
                  ),
                ),
    );
  }
}
