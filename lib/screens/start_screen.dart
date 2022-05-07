import 'package:flutter/material.dart';
import 'package:my_egg_market/screens/start/address_page.dart';
import 'package:my_egg_market/screens/start/auth_page.dart';
import 'package:my_egg_market/screens/start/intro_page.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider<PageController>.value(
      value: _pageController,
      child: Scaffold(
        body: PageView(
          // physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            IntroPage(),
            AddressPage(),
            AuthPage(),
          ],
        ),
      ),
    );
  }
}
