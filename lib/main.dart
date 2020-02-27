import 'package:ata/providers.dart';
import 'package:ata/ui/widgets/auth_redirect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ata/ui/screens/login_screen.dart';
import 'package:ata/ui/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
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
