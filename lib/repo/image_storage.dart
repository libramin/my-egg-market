import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageStorage {
  static Future<List<String>> uploadImages(List<Uint8List> images) async{
    if(FirebaseAuth.instance.currentUser == null){
      return [];
    }
    String userKey = FirebaseAuth.instance.currentUser!.uid;
    String timeMilli = DateTime.now().millisecondsSinceEpoch.toString();

    var metaData = SettableMetadata(contentType: 'image/jpeg');

    List<String> downloadUrls = [];

      for(int i = 0; i <images.length; i++){
        Reference ref = FirebaseStorage.instance.ref('images/${userKey}_$timeMilli/$i.jpg');
        if(images.isNotEmpty){await ref.putData(images[i],metaData).catchError((error){
          print(error.toString());
        });
        downloadUrls.add(await ref.getDownloadURL());
        }
      }
    return downloadUrls;
  }
}