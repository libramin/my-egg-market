import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserProvider extends ChangeNotifier{

  UserProvider(){
    initUser();
  }

  User? _user;

  void initUser (){
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      print('my user status -$user');
    });
    notifyListeners();
  }

  // void setUserAuth(bool authState){
  //   _userLoggedIn = authState;
  //   notifyListeners();
  // }

  // bool get userState => _userLoggedIn;
User? get user => _user;

}