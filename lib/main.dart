import 'dart:convert';
import 'package:ata/providers.dart';
import 'package:ata/ui/widgets/auth_redirect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ata/ui/screens/login_screen.dart';
import 'package:ata/ui/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool isExpried = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    bool expiredState = await checkExpiredToken(state);
    setState(() {
      isExpried = expiredState;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isExpried) return LoginScreen();
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: AuthRedirect(),
        routes: {
          HomeScreen.routeName: (_) => HomeScreen(),
          LoginScreen.routeName: (_) => LoginScreen(),
        },
      ),
    );
  }
}

Future<bool> checkExpiredToken(AppLifecycleState state) async {
  switch (state) {
    case AppLifecycleState.resumed:
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('loginData')) {
        prefs.clear();
        return true;
      }
      final loginData = json.decode(prefs.getString('loginData')) as Map<String, Object>;
      final expiringDate = DateTime.parse(loginData['expiringDate']);

      if (expiringDate.isBefore(DateTime.now())) {
        prefs.clear();
        return true;
      } else
        return false;

      break;
    default:
      return false;
  }
}
