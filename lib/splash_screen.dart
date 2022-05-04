import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/eggs.png',
              width: 300, height: 300,
            ),
            CircularProgressIndicator(
              color: Colors.yellow,
            )
          ],
        ),
      ),
    );
  }
}
