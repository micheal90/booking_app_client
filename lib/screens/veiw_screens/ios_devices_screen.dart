import 'package:booking_app_client/providers/main_provider.dart';
import 'package:booking_app_client/screens/veiw_screens/device_details_screen.dart';
import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:booking_app_client/widgets_model/device_item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';

class IosDevicesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, valueMain, child) => Scaffold(
        appBar: AppBar(
          title: Text("IOS Devices"),
          
        ),
        body: valueMain.iosDevicesList.isEmpty
            ? Center(
                child: CustomText(
                  text: 'No devices'.tr,
                  alignment: Alignment.center,
                  fontSize: 22,
                ),
              )
            : Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisExtent: 200,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) =>  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DeviceDetailsScreen(
                            deviceId: valueMain.iosDevicesList[index].id))),
                    child: DeviceItemView(
                        imageUrl: valueMain.iosDevicesList[index].imageUrl[0],
                        available: valueMain.iosDevicesList[index].isBooked,
                        name: valueMain.iosDevicesList[index].name,
                        screenSize: valueMain.iosDevicesList[index].screenSize),
                  ),
            itemCount:  valueMain.iosDevicesList.length,
          ),
        ),
      ),
    );
  }
}
