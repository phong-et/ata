import 'package:ata/core/services/auth_service.dart';
import 'package:ata/ui/screens/login_screen.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

String secretKey = 'aA123Bb321@8*iPg';
String authDomain = 'localhost:51457';

class QrcodeScannerDialog extends StatefulWidget {
  @override
  QrcodeScannerDialogState createState() => QrcodeScannerDialogState();
}

class QrcodeScannerDialogState extends State<QrcodeScannerDialog> with WidgetsBindingObserver {
  String scanResult = '';
  AuthService _authService;
  final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(secretKey), mode: encrypt.AESMode.cbc));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authService = Provider.of<AuthService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future scanQRCode() async {
    String cameraScanResult = await scanner.scan();
    setState(() {
      if (cameraScanResult != '') scanResult = decrypt(cameraScanResult);
      if (isInvalidQrCode(scanResult)) 
        Navigator.of(context).pop();
    });
  }

  String decrypt(String qrCode) {
    String decryptedCode;
    if (qrCode != '')
      try {
        decryptedCode = encrypter.decrypt64(qrCode, iv: encrypt.IV.fromUtf8(secretKey));
        decryptedCode = isInvalidQrCode(decryptedCode) ? decryptedCode : 'Error: Invalid QR code (1)';
      } on Exception catch (e) {
        decryptedCode = 'Error: Invalid QR code (2)';
        print(e);
      }
    return decryptedCode;
  }

  bool isInvalidQrCode(String qrCode) {
    return qrCode.contains(authDomain);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Please scan QR code from your office website'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: scanQRCode,
                  icon: Icon(Icons.crop_free),
                  label: Text('Scan QR'),
                  color: Colors.green,
                  textColor: Colors.white,
                ),
                RaisedButton(
                  child: Text("Cancel"),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () async {
                    await _authService.signOut();
                    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text(
              scanResult.contains('Error') ? scanResult : '',
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
