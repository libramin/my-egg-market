import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/router/locations.dart';
import 'package:my_egg_market/screens/splash_screen.dart';

final _routerDelegate = BeamerDelegate(
    guards: [
      BeamGuard(
        pathPatterns: ['/'],
        check: (context, location) {
          return false;
        },
        beamToNamed: (origin, target) => '/auth',
        // showPage: BeamPage(child: AuthScreen()))
      )
    ],
    locationBuilder:
        BeamerLocationBuilder(beamLocations: [HomeLocation(), AuthLocation()]));

void main() {
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
              duration: Duration(milliseconds: 300),
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
    return MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: _routerDelegate,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: TextTheme(button: TextStyle(color: Colors.white,fontWeight: FontWeight.w600))
      ),
    );
  }
}
