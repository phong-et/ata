import 'package:flutter/material.dart';

class AtaScreen extends StatelessWidget {
  final Widget body;
  AtaScreen({this.body});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          elevation: 8.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: body,
          ),
        ),
      ),
    );
  }
}
