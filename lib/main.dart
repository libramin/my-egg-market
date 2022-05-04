import 'package:flutter/material.dart';
import 'package:my_egg_market/splash_screen.dart';

void main() {
  runApp(const MyEggApp());
}

class MyEggApp extends StatelessWidget {
  const MyEggApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 2), () => 100),
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
    return Container(
      color: Colors.orange,
    );
  }
}
