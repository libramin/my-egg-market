import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future sendData() async {
    FirebaseFirestore.instance
        .collection('Users')
        .add({'username': 'hamin', 'useraddress': '대한민국'});
  }

  void readData() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc('U4fEHPrrRkhZ2GIxLrEY')
        .get()
        .then((docSnapshot) => print(docSnapshot.data()));
  }
}
