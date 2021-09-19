import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageImage {
  

  Future<String> uploadFile(String? uid, File file) async {
    String imageUrl;
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('userPrefileImage/$uid')
        .child('imageProfile');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(file);
    firebase_storage.TaskSnapshot snapshot = await uploadTask;
    imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future deleteImageByUrl(String imageUrl) async {
    await firebase_storage.FirebaseStorage.instance
        .refFromURL(imageUrl)
        .delete()
        .then((value) => print('done'));
  }
}
