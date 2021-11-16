import 'package:booking_app_client/providers/auth_provider.dart';
import 'package:booking_app_client/screens/Profile_screen.dart';
import 'package:booking_app_client/screens/my_reserved_devices_screen.dart';
import 'package:booking_app_client/screens/my_schedule_reservation.dart';
import 'package:booking_app_client/screens/veiw_screens/all_devices_screen.dart';
import 'package:booking_app_client/screens/veiw_screens/home_screen.dart';
import 'package:booking_app_client/util/langs/translate_controller.dart';
import 'package:booking_app_client/widgets_model/custom_list_tile.dart';
import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<AuthProvider>(
              builder: (context, valueAuth, child) => Container(
                height: 150,
                padding:
                    EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 10),
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey,
                            border:
                                Border.all(color: Colors.black26, width: 3)),
                        child: //check if image if  not equal null to show image saved in db
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: valueAuth.employeeModel!.imageUrl == ''
                                    ? Image.asset(
                                        'assets/images/profile.png',
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        valueAuth.employeeModel!.imageUrl,
                                        fit: BoxFit.fill,
                                      ))),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomText(
                          text: 'Employee App',
                          alignment: Alignment.center,
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                                text: 'Logged as '.tr, color: Colors.red[700]),
                            CustomText(
                              color: Colors.white,
                              text:
                                  '${valueAuth.employeeModel!.name} ${valueAuth.employeeModel!.lastName}',
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            CustomListTile(
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen())),
              title: 'Available devices'.tr,
              leading: Icon(Icons.devices),
            ),
            CustomListTile(
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AllDevicesScreen())),
              title: 'All Devices'.tr,
              leading: Icon(Icons.apps),
            ),
            Divider(),
            // CustomListTile(
            //   onTap: () => Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(
            //           builder: (context) => AndroidDevicesScreen())),
            //   title: 'Adnroid Devices',
            //   leading: Icon(Icons.android),
            // ),
            // CustomListTile(
            //   onTap: () => Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (context) => IosDevicesScreen())),
            //   title: 'IOS Devices',
            //   leading: Icon(Icons.phone_android),
            // ),
            // CustomListTile(
            //   onTap: () => Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (context) => PcDevicesScreen())),
            //   title: 'PC Devices',
            //   leading: Icon(Icons.computer),
            // ),
            // Divider(),
            CustomListTile(
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => MyScheduleReservationScreen())),
                title: 'My Schedule Reservation'.tr,
                leading: Icon(Icons.schedule)),
            CustomListTile(
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => MyReservedDevicesScreen())),
                title: 'My Reserved Devices'.tr,
                leading: Icon(Icons.mobile_friendly)),
            CustomListTile(
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProfileScreen())),
              title: 'Profile'.tr,
              leading: Icon(Icons.person),
            ),
            GetBuilder<TranslateController>(
              init: Get.find<TranslateController>(),
              builder: (controller) => ListTile(
                leading: Icon(Icons.language),
                title: Row(children: [
                  CustomText(
                      text: 'English'.tr,
                    ),
                    Radio(
                        value: 'en',
                        groupValue: controller.selectedLang,
                        onChanged: (String? lang) =>
                            controller.changeLanguage(lang!)),
                   
                    CustomText(
                      text: 'Arabic'.tr,
                    ),
                    Radio(
                      value: 'ar',
                      groupValue: controller.selectedLang,
                      onChanged: (String? lang) =>
                          controller.changeLanguage(lang!),
                    )
                ],),
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
