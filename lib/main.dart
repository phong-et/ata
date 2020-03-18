import 'package:ata/providers.dart';
import 'package:ata/ui/screens/home_screen.dart';
import 'package:ata/ui/screens/loading-screen.dart';
import 'package:ata/ui/screens/login_screen.dart';
import 'package:ata/ui/widgets/auth_redirect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;

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
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lastLifecycleState == AppLifecycleState.resumed || _lastLifecycleState == null)
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
    return MaterialApp(home: LoadingScreen());
  }
}
