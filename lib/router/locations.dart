import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_egg_market/screens/home_screen.dart';
import 'package:my_egg_market/screens/input/input_screen.dart';
import 'package:my_egg_market/screens/input/category_input_screen.dart';
import 'package:my_egg_market/states/select_image_notifier.dart';
import 'package:provider/provider.dart';
import '../states/category_notifier.dart';

class HomeLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [BeamPage(child: HomeScreen(), key: ValueKey('home'))];
  }

  @override
  List get pathBlueprints => ['/'];
}

class InputLocation extends BeamLocation {
  @override
  Widget builder(BuildContext context, Widget navigator) {
    return super.builder(context, navigator);
  }

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      ...HomeLocation().buildPages(context, state),
      if (state.pathBlueprintSegments.contains('input'))
        BeamPage(
            child: MultiProvider(providers: [
              ChangeNotifierProvider.value(value: categoryNotifier),
              ChangeNotifierProvider(create: (context) => SelectImageNotifier())
            ], child: InputScreen()),
            key: ValueKey('input')),

      if (state.pathBlueprintSegments.contains('category_input'))
        BeamPage(
            child: ChangeNotifierProvider.value(
                value: categoryNotifier, child: CategoryInputScreen()),
            key: ValueKey('category_input'))
    ];
  }

  @override
  List get pathBlueprints => ['/input', '/category_input'];
}
