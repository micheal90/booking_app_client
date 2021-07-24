import 'dart:convert';
import 'dart:io';

import 'package:booking_app_client/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  ValueNotifier<bool> isShowPassword = ValueNotifier(true);
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? email;
  String? password;
  String? imgUrl;
  UserModel? userModel;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  bool get isAuth {
    return userModel != null;
  }

  final picker = ImagePicker();
  File? image;

  Future logInWithEmail() async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email!, password: password!)
          .then((userCredential) async {
        //userCredential = userCred;
        await getUserData(userCredential.user!.uid);

        //set in sharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userData = json.encode({
          'email': userModel!.email,
          'userId': userCredential.user!.uid,
        });
        prefs.setString('userData', userData);

        print('set User');
        print('user login');
      });
    } catch (e) {
      throw e;
    }
  }

  Future getUserData(String userId) async {
    CollectionReference userCollectionRef =
        FirebaseFirestore.instance.collection('users');
    await userCollectionRef.doc(userId).get().then((userData) {
      userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);
      //print('user: ${userModel!.toMap()}');
    });

    notifyListeners();
  }

  Future setUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userData = json.encode({
        'email': userModel!.email,
        'userId': userModel!.id,
      });
      prefs.setString('userData', userData);
      print('set User');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> tryAutoLogIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    Map<String, dynamic> extractUserData =
        json.decode(prefs.getString('userData')!);
    getUserData(extractUserData['userId']);

    print('get user data');
    notifyListeners();
    return true;
  }

  Future logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    prefs.clear();
  }

  Future updateUserData({UserModel? userUpdate}) async {
    isLoading.value = true;
    CollectionReference userCollectionRef =
        FirebaseFirestore.instance.collection('users');
    // UserModel _userModel = UserModel(
    //   id: userModel!.id,
    //   name: userModel!.name,
    //   lastName: userModel!.lastName,
    //   occupationGroup: userModel!.occupationGroup,
    //   email: userModel!.email,
    //   imageUrl: imgUrl == null ? userModel!.imageUrl : imgUrl!,
    //   phone: userModel!.phone,
    // );
    if (userUpdate == null) {
      await userCollectionRef.doc(userModel!.id).update(userModel!.toMap());
    } else {
      await userCollectionRef.doc(userUpdate.id).update(userUpdate.toMap());
      //print(userUpdate.toMap());
    }
    await getUserData(userModel!.id);
    isLoading.value = false;
    notifyListeners();
  }

  Future<String> uploadProfileImage(String? uid, File file) async {
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

  void changeShowPassword() {
    isShowPassword.value = !isShowPassword.value;
    notifyListeners();
  }

  Future removeProfileImage(String uid) async {
    CollectionReference userCollectionRef =
        FirebaseFirestore.instance.collection('users');
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('userPrefileImage/$uid/imageProfile')
          .delete();
      await userCollectionRef.doc(userModel!.id).update(UserModel(
              id: userModel!.id,
              name: userModel!.name,
              lastName: userModel!.lastName,
              occupationGroup: userModel!.occupationGroup,
              email: userModel!.email,
              imageUrl: '',
              phone: userModel!.phone)
          .toMap());
      await getUserData(userModel!.id);
    } catch (e) {
      print(e.toString());
    }
  }

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, imageQuality: 75);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      //save imagefile in db
      imgUrl = await uploadProfileImage(userModel!.id, image!);
      //userModel!.imageUrl = imgUrl!;
      UserModel _userModel = UserModel(
        id: userModel!.id,
        name: userModel!.name,
        lastName: userModel!.lastName,
        occupationGroup: userModel!.occupationGroup,
        email: userModel!.email,
        imageUrl: imgUrl == null ? userModel!.imageUrl : imgUrl!,
        phone: userModel!.phone,
      );
      await updateUserData(userUpdate: _userModel);
      notifyListeners();
    } else {
      print('No image selected.');
    }
  }
}
