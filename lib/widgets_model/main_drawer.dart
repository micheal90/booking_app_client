import 'package:booking_app_client/providers/auth_provider.dart';
import 'package:booking_app_client/screens/Profile_screen.dart';
import 'package:booking_app_client/screens/my_reserved_devices_screen.dart';
import 'package:booking_app_client/screens/my_schedule_reservation.dart';
import 'package:booking_app_client/screens/veiw_screens/all_devices_screen.dart';
import 'package:booking_app_client/screens/veiw_screens/home_screen.dart';
import 'package:booking_app_client/widgets_model/custom_list_tile.dart';
import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:flutter/material.dart';
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
                            border: Border.all(color: Colors.grey)),
                        child: //check if image if  not equal null to show image saved in db
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: valueAuth.userModel!.imageUrl == ''
                                    ? Image.asset(
                                        'assets/images/profile.png',
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        valueAuth.userModel!.imageUrl,
                                        fit: BoxFit.fill,
                                      ))),
                    // CustomText(
                    //   text:
                    //       '${valueAuth.userModel!.name} ${valueAuth.userModel!.lastName}',
                    //   fontSize: 20,
                    //   color: Colors.white,
                    // ),
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
                                text: 'Logged as ', color: Colors.red[700]),
                            CustomText(
                              color: Colors.white,
                              text:
                                  '${valueAuth.userModel!.name} ${valueAuth.userModel!.lastName}',
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
              title: 'Available devices',
              leading: Icon(Icons.devices),
            ),
            CustomListTile(
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AllDevicesScreen())),
              title: 'All devices',
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
                title: 'My Schedule Reservation',
                leading: Icon(Icons.schedule)),
            CustomListTile(
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => MyReservedDevicesScreen())),
                title: 'My Reserved Devices',
                leading: Icon(Icons.mobile_friendly)),
            CustomListTile(
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProfileScreen())),
              title: 'Profile',
              leading: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
