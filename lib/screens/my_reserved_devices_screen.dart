import 'package:booking_app_client/constants.dart';
import 'package:booking_app_client/providers/main_provider.dart';
import 'package:booking_app_client/widgets_model/custom_alert_dialog.dart';
import 'package:booking_app_client/widgets_model/custom_list_tilr_profile.dart';
import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:booking_app_client/widgets_model/main_drawer.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyReservedDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DoubleBack(
          child: Consumer<MainProvider>(
        builder: (context, valueMain, child) => Scaffold(
          appBar: AppBar(
            title: Text('My Reserved Devices'),
            // centerTitle: true,
          ),
          body: valueMain.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : valueMain.reservedDevicesList.isEmpty
                  ? Center(
                      child: CustomText(
                        text: 'No device booked yet',
                        fontSize: 22,
                        alignment: Alignment.center,
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) => CustomListTileProfile(
                            title:
                                valueMain.reservedDevicesList[index].deviceName,
                            titleColor: Colors.black,
                            leading: CircleAvatar(
                              child: FittedBox(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    valueMain.reservedDevicesList[index].type),
                              )),
                            ),
                            subtitle: 'From: ' +
                                DateFormat().add_yMd().format(DateTime.parse(
                                    valueMain
                                        .reservedDevicesList[index].startDate)) +
                                '\nTo: ' +
                                DateFormat().add_yMd().format(DateTime.parse(
                                    valueMain
                                        .reservedDevicesList[index].endDate)),
                            subtitleColor: Colors.grey,
                            trailing: IconButton(
                              icon: Icon(Icons.remove_circle),
                              color: KPrimaryColor,
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                          title: 'Are you sure!',
                                          content: 'Remove the reservation ?',
                                          onPressedYes: () {
                                            valueMain
                                                .unBookedDevice(valueMain
                                                    .reservedDevicesList[index])
                                                .then((value) async{
                                              await valueMain.getDevices();
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          onPressedNo: () =>
                                              Navigator.of(context).pop(),
                                        ));
                              },
                            ),
                          ),
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: valueMain.reservedDevicesList.length),
          drawer: MainDrawer(),
        ),
      ),
    );
  }
}
