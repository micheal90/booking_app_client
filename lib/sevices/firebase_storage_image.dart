import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageImage {
  Future<List<String>> uploadFiles(List<File> _images, String deviceId) async {
    var imageUrls = await Future.wait(
        _images.map((_image) => uploadFile(_image, deviceId)));
    print(imageUrls);
    return imageUrls;
  }

  Future<String> uploadFile(File _image, String deviceId) async {
    var path = _image.path.split('/').last;
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('devicesImages/$deviceId/$path');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() => null);

    return await storageReference.getDownloadURL();
  }

  Future deleteImageByUrl(String imageUrl) async {
    await firebase_storage.FirebaseStorage.instance
        .refFromURL(imageUrl)
        .delete()
        .then((value) => print('done'));
  }
}
