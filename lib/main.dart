import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
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
          return context.watch<UserProvider>().user!=null;
        },
        showPage: BeamPage(child: StartScreen()),
      )
    ],
    locationBuilder:
        BeamerLocationBuilder(beamLocations: [HomeLocation(),InputLocation()]));

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _splashLoadingWidget(snapshot));
        });
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      return Container(color: Colors.blue);
    } else if (snapshot.connectionState == ConnectionState.done) {
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
