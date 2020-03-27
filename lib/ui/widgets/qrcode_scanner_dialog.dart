import 'package:ata/ui/screens/login_screen.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

String secretKey = '6PAm5tu8zhKE9mSU';

class QrcodeScannerDialog extends StatefulWidget {
  @override
  QrcodeScannerDialogState createState() => QrcodeScannerDialogState();
}

class QrcodeScannerDialogState extends State<QrcodeScannerDialog> {
  String scanResult = '';
  String scanResultStatus = 'has\'t scanned yet';
  final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(secretKey), mode: encrypt.AESMode.cbc));
  //function that launches the scanner
  Future scanQRCode() async {
    String cameraScanResult = await scanner.scan();
    setState(() {
      scanResult = cameraScanResult;
    });
  }

  String decrypt(String qrCode) {
    try {
      return encrypter.decrypt64(qrCode, iv: encrypt.IV.fromUtf8(secretKey));
    } on Exception catch (e) {
      return 'Error:' + e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text("Scan QR Code"),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: scanQRCode,
                ),
                RaisedButton(
                  child: Text("Cancel"),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              scanResult != '' ? decrypt(scanResult) : '',
            ),
          ),
        ],
      ),
    );
  }
}
