import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ata/screens/login_screen.dart';
import 'package:ata/screens/home_screen.dart';
import 'package:ata/screens/loading-screen.dart';
import 'package:ata/providers/ip_info_notifier.dart';
import 'package:ata/providers/auth_notifier.dart';
import 'package:ata/providers/office_notifier.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthNotifier(),
        ),
        ChangeNotifierProvider.value(
          value: IpInfoNotifier(),
        ),
        ChangeNotifierProxyProvider<AuthNotifier, OfficeNotifier>(
          create: (_) => null,
          update: (_, authNotifier, officeNotifier) => OfficeNotifier(authNotifier.idToken),
        )
      ],
      child: Consumer<AuthNotifier>(
        builder: (ctx, authNotifier, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
            ),
            home: authNotifier.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: authNotifier.autoSignIn(),
                    builder: (ctx, AsyncSnapshot<bool> snapshot) => snapshot.connectionState == ConnectionState.waiting ? LoadingScreen() : (snapshot.data ? HomeScreen() : LoginScreen()),
                  ),
            routes: {
              HomeScreen.routeName: (_) => HomeScreen(),
              LoginScreen.routeName: (_) => LoginScreen(),
            },
          );
        },
      ),
    );
  }
}
