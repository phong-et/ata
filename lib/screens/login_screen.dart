import 'package:ata/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import 'package:ata/providers/authNotifier.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login-screen';
  final inputBorder = BorderRadius.vertical(
    bottom: Radius.circular(10.0),
    top: Radius.circular(20.0),
  );

  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<AuthNotifier>(context);

    return FlutterLogin(
      title: 'Elitetech',
      onLogin: (loginData) => authNotifier.authenticate(loginData.name, loginData.password, AuthType.SignIn),
      onSignup: (loginData) => authNotifier.authenticate(loginData.name, loginData.password, AuthType.SignUp),
      onRecoverPassword: (_) => Future(null),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      },
    );
  }
}
