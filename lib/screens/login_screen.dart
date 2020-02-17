import 'package:ata/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login-screen';
  final inputBorder = BorderRadius.vertical(
    bottom: Radius.circular(10.0),
    top: Radius.circular(20.0),
  );

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);

    return FlutterLogin(
      title: 'Elitetech',
      onLogin: (loginData) => auth.authenticate(loginData.name, loginData.password, AuthType.SignIn),
      onSignup: (loginData) => auth.authenticate(loginData.name, loginData.password, AuthType.SignUp),
      onRecoverPassword: (_) => Future(null),
    );
  }
}
