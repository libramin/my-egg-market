import 'package:flutter/material.dart';
import 'package:my_egg_market/screens/start/intro_page.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          IntroPage(),
          Container(color: Colors.green,),
          Container(color: Colors.tealAccent,)
        ],
      ),
    );
  }
}
