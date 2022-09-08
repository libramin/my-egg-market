import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:my_egg_market/repo/user_service.dart';
import 'package:my_egg_market/data/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/keys.dart';

class UserNotifier extends ChangeNotifier {
  UserNotifier() {
    initUser();
  }

  User? _user;
  UserModel? _userModel;

  void initUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) async{
      await _setNewUser(user);
      notifyListeners();
    });
  }

  Future _setNewUser(User? user) async {
    _user = user;
    if (user != null && user.phoneNumber !=null) {
      final prefs = await SharedPreferences.getInstance();
      final String address = prefs.getString(SHARED_ADDRESS) ?? '';
      final double lat = prefs.getDouble(SHARED_LAT) ?? 0;
      final double lon = prefs.getDouble(SHARED_LON) ?? 0;
      String userKey = user.uid;

      UserModel userModel = UserModel(
          userKey: user.uid,
          phoneNumber: user.phoneNumber!,
          address: address,
          geoFirePoint: GeoFirePoint(lat, lon),
          createdTime: DateTime.now());

      await UserService().createNewUser(userModel.toJson(), userKey);
      _userModel = await UserService().getUserModel(userKey);
      print(_userModel!.toJson().toString());
    }
  }

  set userModelReset (UserModel? userModel){
    _userModel = userModel;
  }

  User? get user => _user;
  UserModel? get userModel => _userModel;
}
