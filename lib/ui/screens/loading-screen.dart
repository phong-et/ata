import 'package:ata/ui/widgets/ata_screen.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AtaScreen(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
