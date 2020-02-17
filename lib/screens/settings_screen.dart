import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Settings Screen here'),
          Divider(),
          Text('Set Office IP'),
          Text('Set Office Location'),
        ],
      ),
    );
  }
}
