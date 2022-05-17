import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_egg_market/data/user_model.dart';
import '../constants/keys.dart';

class UserService {
  static final UserService _userService = UserService._internal();
  factory UserService() => _userService;
  UserService._internal();

  Future createNewUser(Map<String, dynamic> json, String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_USER).doc(userKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();
    if(!documentSnapshot.exists){
      await documentReference.set(json);
    }
  }

  Future<UserModel> getUserModel(String userKey)async{
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USER).doc(userKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentReference.get();
    UserModel userModel = UserModel.fromSnapshot(documentSnapshot);
    return userModel;
  }
}
