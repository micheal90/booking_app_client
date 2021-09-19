import 'package:booking_app_client/providers/auth_provider.dart';
import 'package:booking_app_client/screens/edit_profile_screen.dart';
import 'package:booking_app_client/screens/login_screen.dart';
import 'package:booking_app_client/screens/profile_image_screen.dart';
import 'package:booking_app_client/widgets_model/custom_list_tilr_profile.dart';
import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:booking_app_client/widgets_model/main_drawer.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  Future<dynamic> pickedDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => Consumer<AuthProvider>(
              builder: (context, valueAuth, child) => AlertDialog(
                title: Text('Choose the profile image'),
                content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.camera,
                          color: KPrimaryColor,
                        ),
                        title: Text('From Camera'),
                        onTap: () async {
                          await valueAuth.pickImage(ImageSource.camera);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.photo_library,
                          color: KPrimaryColor,
                        ),
                        title: Text('From Gallery'),
                        onTap: () async {
                          await valueAuth.pickImage(ImageSource.gallery);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.image_not_supported,
                          color: KPrimaryColor,
                        ),
                        title: Text('Remove'),
                        onTap: () async {
                          await valueAuth
                              .removeProfileImage(valueAuth.employeeModel!.id);

                          Navigator.pop(context);
                        },
                      ),
                      if (valueAuth.isLoading.value) CircularProgressIndicator()
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile Screen'),
          
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => EditProfileScreen())),
                child: CustomText(
                  text: 'Edit',
                  alignment: Alignment.center,
                  color: Colors.white,
                ))
          ],
        ),
        body: Consumer<AuthProvider>(
          builder: (context, value, child) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Stack(clipBehavior: Clip.none, children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ProfileImageScreen())),
                    child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey,
                            border: Border.all(color: Colors.grey)),
                        child: //check if image if  not equal null to show image saved in db
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: value.employeeModel!.imageUrl == ''
                                    ? Image.asset(
                                        'assets/images/profile.png',
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        value.employeeModel!.imageUrl,
                                        fit: BoxFit.fill,
                                      ))),
                  ),
                  Positioned(
                    bottom: -5,
                    right: -10,
                    child: Container(
                        //padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(40)),
                        child: IconButton(
                          onPressed: () {
                            pickedDialog(context);
                          },
                          icon: Icon(Icons.edit),
                        )),
                  )
                ]),
                SizedBox(
                  height: 20,
                ),
                CustomListTileProfile(
                  leading: Icon(Icons.person, color: KPrimaryColor),
                  title: 'Name',
                  subtitle: value.employeeModel!.name +
                      ' ' +
                      value.employeeModel!.lastName,
                ),
                CustomListTileProfile(
                  leading: Icon(Icons.group_rounded, color: KPrimaryColor),
                  title: 'Occupation Group',
                  subtitle: value.employeeModel!.occupationGroup,
                ),
                CustomListTileProfile(
                  leading: Icon(Icons.email, color: KPrimaryColor),
                  title: 'Email',
                  subtitle: value.employeeModel!.email,
                ),
                CustomListTileProfile(
                  leading: Icon(
                    Icons.phone,
                    color: KPrimaryColor,
                  ),
                  title: 'Phone',
                  subtitle: value.employeeModel!.phone,
                ),
                SizedBox(
                  height: 30,
                ),
                TextButton.icon(
                  onPressed: () {
                    value.logOut().then((value) =>
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        )));
                  },
                  icon: Icon(
                    Icons.logout,
                  ),
                  label: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  style: ButtonStyle(alignment: Alignment.center),
                )
              ]),
            ),
          ),
        ),
        drawer: MainDrawer(),
      ),
    );
  }
}
