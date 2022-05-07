import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/router/locations.dart';
import 'package:my_egg_market/screens/splash_screen.dart';
import 'package:my_egg_market/screens/start_screen.dart';
import 'package:my_egg_market/states/user_provider.dart';
import 'package:provider/provider.dart';

final _routerDelegate = BeamerDelegate(
    guards: [
      BeamGuard(
          pathBlueprints: ['/'],
        check: (context, location) {
          return context.watch<UserProvider>().userState;
        },
        showPage: BeamPage(child: StartScreen()),
      )
    ],
    locationBuilder:
        BeamerLocationBuilder(beamLocations: [HomeLocation()]));

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 1), () => 100),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _splashLoadingWidget(snapshot));
        });
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      return Container(color: Colors.blue);
    } else if (snapshot.hasData) {
      return EggApp();
    } else {
      return SplashScreen();
    }
  }
}

class EggApp extends StatelessWidget {
  const EggApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) {
        return UserProvider();
      },
      child: MaterialApp.router(
          routeInformationParser: BeamerParser(),
          routerDelegate: _routerDelegate,
          theme: ThemeData(
            primarySwatch: Colors.orange,
            textTheme: const TextTheme(
                button: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            hintColor: Colors.grey[400],
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0.4,
            ),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.orange,
                    primary: Colors.white,
                    minimumSize: const Size(47, 47))),
          )),
    );
  }
}
