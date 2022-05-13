import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_egg_market/screens/home_screen.dart';
import 'package:my_egg_market/screens/input/input_screen.dart';

class HomeLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context,BeamState state) {
    return [BeamPage(child: HomeScreen(), key: ValueKey('home'))];
  }


  @override
  // TODO: implement pathBlueprints
  List get pathBlueprints => ['/'];
}
class InputLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context,BeamState state) {
    return [
      ...HomeLocation().buildPages(context, state),
      if(state.pathBlueprintSegments.contains('input'))
      BeamPage(child: InputScreen(), key: ValueKey('input'))];
  }


  @override
  // TODO: implement pathBlueprints
  List get pathBlueprints => ['/input'];
}