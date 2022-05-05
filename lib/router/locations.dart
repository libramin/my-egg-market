import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:my_egg_market/screens/start_screen.dart';
import 'package:my_egg_market/screens/home_screen.dart';

class HomeLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable state) {
    return [BeamPage(child: HomeScreen(), key: ValueKey('home'))];
  }

  @override
  List<Pattern> get pathPatterns => ['/'];
}

class AuthLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable state) {
    return [BeamPage(child: StartScreen(), key: ValueKey('auth'))];
  }

  @override
  List<Pattern> get pathPatterns => ['/auth'];
}