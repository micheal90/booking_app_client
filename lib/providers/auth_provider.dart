import 'dart:convert';
import 'dart:io';

import 'package:booking_app_client/models/employee_model.dart';
import 'package:booking_app_client/sevices/firebase_storage_image.dart';
import 'package:booking_app_client/sevices/firestore_users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  //firebase services
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirestoreUsers _firestoreUsers = FirestoreUsers();
  FirebaseStorageImage _firebaseStorageImage = FirebaseStorageImage();

  String? email;
  String? password;
  String? imgUrl;
  EmployeeModel? employeeModel;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final picker = ImagePicker();
  File? image;

  bool get isAuth {
    //check if found userData for auto login
    return employeeModel != null;
  }

  Future logInWithEmail() async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email!, password: password!)
          .then((userCredential) async {
        //get userData from database after login
        await getUserData(userCredential.user!.uid);
        //set user in sharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userData = json.encode({
          'email': employeeModel!.email,
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
    await _firestoreUsers.getEmployeeData(userId).then((userData) {
      employeeModel =
          EmployeeModel.fromMap(userData.data() as Map<String, dynamic>);
      //print('user: ${userModel!.toMap()}');
    });
    notifyListeners();
  }

  //set user in sharedPreferences
  Future setUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userData = json.encode({
      'email': employeeModel!.email,
      'userId': employeeModel!.id,
    });
    prefs.setString('userData', userData);
    print('set User');
  }

  //try auto log in if get user from sharedpreferences
  Future<bool> tryAutoLogIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    Map<String, dynamic> extractUserData =
        json.decode(prefs.getString('userData')!);
    //get all userData from database
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

  Future updateUserData({EmployeeModel? userUpdate}) async {
    isLoading.value = true;
    notifyListeners();
    if (userUpdate == null) {
      //used when edit userdata in edit screen
      await _firestoreUsers.updateEmployee(employeeModel!);
    } else {
      //used when add and remove image profile
      await _firestoreUsers.updateEmployee(userUpdate);
    }
    await getUserData(employeeModel!.id);
    isLoading.value = false;
    notifyListeners();
  }

  //upload image profile to firebase storage and get url
  Future<String> uploadProfileImage(
      {required String uid, required File file}) async {
    return _firebaseStorageImage.uploadFile(uid, file);
  }

  Future removeProfileImage(String uid) async {
    try {
      //delete image from firebase storage
      await _firebaseStorageImage.deleteImageByUrl(employeeModel!.imageUrl);

      //update userData after remove image
      await _firestoreUsers.updateEmployee(EmployeeModel(
          id: employeeModel!.id,
          name: employeeModel!.name,
          lastName: employeeModel!.lastName,
          occupationGroup: employeeModel!.occupationGroup,
          email: employeeModel!.email,
          imageUrl: '', //set empty string
          phone: employeeModel!.phone));

      //get userData after update userData
      await getUserData(employeeModel!.id);
    } catch (e) {
      print(e.toString());
    }
  }

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, imageQuality: 75);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      //save imagefile in db and get url
      imgUrl = await uploadProfileImage(uid: employeeModel!.id, file: image!);
      EmployeeModel _userModel = EmployeeModel(
        id: employeeModel!.id,
        name: employeeModel!.name,
        lastName: employeeModel!.lastName,
        occupationGroup: employeeModel!.occupationGroup,
        email: employeeModel!.email,
        imageUrl: imgUrl == null ? employeeModel!.imageUrl : imgUrl!,
        phone: employeeModel!.phone,
      );
      //update userData
      await updateUserData(userUpdate: _userModel);
      notifyListeners();
    } else {
      print('No image selected.');
    }
  }
}
