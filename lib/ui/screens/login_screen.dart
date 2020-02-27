import 'package:ata/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import 'package:ata/core/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login-screen';
  final inputBorder = BorderRadius.vertical(
    bottom: Radius.circular(10.0),
    top: Radius.circular(20.0),
  );

  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context);

    return FlutterLogin(
      title: 'Elitetech',
      onLogin: (loginData) => authService.authenticate(loginData.name, loginData.password, AuthType.SignIn),
      onSignup: (loginData) => authService.authenticate(loginData.name, loginData.password, AuthType.SignUp),
      onRecoverPassword: (_) => Future(null),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      },
    );
  }
}
