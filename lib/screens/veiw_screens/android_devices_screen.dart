import 'package:booking_app_client/providers/main_provider.dart';
import 'package:booking_app_client/screens/veiw_screens/device_details_screen.dart';
import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:booking_app_client/widgets_model/device_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AndroidDevicesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, valueMain, child) => Scaffold(
        appBar: AppBar(
          title:  Text("Android Devices"),
          
         
        ),
        body: valueMain.androidDevicesList.isEmpty
            ? Center(
                child: CustomText(
                  text: 'No devices',
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
                            deviceId: valueMain.androidDevicesList[index].id))),
                    child: DeviceItemView(
                        imageUrl:
                            valueMain.androidDevicesList[index].imageUrl[0],
                        name: valueMain.androidDevicesList[index].name,
                        available: valueMain.androidDevicesList[index].isBooked,
                        screenSize:
                            valueMain.androidDevicesList[index].screenSize),
                  ),
            itemCount:  valueMain.androidDevicesList.length,
          ),
        ),
      ),
    );
  }
}
