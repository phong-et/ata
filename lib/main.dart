import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ata/providers/auth.dart';
import 'package:ata/screens/login_screen.dart';
import 'package:ata/screens/home_screen.dart';
import 'package:ata/screens/loading-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // var auth = Provider.of<Auth>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
            ),
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.autoSignIn(),
                    builder: (ctx, AsyncSnapshot<bool> snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting ? LoadingScreen() : (snapshot.data ? HomeScreen() : LoginScreen()),
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
